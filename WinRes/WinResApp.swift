import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let zoomActiveWindow = Self("zoomActiveWindow")
    static let minimizeActiveWindow = Self("minimizeActiveWindow")
    static let moveActiveWindowToLeftSide = Self("moveActiveWindowToLeftSide")
    static let moveActiveWindowToRightSide = Self("moveActiveWindowToRightSide")
}

// Keycode map for right modifiers
enum RightModifierKey: UInt16 {
    case rightShift = 60
    case rightControl = 62
    case rightOption = 61
    case rightCommand = 54
}

@main
struct WinResApp: App {
    private static let NUMBER_OF_APPLICATION_SWITCHERS = 30
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private var applicationSwitcherModels: [ApplicationSwitcherModel] = []
    private let ignoreRightModifierKeysModel = IgnoreRightModifierKeysModel()
    
    var body: some Scene {
        Settings {
            SettingsScreen(switchWindowsShortcutModels: self.applicationSwitcherModels, ignoreRightModifierKeysModel: self.ignoreRightModifierKeysModel)
                .frame(width: 400, height: 750)
        }
    }
    
    init() {
        self.applicationSwitcherModels = self.createApplicationSwitcherModels()
        self.addApplicationSwitcherShortcuts()
        self.addWindowShortcuts()
        self.ignoreRightModifierKeysIfNeeded()
    }
    
    private func ignoreRightModifierKeysIfNeeded() {
        // inspired by https://github.com/huytd/OctoCmd/blob/0339242971c892986c466d987c85e9537050a250/OctoCmd/Apps/AppDelegate.swift#L56-L72
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { event in
            if (!self.ignoreRightModifierKeysModel.ignoresRightModifierKeys) {
                return
            }
            if event.modifierFlags.intersection([.shift, .control, .option, .command]).isEmpty {
                // key up
                DispatchQueue.main.async {
                    KeyboardShortcuts.isEnabled = true
                }
                return;
            }
            // key down
            if RightModifierKey(rawValue: event.keyCode) != nil {
                DispatchQueue.main.async {
                    KeyboardShortcuts.isEnabled = false
                }
            }
        })
    }
    
    private func addWindowShortcuts() {
        KeyboardShortcuts.onKeyDown(for: .zoomActiveWindow) {
            do {
                try WindowService.zoom(processId: ApplicationService.getProcessIdOfFrontmostApp())
            } catch {
                print(error)
            }
        }
        
        KeyboardShortcuts.onKeyDown(for: .minimizeActiveWindow) {
            do {
                try WindowService.minimize(processId: ApplicationService.getProcessIdOfFrontmostApp())
            } catch {
                print(error)
            }
        }
        
        KeyboardShortcuts.onKeyDown(for: .moveActiveWindowToLeftSide) {
            do {
                try WindowService.zoomLeft(processId: ApplicationService.getProcessIdOfFrontmostApp())
            } catch {
                print(error)
            }
        }
        
        KeyboardShortcuts.onKeyDown(for: .moveActiveWindowToRightSide) {
            do {
                try WindowService.zoomRight(processId: ApplicationService.getProcessIdOfFrontmostApp())
            } catch {
                print(error)
            }
        }
    }
    
    private func addApplicationSwitcherShortcuts() -> Void {
        for model in self.applicationSwitcherModels {
            KeyboardShortcuts.onKeyDown(for: model.shortcutName) {
                Task {
                    do {
                        try await ApplicationService.switchToApplication(
                            applicationBundleId: model.appBundleId,
                            opensNewWindow: model.opensNewWindow,
                            switchesToWorkspace: model.switchesToWorkspace
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
    
    private func createApplicationSwitcherModels() -> [ApplicationSwitcherModel] {
        var applicationSwitcherModels: [ApplicationSwitcherModel] = []
        for i in 1...Self.NUMBER_OF_APPLICATION_SWITCHERS {
            let applicationSwitcherModel = ApplicationSwitcherModel(id: "WinRes\(i)")
            applicationSwitcherModels.append(applicationSwitcherModel)
        }
        return applicationSwitcherModels
    }
}
