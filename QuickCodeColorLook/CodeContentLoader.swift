// CodeContentLoader.swift

import SwiftUI
import Combine

class CodeContentLoader: ObservableObject {
  @Published var attributedContent: AttributedString = AttributedString()
  @Published var isLoading = false
  @Published var totalLines = 0
  @Published var fileSize: Int64 = 0
  
  private var shouldCancel = false
  
  func loadFile(at url: URL, maxFileSize: Int64 = 50 * 1024 * 1024) {
    self.isLoading = true
    self.shouldCancel = false
    self.attributedContent = AttributedString()
    
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
      
      var lineNumber = 1
      
      while let line = reader.nextLine() {
        if self.shouldCancel {
          break
        }
        
        // Highlight the line
        var attributedLine = SyntaxHighlighter.highlightLine(line: line, fileExtension: fileExtension)
        
        // Prepend line number
//        var lineNumberString = AttributedString("\(lineNumber)  ")
        //        lineNumberString.foregroundColor = .gray
        
        lineNumber += 1
        
        // Combine line number and content
//        lineNumberString.append(attributedLine)
        // Append newline character
        attributedLine.append(AttributedString("\n"))
        
        DispatchQueue.main.async {
          self.attributedContent.append(attributedLine)
          self.totalLines = lineNumber - 1
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
//
//  Copyright Almahdi Morris Quet 2024
//
