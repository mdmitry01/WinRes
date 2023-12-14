import SwiftUI
import KeyboardShortcuts

struct SettingsScreen: View {
    let switchWindowsShortcutModels: [ApplicationSwitcherModel]
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    
    var body: some View {
        ScrollView {
            VStack() {
                Section {
                    Text("WinRes v\(self.appVersion)")
                        .font(.system(.title2))
                        .fontWeight(.bold)
                }
                Divider()
                Section {
                    Text("Window shortcuts")
                        .font(.system(.title3))
                        .fontWeight(.bold)
                }.padding(.top, 7)
                Form {
                    KeyboardShortcuts.Recorder(for: .zoomActiveWindow) {
                        Text("Zoom active window")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Form {
                    KeyboardShortcuts.Recorder(for: .minimizeActiveWindow) {
                        Text("Minimize active window")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Form {
                    KeyboardShortcuts.Recorder(for: .moveActiveWindowToLeftSide) {
                        Text("Move active window to the left side of the screen")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Form {
                    KeyboardShortcuts.Recorder(for: .moveActiveWindowToRightSide) {
                        Text("Move active window to the right side of the screen")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Section {
                    Text("Switch to an app using keyboard")
                        .font(.system(.title3))
                        .fontWeight(.bold)
                }.padding(.top, 10.0)
                Divider()
                ForEach(switchWindowsShortcutModels, id: \.id) { model in
                    ApplicationSwitcherView(model: model)
                    Divider()
                }
            }
            .padding()
        }
    }
}
