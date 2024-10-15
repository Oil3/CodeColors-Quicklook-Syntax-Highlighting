import AppKit

class SyntaxRules {
  static let shared = SyntaxRules()
  
  private var allRules: [String: [(pattern: String, color: NSColor)]]
  private let commonRules: [(pattern: String, color: NSColor)]
  
  private init() {
    self.commonRules = [
      // Strings
      ("(\"[^\"]*\"|'[^']*')", NSColor.systemTeal),
      // Numbers (including negative numbers)
      ("\\b-?\\d+(?:\\.\\d+)?\\b", NSColor.orange),
      // Booleans
      ("\\b(?:True|False|true|false)\\b", NSColor.systemBlue),
      // Comments
      ("#.*", NSColor.green),
      ("\"\"\".*?\"\"\"", NSColor.green),

      // Python
      ("\\b(def|class|if|else|elif|return|import|from|as|for|while|try|except|with|lambda|pass|break|continue|yield|assert|async|await)\\b", NSColor.systemPurple),
      
    ]
    
    let swiftKeywords = [
      "class", "struct", "enum", "func", "let", "var", "if", "else", "switch",
      "case", "default", "break", "continue", "return", "for", "while", "repeat",
      "do", "try", "catch", "throw", "throws", "rethrows", "import", "as", "in",
      "is", "nil", "true", "false", "public", "private", "fileprivate", "internal",
      "open", "static", "extension", "protocol", "guard", "defer", "where",
      "associatedtype", "inout", "operator", "init", "super", "self", "Type",
      "typealias", "Any", "dynamicType", "return", "->",
      "HStack", "VStack", "ScrollView", "LazyVStack", "LazyHStack", "View", "List", "Grid"

    ]
    let swiftKeywordPattern = "\\b(\(swiftKeywords.joined(separator: "|")))\\b"
    
    let swiftRules: [(pattern: String, color: NSColor)] = [
      // Strings
      ("(\"[^\"]*\"|'[^']*')", NSColor.systemTeal),
      // Numbers (including negative numbers)
      ("\\b-?\\d+(?:\\.\\d+)?\\b", NSColor.orange),
      // Keywords
      (swiftKeywordPattern, NSColor.systemPurple),
      // Comments (single line)
      ("//.*", NSColor.green),
      // Comments (multi-line)
      ("/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/", NSColor.green),
      ("\"\"\".*?\"\"\"", NSColor.green),

    ]
    
    let htmlRules: [(pattern: String, color: NSColor)] = [
      // Tags
      ("</?[a-zA-Z][^>]*>", NSColor.systemPurple),
      // Attributes
      ("\\b[a-zA-Z-]+(?=\\=)", NSColor.systemBlue),
      // Attribute values
      ("(\"[^\"]*\"|'[^']*')", NSColor.systemTeal),
      // Comments
      ("<!--.*?-->", NSColor.green)
    ]
    
    self.allRules = [
      "py": commonRules,
      "yaml": commonRules,
      "yml": commonRules,
      "swift": swiftRules,
      "html": htmlRules,
      "xml": htmlRules
    ]
  }
  
  func rules(for fileExtension: String) -> [(pattern: String, color: NSColor)] {
    return allRules[fileExtension] ?? commonRules
  }
}
