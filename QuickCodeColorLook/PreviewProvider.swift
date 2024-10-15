import QuickLook
import QuickLookUI
import SwiftUI
import AppKit

class PreviewProvider: QLPreviewProvider {
  func providePreview(for request: QLFilePreviewRequest, handler: @escaping (QLPreviewReply?, Error?) -> Void) {
}
}
// ContentView.swift

import SwiftUI

struct ContentView: View {
  @ObservedObject var loader: CodeContentLoader
  @State private var fontSize: CGFloat = 12.0
  
  var body: some View {
    ScrollView([.vertical, .horizontal]) {
      Text(loader.attributedContent)
        .font(.system(size: fontSize, weight: .regular, design: .monospaced))
        .textSelection(.enabled)
        .padding()
    }
    .gesture(MagnificationGesture()
      .onChanged { value in
        self.fontSize = max(8.0, min(24.0, 12.0 * value))
      })
  }
}
