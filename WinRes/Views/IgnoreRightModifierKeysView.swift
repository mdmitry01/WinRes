import SwiftUI
import KeyboardShortcuts

struct IgnoreRightModifierKeysView: View {
    @ObservedObject var model: IgnoreRightModifierKeysModel
    
    var body: some View {
        Form {
            Toggle("Ignore right modifier keys", isOn: $model.ignoresRightModifierKeys)
        }
    }
}
