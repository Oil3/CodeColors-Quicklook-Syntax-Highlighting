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
        VStack {
            if loader.isLoading {
                ProgressView(value: loader.progress, total: 1.0)
                    .padding()
                Text("Loading...")
            } else if let error = loader.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 2) {
                        ForEach(0..<loader.totalLines, id: \.self) { lineIndex in
                            Text(loader.getLine(at: lineIndex))
                                .font(.system(size: fontSize, weight: .regular, design: .monospaced))
                                .padding(.horizontal)
                                .onAppear {
                                    loader.loadNextBatchIfNeeded(currentIndex: lineIndex)
                                }
                        }
                    }
                }
                .gesture(MagnificationGesture()
                    .onChanged { value in
                        self.fontSize = max(8.0, min(24.0, 12.0 * value))
                    })
            }
        }
    }
}
