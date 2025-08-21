import SwiftUI
import KeyboardShortcuts

struct IgnoreModifierKeysView: View {
    @ObservedObject var model: IgnoreModifierKeysModel
    
    var body: some View {
        Form {
            Toggle("Ignore left shift", isOn: $model.ignoresLeftShift)
            Toggle("Ignore right shift", isOn: $model.ignoresRightShift)
            Toggle("Ignore left option", isOn: $model.ignoresLeftOption)
            Toggle("Ignore right option", isOn: $model.ignoresRightOption)
            Toggle("Ignore left control", isOn: $model.ignoresLeftControl)
            Toggle("Ignore right control", isOn: $model.ignoresRightControl)
            Toggle("Ignore left command", isOn: $model.ignoresLeftCommand)
            Toggle("Ignore right command", isOn: $model.ignoresRightCommand)
        }
    }
}
