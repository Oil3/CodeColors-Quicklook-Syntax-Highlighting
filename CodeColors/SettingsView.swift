import SwiftUI

struct SettingsView: View {
  @ObservedObject var settings = SyntaxSettings.shared
  
  var body: some View {
    Form {
      ForEach(settings.syntaxColors.keys.sorted(), id: \.self) { key in
        HStack {
          Text(key.capitalized)
          Spacer()
          ColorPicker("", selection: Binding(
            get: { settings.syntaxColors[key] ?? .black },
            set: { settings.syntaxColors[key] = $0 }
          ))
          .labelsHidden()
        }
      }
      HStack {
        Button("Reset to Default") {
          settings.resetToDefault()
        }
        Spacer()
        Button("Save") {
          settings.saveSettings()
        }
      }
    }
    .padding()
    .frame(width: 400)
  }
}


