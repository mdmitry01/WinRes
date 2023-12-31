import Carbon.HIToolbox

class WindowMenuItem: MenuItem {
    static let zoom = WindowMenuItem(id: "performZoom:", title: "Zoom")
    static let minimize = WindowMenuItem(id: "performMiniaturize:", title: "Minimize")
    static let minimise = WindowMenuItem(id: "performMiniaturize:", title: "Minimise")
    static let zoomLeft = WindowMenuItem(id: "_zoomLeft:", title: "Move Window to Left Side of Screen")
    static let zoomRight = WindowMenuItem(id: "_zoomRight:", title: "Move Window to Right Side of Screen")
}

class MenuBarItem: MenuItem {
    static let window = MenuBarItem(title: "Window")
}

class MenuItem {
    let id: String?
    let englishTitle: String
    let localizedTitle: String
    
    init(id: String? = nil, title: String) {
        self.id = id
        self.englishTitle = title
        self.localizedTitle = LocalizationService.localizedString(forKey: title)
    }
}

enum MenuBarServiceError: Error {
    case cannotSelectWindowMenuItem
}

class MenuBarService {
    private static func getMenuBar(processIdentifier: pid_t) throws -> AXUIElement {
        let appElement = AXUIElementCreateApplication(processIdentifier)
        return try AccessibilityService.copyAttributeValue(
            uiElement: appElement,
            attribute: kAXMenuBarAttribute
        ) as! AXUIElement
    }
    
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
    
    private static func getMenuItems(menuBarItem: AXUIElement) throws -> [AXUIElement] {
        let menus = try AccessibilityService.getChildren(uiElement: menuBarItem)
        guard menus.count > 0 else {
            return []
        }
        return try AccessibilityService.getChildren(uiElement: menus[0])
    }
    
    // based on https://github.com/steve228uk/QBlocker/blob/ebaa8a9c2ed5242fbcd63514193fe66851468a1c/QBlocker/KeyListener.swift#L214
    static func selectWindowMenuItem(windowMenuItem: WindowMenuItem, processId: pid_t) throws -> Void {
        let menuBar = try self.getMenuBar(processIdentifier: processId)
        let menuBarItems = try AccessibilityService.getChildren(uiElement: menuBar)

        var windowMenuItems: [AXUIElement] = []
        for menuBarItem in menuBarItems {
            let isTargetMenuItem = self.isMenuItem(uiElement: menuBarItem, menuItem: MenuBarItem.window)
            if isTargetMenuItem {
                windowMenuItems = try self.getMenuItems(menuBarItem: menuBarItem)
                break
            }
        }

        for menuItem in windowMenuItems {
            let isTargetMenuItem = self.isMenuItem(uiElement: menuItem, menuItem: windowMenuItem)
            if isTargetMenuItem {
                try AccessibilityService.performAction(
                    uiElement: menuItem,
                    action: kAXPressAction
                )
                return
            }
        }
        
        throw MenuBarServiceError.cannotSelectWindowMenuItem
    }
}
