import Carbon.HIToolbox

class WindowService {
    static func zoom(processId: pid_t) throws {
        try MenuBarService.selectWindowMenuItem(windowMenuItem: .zoom, processId: processId)
    }
    
    static func minimize(processId: pid_t) throws {
        do {
            // try selecting MinimiZe menu item
            try MenuBarService.selectWindowMenuItem(windowMenuItem: .minimize, processId: processId)
        } catch {
            // try selecting MinimiSe menu item
            try MenuBarService.selectWindowMenuItem(windowMenuItem: .minimise, processId: processId)
        }
    }
    
    static func zoomLeft(processId: pid_t) throws {
        try MenuBarService.selectWindowMenuItem(windowMenuItem: .zoomLeft, processId: processId)
    }
    
    static func zoomRight(processId: pid_t) throws {
        try MenuBarService.selectWindowMenuItem(windowMenuItem: .zoomRight, processId: processId)
    }
    
    static func openNewWindow(processId: pid_t) throws {
        try Utils.pressKey(keyCode: UInt16(kVK_ANSI_N), flags: [.maskCommand], processId: processId)
    }
    
    static func switchToNextWindow(processId: pid_t) throws {
        try Utils.pressKey(keyCode: UInt16(kVK_ANSI_Grave), flags: [.maskCommand], processId: processId)
    }

    static func hasMainWindow(processId: pid_t) -> Bool {
        let appElement = AXUIElementCreateApplication(processId)
        do {
            let window = try AccessibilityService.copyAttributeValue(
                uiElement: appElement,
                attribute: kAXMainWindowAttribute as CFString
            )
            return window != nil
        } catch {
            print("Failed to get the main window of the app, \(error)")
            return false
        }
    }
}
