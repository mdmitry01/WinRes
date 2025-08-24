import SwiftUI
import KeyboardShortcuts

struct ApplicationSwitcherView: View {
    @ObservedObject var model: ApplicationSwitcherModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("App bundle ID")
                TextField("App bundle ID", text: $model.appBundleId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            HStack {
                KeyboardShortcuts.Recorder("Shortcut", name: model.shortcutName)
            }

            Toggle("Open a new window", isOn: $model.opensNewWindow)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

}
