import SwiftUI

struct SyntaxHighlighter {
  static func highlight(content: String, fileExtension: String) -> AttributedString {
    var attributedString = AttributedString()
    let lines = content.components(separatedBy: .newlines)
    let newline = AttributedString("\n")
    
    for line in lines {
      var lineAttributedString = AttributedString(line)
      applySyntaxHighlighting(to: &lineAttributedString, fileExtension: fileExtension)
      attributedString += lineAttributedString + newline
    }
    
    return attributedString
  }
  
  static func highlightLine(line: String, fileExtension: String) -> AttributedString {
    var lineAttributedString = AttributedString(line)
    applySyntaxHighlighting(to: &lineAttributedString, fileExtension: fileExtension)
    return lineAttributedString
  }
  
  static func applySyntaxHighlighting(to attributedString: inout AttributedString, fileExtension: String) {
    let nsString = String(attributedString.characters) as NSString
    let wholeRange = NSRange(location: 0, length: nsString.length)
    
    // Use the shared syntax rules
    let patterns = SyntaxRules.shared.rules(for: fileExtension)
    //let settings = SyntaxSettings.shared //to do

    for (pattern, color) in patterns {
      if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
        let matches = regex.matches(in: nsString as String, options: [], range: wholeRange)
        for match in matches {
          let matchRange = match.range
          if let range = Range(matchRange, in: attributedString) {
            attributedString[range].foregroundColor = Color(color)
          }
        }
      }
    }
  }
}
