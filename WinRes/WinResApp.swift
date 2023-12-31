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
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    private var applicationSwitcherModels: [ApplicationSwitcherModel] = []

    var body: some Scene {
        Settings {
            SettingsScreen(switchWindowsShortcutModels: self.applicationSwitcherModels)
                .frame(width: 400, height: 750)
        }
    }
    
    init() {
        self.applicationSwitcherModels = self.createApplicationSwitcherModels()
        self.addApplicationSwitcherShortcuts()
        self.addWindowShortcuts()
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
