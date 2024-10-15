import SwiftUI
import Combine

class SyntaxSettings: ObservableObject {
  static let shared = SyntaxSettings()
  let userDefaults = UserDefaults(suiteName: "com.oil3.codecolors")
  
  @Published var syntaxColors: [String: Color] = [:]
  
  private init() {
    loadSettings()
  }
  
  func loadSettings() {
    if let data = userDefaults?.data(forKey: "syntaxColors"),
       let savedColors = try? JSONDecoder().decode([String: CodableColor].self, from: data) {
      self.syntaxColors = savedColors.mapValues { $0.color }
    } else {
      // Load default colors
      syntaxColors = SyntaxSettings.defaultColors
    }
  }
  
  func saveSettings() {
    let codableColors = syntaxColors.mapValues { CodableColor(color: $0) }
    if let data = try? JSONEncoder().encode(codableColors) {
      userDefaults?.set(data, forKey: "syntaxColors")
    }
  }
  
  func resetToDefault() {
    syntaxColors = SyntaxSettings.defaultColors
    saveSettings()
  }
  
  static let defaultColors: [String: Color] = [
    "string": .teal,
    "number": .orange,
    "boolean": .blue,
    "keyword": .purple,
    "comment": .green,
    // need add more default colors
  ]
}

struct CodableColor: Codable {
  let color: Color
  
  enum CodingKeys: CodingKey {
    case red, green, blue, opacity
  }
  
  init(color: Color) {
    let components = color.components
    self.color = Color(red: components.red, green: components.green, blue: components.blue, opacity: components.opacity)
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let red = try container.decode(Double.self, forKey: .red)
    let green = try container.decode(Double.self, forKey: .green)
    let blue = try container.decode(Double.self, forKey: .blue)
    let opacity = try container.decode(Double.self, forKey: .opacity)
    color = Color(red: red, green: green, blue: blue, opacity: opacity)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    let components = color.components
    try container.encode(components.red, forKey: .red)
    try container.encode(components.green, forKey: .green)
    try container.encode(components.blue, forKey: .blue)
    try container.encode(components.opacity, forKey: .opacity)
  }
}

extension Color {
  var components: (red: Double, green: Double, blue: Double, opacity: Double) {
#if os(macOS)
    let nsColor = NSColor(self)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var opacity: CGFloat = 0
    nsColor.getRed(&red, green: &green, blue: &blue, alpha: &opacity)
    return (Double(red), Double(green), Double(blue), Double(opacity))
#else
    // iOS placeholder
#endif
  }
}


//
//  Copyright Almahdi Morris Quet 2024
//
