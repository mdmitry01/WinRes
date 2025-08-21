import SwiftUI
import KeyboardShortcuts

struct MapKeyboardShortcutsView: View {
    @ObservedObject var model: MapKeyboardShortcutsModel
    
    var body: some View {
        Form {
            KeyboardShortcuts.Recorder("Shortcut", name: model.shortcutName)
            TextField("Key", text: $model.keyCharacter).textFieldStyle(RoundedBorderTextFieldStyle())
            HStack(spacing: 16) {
                Toggle("⌃", isOn: $model.includesControlModifier)
                Toggle("⌥", isOn: $model.includesOptionModifier)
                Toggle("⌘", isOn: $model.includesCommandModifier)
                Toggle("⇧", isOn: $model.includesShiftModifier)
            }
        }
    }
}
