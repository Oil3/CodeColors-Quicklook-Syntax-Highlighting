// PreviewProvider.swift

import QuickLookUI
import QuickLook
import SwiftUI

class PreviewProvider: QLPreviewProvider {
  func providePreview(for request: QLFilePreviewRequest, handler: @escaping (QLPreviewReply?, Error?) -> Void) {
    
    DispatchQueue.global(qos: .userInitiated).async {
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
      let reply = QLPreviewReply(contextSize: CGSize(width: 800, height: 600), isBitmap: false) { (context, replyHandler) in
        let hostingController = NSHostingController(rootView: view)
        hostingController.view.frame = .zero
        
        // Render the SwiftUI view into the graphics context
        
        replyHandler
      }
      
      handler(reply, nil)
    }
  }
}

struct ContentView: View {
  let content: AttributedString
  
  var body: some View {
    ScrollView {
      Text(content)
        .font(.system(size: 12, weight: .regular, design: .monospaced))
        .padding()
        .background(Color(NSColor.textBackgroundColor))
    }
  }
}

struct SyntaxHighlighter {
  static func highlight(content: String, fileExtension: String) -> AttributedString {
    var attributedString = AttributedString(content)
    let nsString = content as NSString
    let wholeRange = NSRange(location: 0, length: nsString.length)
    
    // Define regex patterns
    let patterns: [(pattern: String, color: NSColor)] = [
      ("(\"[^\"]*\"|'[^']*')", NSColor.systemTeal),          // Strings in light blue
      ("\\b\\d+(?:\\.\\d+)?\\b", NSColor.orange),            // Numbers in orange
      ("\\b(?:True|False|true|false)\\b", NSColor.systemBlue) // Booleans in dark blue
    ]
    
    for (pattern, color) in patterns {
      if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
        let matches = regex.matches(in: content, options: [], range: wholeRange)
        for match in matches {
          if let range = Range(match.range, in: attributedString) {
            attributedString[range].foregroundColor = Color(color)
          }
        }
      }
    }
    
    return attributedString
  }
}
