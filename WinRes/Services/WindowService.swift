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
    
    private static func getWindowsInCurrentWorkspace(processId: pid_t) throws -> [AXUIElement] {
        let appElement = AXUIElementCreateApplication(processId)
        let windows = try AccessibilityService.getWindows(appElement: appElement)
        return try windows.filter { window in
            return try !AccessibilityService.isMinimized(window: window)
        }
    }
    
    /// - returns: true if switching to the next window was successful, otherwise false
    static func switchToNextWindowInCurrentWorkspace(processId: pid_t) -> Bool {
        do {
            let windows = try self.getWindowsInCurrentWorkspace(processId: processId)
            if windows.count == 0 {
                return false
            }
            try AccessibilityService.performAction(
                uiElement: windows.last!,
                action: kAXRaiseAction
            )
            return true
        } catch {
            print(error)
            return false
        }
    }

    static func hasWindowsInCurrentWorkspace(processId: pid_t) throws -> Bool {
        let windows = try self.getWindowsInCurrentWorkspace(processId: processId)
        return !windows.isEmpty
    }
}
