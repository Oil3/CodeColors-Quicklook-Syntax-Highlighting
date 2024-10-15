import SwiftUI
import Combine

class CodeContentLoader: ObservableObject {
  @Published var attributedLines: [AttributedString] = []
  @Published var isLoading = false
  @Published var totalLines = 0
  @Published var fileSize: Int64 = 0
  
  private var shouldCancel = false
  
  func loadFile(at url: URL, maxFileSize: Int64 = 5 * 1024 * 1024) {
    self.isLoading = true
    self.shouldCancel = false
    self.attributedLines = []
    
    // Check file size
    if let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize {
      self.fileSize = Int64(fileSize)
      if self.fileSize > maxFileSize {
        DispatchQueue.main.async {
          self.isLoading = false
        }
        return
      }
    }
    
    let fileExtension = url.pathExtension.lowercased()
    
    DispatchQueue.global(qos: .userInitiated).async {
      guard let reader = LineReader(url: url) else {
        DispatchQueue.main.async {
          self.isLoading = false
        }
        return
      }
      
      defer {
        reader.close()
      }
      
      while let line = reader.nextLine() {
        if self.shouldCancel {
          break
        }
        
        let attributedLine = SyntaxHighlighter.highlightLine(line: line, fileExtension: fileExtension)
        
        DispatchQueue.main.async {
          self.attributedLines.append(attributedLine)
          self.totalLines = self.attributedLines.count
        }
      }
      
      DispatchQueue.main.async {
        self.isLoading = false
      }
    }
  }
  
  func cancelLoading() {
    shouldCancel = true
  }
}
