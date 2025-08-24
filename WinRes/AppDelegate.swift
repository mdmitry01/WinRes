import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = AccessibilityPermissionsService.requestAccess()
        
        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = self.statusItem!.button {
            button.image = NSImage(systemSymbolName: "keyboard.badge.ellipsis", accessibilityDescription: "WinRes menu bar icon")
        } else {
            let message = "Cannot set image for the menu bar status item"
            Utils.showErrorAlert(message)
            print(message)
        }
        
        let menu = NSMenu()
        
        let settingsMenuItem = NSMenuItem(title: "Settings", action: #selector(openAppSettings), keyEquivalent: "1")
        menu.addItem(settingsMenuItem)
        
        let quitMenuItem = NSMenuItem(title: "Quit", action: #selector(terminateApp), keyEquivalent: "q")
        menu.addItem(quitMenuItem)
        
        self.statusItem!.menu = menu
    }
    
    @objc private func openAppSettings() {
        do {
            try ApplicationService.openAppSettings()
        } catch {
            let message = "Cannot open the app settings, \(error)"
            Utils.showErrorAlert(message)
            print(message)
        }
    }
    
    @objc private func terminateApp() {
        NSApplication.shared.terminate(nil)
    }
}
