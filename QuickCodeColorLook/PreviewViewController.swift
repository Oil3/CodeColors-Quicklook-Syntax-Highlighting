// PreviewViewController.swift

import Cocoa
import QuickLook
import WebKit
import QuickLookUI

class PreviewViewController: NSViewController, QLPreviewingController {
  var webView: WKWebView!
  
  override func loadView() {
    self.view = NSView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Initialize the WKWebView
    webView = WKWebView(frame: self.view.bounds)
    webView.autoresizingMask = [.width, .height]
    self.view.addSubview(webView)
    print("zzz zzzzzzzzzzz")
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
      
      // Escape and highlight the content
      let highlightedHTML = self.generateHTML(for: content)
      
      // Load the HTML into the WKWebView on the main thread
      DispatchQueue.main.async {
        self.webView.loadHTMLString(highlightedHTML, baseURL: nil)
        handler(nil)
      }
    }
  }
}

extension PreviewViewController {
  func generateHTML(for content: String) -> String {
    // Escape HTML special characters
    var escapedContent = content
      .replacingOccurrences(of: "&", with: "&amp;")
      .replacingOccurrences(of: "<", with: "&lt;")
      .replacingOccurrences(of: ">", with: "&gt;")
      .replacingOccurrences(of: "\"", with: "&quot;")
      .replacingOccurrences(of: "'", with: "&#39;")
    
    // Apply syntax highlighting
    escapedContent = applySyntaxHighlighting(to: escapedContent)
    
    // HTML Template
    let htmlTemplate = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
            <style>
                body {
                    font-family: Menlo, monospace;
                    font-size: 12px;
                    background-color: #f5f5f5;
                    color: #333;
                    padding: 10px;
                    word-wrap: break-word;
                }
                pre {
                    white-space: pre-wrap;
                }
                .string { color: lightblue; }
                .number { color: orange; }
                .boolean { color: darkblue; }
            </style>
        </head>
        <body>
            <pre><code>\(escapedContent)</code></pre>
        </body>
        </html>
        """
    return htmlTemplate
  }
  
  func applySyntaxHighlighting(to content: String) -> String {
    let patterns: [(pattern: String, cssClass: String)] = [
      ("(\"[^\"]*\"|'[^']*')", "string"),
      ("\\b\\d+(?:\\.\\d+)?\\b", "number"),
      ("\\b(?:True|False|true|false)\\b", "boolean")
    ]
    
    // Combine patterns into one regex with capture groups
    let combinedPattern = patterns.map { "(\($0.pattern))" }.joined(separator: "|")
    
    guard let regex = try? NSRegularExpression(pattern: combinedPattern, options: []) else {
      return content
    }
    
    let nsContent = content as NSString
    let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length))
    
    var lastIndex = 0
    var result = ""
    
    for match in matches {
      let matchRange = match.range
      
      // Append text before the match
      if matchRange.location > lastIndex {
        let range = NSRange(location: lastIndex, length: matchRange.location - lastIndex)
        let text = nsContent.substring(with: range)
        result += text
      }
      
      // Determine which group matched
      var matchedCssClass = ""
      for (index, (_, cssClass)) in patterns.enumerated() {
        if match.range(at: index + 1).location != NSNotFound {
          matchedCssClass = cssClass
          break
        }
      }
      
      // Append the matched text with span
      let matchedText = nsContent.substring(with: matchRange)
      result += "<span class=\"\(matchedCssClass)\">\(matchedText)</span>"
      
      lastIndex = matchRange.location + matchRange.length
    }
    
    // Append remaining text
    if lastIndex < nsContent.length {
      let range = NSRange(location: lastIndex, length: nsContent.length - lastIndex)
      let text = nsContent.substring(with: range)
      result += text
    }
    
    return result
  }
}
