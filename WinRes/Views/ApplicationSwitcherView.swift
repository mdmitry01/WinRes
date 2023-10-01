import SwiftUI
import KeyboardShortcuts

struct ApplicationSwitcherView: View {
    @ObservedObject var model: ApplicationSwitcherModel
    
    var body: some View {
        Form {
            TextField("App bundle ID", text: $model.appBundleId)
            KeyboardShortcuts.Recorder("Shortcut", name: model.shortcutName)
            Toggle("Open a new window", isOn: $model.opensNewWindow)
        }
    }
}
