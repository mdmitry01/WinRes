import Carbon.HIToolbox

private class WindowMenuItem: MenuItem {
    static let zoom = WindowMenuItem(id: "performZoom:", title: "Zoom")
    static let minimize = WindowMenuItem(id: "performMiniaturize:", title: "Minimize")
    static let minimise = WindowMenuItem(id: "performMiniaturize:", title: "Minimise")
    static let zoomLeft = WindowMenuItem(id: "_zoomLeft:", title: "Move Window to Left Side of Screen")
    static let zoomRight = WindowMenuItem(id: "_zoomRight:", title: "Move Window to Right Side of Screen")
}

private class MenuBarItem: MenuItem {
    static let window = MenuBarItem(title: "Window")
}

private class MenuItem {
    let id: String?
    let englishTitle: String
    let localizedTitle: String
    
    init(id: String? = nil, title: String) {
        self.id = id
        self.englishTitle = title
        self.localizedTitle = LocalizationService.localizedString(forKey: title)
    }
}

enum WindowServiceError: Error {
    case cannotSelectWindowMenuItem
}

class WindowService {
    private static func isMenuItem(uiElement: AXUIElement, menuItem: MenuItem) -> Bool {
        do {
            if let menuItemId = menuItem.id {
                let id = try AccessibilityService.getIdentifier(uiElement: uiElement)
                if id == menuItemId {
                    return true
                }
            }
        } catch {
            print(error)
        }

        do {
            let title = try AccessibilityService.getTitle(uiElement: uiElement)
            if title == menuItem.localizedTitle || title == menuItem.englishTitle {
                return true
            }
        } catch {
            print(error)
        }
        
        return false
    }
    
    private static func getMenuItems(menuBarItem: AXUIElement) throws -> NSArray {
        let menus = try AccessibilityService.getChildren(uiElement: menuBarItem)
        guard menus.count > 0 else {
            return []
        }
        let menu = menus[0] as! AXUIElement
        return try AccessibilityService.getChildren(uiElement: menu)
    }

    // based on https://github.com/steve228uk/QBlocker/blob/ebaa8a9c2ed5242fbcd63514193fe66851468a1c/QBlocker/KeyListener.swift#L214
    private static func selectWindowMenuItem(windowMenuItem: WindowMenuItem, processId: pid_t) throws -> Void {
        let menuBar = try AccessibilityService.getMenuBar(processIdentifier: processId)
        let menuBarItems = try AccessibilityService.getChildren(uiElement: menuBar)

        var windowMenuItems: NSArray = []
        for menuBarItem in menuBarItems {
            let isTargetMenuItem = self.isMenuItem(uiElement: menuBarItem as! AXUIElement, menuItem: MenuBarItem.window)
            if isTargetMenuItem {
                windowMenuItems = try self.getMenuItems(menuBarItem: menuBarItem as! AXUIElement)
                break
            }
        }

        for menuItem in windowMenuItems {
            let isTargetMenuItem = self.isMenuItem(uiElement: menuItem as! AXUIElement, menuItem: windowMenuItem)
            if isTargetMenuItem {
                try AccessibilityService.performAction(
                    uiElement: menuItem as! AXUIElement,
                    action: kAXPressAction as CFString
                )
                return
            }
        }
        
        throw WindowServiceError.cannotSelectWindowMenuItem
    }
    
    static func zoom(processId: pid_t) throws {
        try self.selectWindowMenuItem(windowMenuItem: .zoom, processId: processId)
    }
    
    static func minimize(processId: pid_t) throws {
        do {
            // try selecting MinimiZe menu item
            try self.selectWindowMenuItem(windowMenuItem: .minimize, processId: processId)
        } catch {
            // try selecting MinimiSe menu item
            try self.selectWindowMenuItem(windowMenuItem: .minimise, processId: processId)
        }
    }
    
    static func zoomLeft (processId: pid_t) throws {
        try self.selectWindowMenuItem(windowMenuItem: .zoomLeft, processId: processId)
    }
    
    static func zoomRight (processId: pid_t) throws {
        try self.selectWindowMenuItem(windowMenuItem: .zoomRight, processId: processId)
    }
    
    static func openNewWindow(processId: pid_t) throws {
        try Utils.pressKey(keyCode: UInt16(kVK_ANSI_N), flags: [.maskCommand], processId: processId)
    }
    
    static func switchToNextWindow(processId: pid_t) throws {
        try Utils.pressKey(keyCode: UInt16(kVK_ANSI_Grave), flags: [.maskCommand], processId: processId)
    }

    static func hasWindowsOnScreenOnly(processId: pid_t) -> Bool {
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
