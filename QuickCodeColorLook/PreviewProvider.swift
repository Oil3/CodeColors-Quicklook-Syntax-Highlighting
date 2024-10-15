import QuickLook
import QuickLookUI
import SwiftUI
import AppKit

class PreviewProvider: QLPreviewProvider {
  func providePreview(for request: QLFilePreviewRequest, handler: @escaping (QLPreviewReply?, Error?) -> Void) {
    
    DispatchQueue.global(qos: .userInitiated).async {
      // Define the maximum file size (e.g., 5 MB)
      let maxFileSize: Int64 = 5 * 1024 * 1024 // 5 MB
      
      // Check file size
      let fileSize = (try? request.fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
      if Int64(fileSize) > maxFileSize {
        DispatchQueue.main.async {
          handler(nil, nil) // Skip processing large files
        }
        return
      }
      
      // Read the file content
      guard let content = try? String(contentsOf: request.fileURL, encoding: .utf8) else {
        handler(nil, nil)
        return
      }
      
      // Determine the file type
      let fileExtension = request.fileURL.pathExtension.lowercased()
      guard fileExtension == "py" || fileExtension == "yaml" || fileExtension == "yml" else {
        handler(nil, nil)
        return
      }
      
      // Apply syntax highlighting
      let highlightedContent = SyntaxHighlighter.highlight(content: content, fileExtension: fileExtension)
      
      // Create the SwiftUI view
      let view = ContentView(content: highlightedContent)
      
      // Create a QLPreviewReply with the SwiftUI view
      let reply = QLPreviewReply(contextSize: CGSize(width: 800, height: 600), isBitmap: true) { (context, replyHandler) in
        
        // Set up the NSGraphicsContext
        NSGraphicsContext.saveGraphicsState()
        let nsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.current = nsContext
        
        // Render the SwiftUI view
        let hostingController = NSHostingController(rootView: view)
        hostingController.view.frame = CGRect(origin: .zero, size: CGSize(width: 800, height: 600))
        hostingController.view.layoutSubtreeIfNeeded()
        hostingController.view.draw(hostingController.view.bounds)
        
        // Clean up
        NSGraphicsContext.restoreGraphicsState()
        replyHandler
      }
      
      handler(reply, nil)
    }
  }
}

struct ContentView: View {
  let content: AttributedString
  
  var body: some View {
    ScrollView([.vertical, .horizontal]) {
      Text(content)
        .font(.system(size: 12, weight: .regular, design: .monospaced))
        .padding()
        .background(Color(NSColor.textBackgroundColor))
    }
  }
}
