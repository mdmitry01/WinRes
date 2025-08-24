import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let zoomActiveWindow = Self("zoomActiveWindow")
    static let minimizeActiveWindow = Self("minimizeActiveWindow")
    static let moveActiveWindowToLeftSide = Self("moveActiveWindowToLeftSide")
    static let moveActiveWindowToRightSide = Self("moveActiveWindowToRightSide")
}

@main
struct WinResApp: App {
    private static let NUMBER_OF_APPLICATION_SWITCHERS = 30
    private static let NUMBER_OF_KEYBOARD_SHORTCUT_MAPPERS = 30
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private var applicationSwitcherModels: [ApplicationSwitcherModel] = []
    private var mapKeyboardShortcutsModels: [MapKeyboardShortcutsModel] = []
    private let ignoreModifierKeysModel = IgnoreModifierKeysModel()
    
    var body: some Scene {
        Settings {
            SettingsScreen(
                applicationSwitcherModels: self.applicationSwitcherModels,
                mapKeyboardShortcutsModels: self.mapKeyboardShortcutsModels,
                ignoreModifierKeysModel: self.ignoreModifierKeysModel
            ).frame(width: 400, height: 750)
        }
    }
    
    init() {
        self.applicationSwitcherModels = self.createApplicationSwitcherModels()
        self.mapKeyboardShortcutsModels = self.createMapKeyboardShortcutsModels()
        self.addApplicationSwitcherShortcuts()
        self.addShortcutMapperShortcuts();
        ModifierKeysService.ignoreModifierKeysIfEnabled(model: self.ignoreModifierKeysModel)
    }
    
    private func addApplicationSwitcherShortcuts() -> Void {
        for model in self.applicationSwitcherModels {
            KeyboardShortcuts.onKeyDown(for: model.shortcutName) {
                Task {
                    do {
                        try await ApplicationService.switchToApplication(
                            applicationBundleId: model.appBundleId,
                            opensNewWindow: model.opensNewWindow,
                        )
                    } catch ApplicationServiceError.appNotFound(let appBundleId) {
                        let message = "Cannot find app with bundle ID \(appBundleId)"
                        Utils.showErrorAlert(message)
                        print(message)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    private func addShortcutMapperShortcuts() -> Void {
        for model in self.mapKeyboardShortcutsModels {
            KeyboardShortcuts.onKeyDown(for: model.shortcutName) {
                do {
                    try KeyboardShortcutsMappingService.pressKey(model: model)
                } catch {
                    let message = "Cannot simulate a shortcut, \(error)"
                    Utils.showErrorAlert(message)
                    print(message)
                }
            }
        }
    }
    
    private func createApplicationSwitcherModels() -> [ApplicationSwitcherModel] {
        var applicationSwitcherModels: [ApplicationSwitcherModel] = []
        for i in 1...Self.NUMBER_OF_APPLICATION_SWITCHERS {
            let applicationSwitcherModel = ApplicationSwitcherModel(id: "WinRes\(i)")
            applicationSwitcherModels.append(applicationSwitcherModel)
        }
        return applicationSwitcherModels
    }
    
    private func createMapKeyboardShortcutsModels() -> [MapKeyboardShortcutsModel] {
        var models: [MapKeyboardShortcutsModel] = []
        for i in 1...Self.NUMBER_OF_KEYBOARD_SHORTCUT_MAPPERS {
            let model = MapKeyboardShortcutsModel(id: "WinRes_MapKeyboardShortcutsModel_\(i)_")
            models.append(model)
        }
        return models
    }
}
