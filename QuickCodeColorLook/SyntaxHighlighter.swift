import SwiftUI

struct SyntaxHighlighter {
    static func highlightLine(line: String, fileExtension: String) -> AttributedString {
        var lineAttributedString = AttributedString(line)
        applySyntaxHighlighting(to: &lineAttributedString, fileExtension: fileExtension)
        return lineAttributedString
    }
    
    static func applySyntaxHighlighting(to attributedString: inout AttributedString, fileExtension: String) {
        let nsString = String(attributedString.characters) as NSString
        let wholeRange = NSRange(location: 0, length: nsString.length)
        let patterns = SyntaxRules.shared.rules(for: fileExtension)
        
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

//
//  Copyright Almahdi Morris Quet 2024-2025
//
