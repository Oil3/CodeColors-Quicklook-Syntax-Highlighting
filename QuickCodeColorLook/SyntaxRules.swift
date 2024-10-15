// SyntaxRules.swift

import AppKit

class SyntaxRules {
  static let shared = SyntaxRules()
  
  let rules: [(pattern: String, color: NSColor)]
  
  private init() {
    rules = [
      // Strings
      ("(\"[^\"]*\"|'[^']*')", NSColor.systemTeal),
      // Numbers
      ("\\b\\d+(?:\\.\\d+)?\\b", NSColor.orange),
      // Python
      ("\\b(def|class|if|else|elif|return|import|from|as|for|while|try|except|with|lambda|pass|break|continue|yield|assert|async|await)\\b", NSColor.systemPurple),
      // Booleans
      ("\\b(?:True|False|true|false)\\b", NSColor.systemBlue),
      // &
    ]
  }
}
