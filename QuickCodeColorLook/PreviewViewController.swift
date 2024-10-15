import Cocoa
import QuickLookUI
import SwiftUI

class PreviewViewController: NSViewController, QLPreviewingController {
  var contentView: NSHostingView<ContentView>?
  let loader = CodeContentLoader()
  
  override func loadView() {
    self.view = NSView()
  }
  
  func preparePreviewOfFile(at fileURL: URL, completionHandler handler: @escaping (Error?) -> Void) {
    // Cancel any ongoing loading
    loader.cancelLoading()
    // Start loading the new file
    loader.loadFile(at: fileURL)
    
    DispatchQueue.main.async {
      // Remove existing content view if any
      self.contentView?.removeFromSuperview()
      
      // Embed the SwiftUI view into NSHostingView
      let hostingView = NSHostingView(rootView: ContentView(loader: self.loader))
      hostingView.frame = self.view.bounds
      hostingView.autoresizingMask = [.width, .height]
      self.view.addSubview(hostingView)
      self.contentView = hostingView
      
      handler(nil)
    }
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
    loader.cancelLoading()
  }
}
