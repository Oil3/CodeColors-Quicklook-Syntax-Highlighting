import SwiftUI
import Combine

class CodeContentLoader: ObservableObject {
    @Published var attributedContent: AttributedString = AttributedString()
    @Published var isLoading = false
    @Published var totalLines = 0
    @Published var progress: Double = 0.0
    @Published var errorMessage: String? = nil
    
    private var shouldCancel = false
    private var cachedLines: [AttributedString] = []
    private var reader: LineReader?
    private let batchSize = 100
    private let preloadThreshold = 20
    private let maxLines = 10_000

    func loadFile(at url: URL, maxFileSize: Int64 = 5 * 1024 * 1024) {
        cleanup() // Reset the loader
        
        // Check file size
        if let fileSize = try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize {
            if Int64(fileSize) > maxFileSize {
                DispatchQueue.main.async {
                    self.errorMessage = "File size exceeds the preview limit of \(maxFileSize / 1024 / 1024) MB."
                    self.isLoading = false
                }
                return
            }
        }
        
        let fileExtension = url.pathExtension.lowercased()
        self.isLoading = true
        self.shouldCancel = false

        DispatchQueue.global(qos: .userInitiated).async {
            guard let reader = LineReader(url: url) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Unable to open file. Unsupported format or corrupt file."
                    self.isLoading = false
                }
                return
            }
            self.reader = reader
            self.processLines(fileExtension: fileExtension)
        }
    }
    
    private func processLines(fileExtension: String) {
        var lineNumber = 0
        var batch = [AttributedString]()
        
        while !shouldCancel {
            guard let line = reader?.nextLine() else { break }
            let highlightedLine = SyntaxHighlighter.highlightLine(line: line, fileExtension: fileExtension)
            batch.append(highlightedLine)
            lineNumber += 1
            
            if batch.count >= batchSize {
                appendBatch(batch, lineNumber: lineNumber)
                batch.removeAll()
            }

            // Stop processing if max lines are reached
            if lineNumber >= maxLines {
                DispatchQueue.main.async {
                    self.errorMessage = "Preview truncated to \(self.maxLines) lines."
                    self.isLoading = false
                }
                break
            }
        }
        
        if !batch.isEmpty {
            appendBatch(batch, lineNumber: lineNumber)
        }
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    private func appendBatch(_ batch: [AttributedString], lineNumber: Int) {
        DispatchQueue.main.async {
            self.cachedLines.append(contentsOf: batch)
            self.totalLines = lineNumber
            self.progress = Double(lineNumber) / Double(self.maxLines)
        }
    }
    
    func getLine(at index: Int) -> AttributedString {
        guard index >= 0 && index < cachedLines.count else {
            return AttributedString("")
        }
        return cachedLines[index]
    }
    
    func loadNextBatchIfNeeded(currentIndex: Int) {
        guard currentIndex >= totalLines - preloadThreshold, !isLoading else { return }
        processLines(fileExtension: "swift") // Replace with the actual file extension
    }
    
    func cancelLoading() {
        shouldCancel = true
        cleanup()
    }
    
    private func cleanup() {
        shouldCancel = true
        reader?.close()
        reader = nil
        cachedLines.removeAll()
        attributedContent = AttributedString()
        isLoading = false
        totalLines = 0
        progress = 0.0
        errorMessage = nil
    }
}
//
//  Copyright Almahdi Morris Quet 2024-2025
//
