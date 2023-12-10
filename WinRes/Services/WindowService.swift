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

    static func hasWindowsInCurrentWorkspace(processId: pid_t) -> Bool {
        // https://developer.apple.com/documentation/coregraphics/cgwindowlistoption/1454105-optiononscreenonly
        let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
        guard let windows = windows as? Array<Dictionary<String, Any>> else {
            return false
        }
        for window in windows {
            guard let windowProcessId = window[kCGWindowOwnerPID as String] as? pid_t else {
                continue
            }
            if windowProcessId == processId {
                return true
            }
        }
        return false
    }
}
