// PreviewViewController.swift

import Cocoa
import QuickLookUI
import SwiftUI

class PreviewViewController: NSViewController, QLPreviewingController {
  var contentView: NSHostingView<ContentView>?
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func preparePreviewOfFile(at fileURL: URL, completionHandler handler: @escaping (Error?) -> Void) {
    DispatchQueue.global(qos: .userInitiated).async {
      // Read the file content
      guard let content = try? String(contentsOf: fileURL, encoding: .utf8) else {
        DispatchQueue.main.async {
          handler(nil)
        }
        return
      }
      
      // Determine the file type
      let fileExtension = fileURL.pathExtension.lowercased()
      guard fileExtension == "py" || fileExtension == "yaml" || fileExtension == "yml" else {
        DispatchQueue.main.async {
          handler(nil)
        }
        return
      }
      
      // Apply syntax highlighting
      let highlightedContent = SyntaxHighlighter.highlight(content: content, fileExtension: fileExtension)
      
      // Create the SwiftUI view
      let swiftUIView = ContentView(content: highlightedContent)
      
      DispatchQueue.main.async {
        // Remove existing content view if any
        self.contentView?.removeFromSuperview()
        
        // Embed the SwiftUI view into NSHostingView
        let hostingView = NSHostingView(rootView: swiftUIView)
        hostingView.frame = self.view.bounds
        hostingView.autoresizingMask = [.width, .height]
        self.view.addSubview(hostingView)
        self.contentView = hostingView
        
        handler(nil)
      }
    }
  }
}
