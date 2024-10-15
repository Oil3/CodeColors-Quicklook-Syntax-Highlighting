import SwiftUI

struct SyntaxHighlighter {
  static func highlight(content: String, fileExtension: String) -> AttributedString {
    var attributedString = AttributedString()
    let lines = content.components(separatedBy: .newlines)
    let newline = AttributedString("\n")
    
    for line in lines {
      var lineAttributedString = AttributedString(line)
      applySyntaxHighlighting(to: &lineAttributedString)
      attributedString += lineAttributedString + newline
    }
    
    return attributedString
  }
  
  static func applySyntaxHighlighting(to attributedString: inout AttributedString) {
    let nsString = String(attributedString.characters) as NSString
    let wholeRange = NSRange(location: 0, length: nsString.length)
    
    // syntax rules
    let patterns = SyntaxRules.shared.rules
    
    for (pattern, color) in patterns {
      if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
        let matches = regex.matches(in: nsString as String, options: [], range: wholeRange)
        for match in matches {
          if let range = Range(match.range, in: attributedString) {
            attributedString[range].foregroundColor = Color(color)
          }
        }
      }
    }
  }
}
