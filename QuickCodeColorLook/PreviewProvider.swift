import QuickLook
import QuickLookUI
import SwiftUI
import AppKit

class PreviewProvider: QLPreviewProvider {
  func providePreview(for request: QLFilePreviewRequest, handler: @escaping (QLPreviewReply?, Error?) -> Void) {
}
}
struct ContentView: View {
@ObservedObject var loader: CodeContentLoader
@State private var fontSize: CGFloat = 12.0

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading, spacing: 0) {
        ForEach(loader.attributedLines.indices, id: \.self) { index in
          HStack(alignment: .top, spacing: 5) 
          {
            Text("\(index + 1)")
              .font(.system(size: fontSize, weight: .regular, design: .monospaced))
              .foregroundColor(.gray)
              .frame(width: 40, alignment: .trailing)
              .padding(.trailing, 5)
    //need to fix so we can select multiple lines, and having line numbers without including them in the selection, while keeping lazy loading
            Text(loader.attributedLines[index])
              .font(.system(size: fontSize, weight: .regular, design: .monospaced))
          }
          .textSelection(.enabled)

        }
      }
      .padding()
    }
    .gesture(MagnificationGesture()
      .onChanged { value in
        self.fontSize = max(8.0, min(24.0, 12.0 * value))
      })
  }

}
