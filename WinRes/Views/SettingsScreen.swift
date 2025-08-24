import SwiftUI
import KeyboardShortcuts

struct SettingsScreen: View {
    let applicationSwitcherModels: [ApplicationSwitcherModel]
    let mapKeyboardShortcutsModels: [MapKeyboardShortcutsModel]
    let ignoreModifierKeysModel: IgnoreModifierKeysModel
    let appVersion = Bundle.main.appVersion ?? "unknown"
    
    var body: some View {
        VStack(spacing: 0) {
            TabView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("App shortcuts")
                                .font(.system(.title3))
                                .fontWeight(.bold)
                                .padding(.top, 10)
                            Text("Switch to an app using a global keyboard shortcut.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        ForEach(applicationSwitcherModels, id: \.id) { model in
                            GroupBox {
                                ApplicationSwitcherView(model: model)
                            }
                        }

                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .tabItem {
                    Label("App shortcuts", systemImage: "keyboard")
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Map shortcuts")
                                .font(.system(.title3))
                                .fontWeight(.bold)
                                .padding(.top, 10)
                            Text("Remap a shortcut to a key press with chosen modifiers.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        ForEach(mapKeyboardShortcutsModels, id: \.id) { model in
                            GroupBox {
                                MapKeyboardShortcutsView(model: model)
                            }
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .tabItem {
                    Label("Map shortcuts", systemImage: "link")
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Settings")
                                .font(.system(.title3))
                                .fontWeight(.bold)
                                .padding(.top, 10)
                            Text("Choose modifier keys to ignore when detecting shortcuts.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        GroupBox {
                            IgnoreModifierKeysView(model: self.ignoreModifierKeysModel)
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
            }
            .padding(.top, 6)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        Divider()

        HStack {
            Spacer()
            Text("WinRes v\(self.appVersion)")
                .font(.footnote)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal)
    }
}
