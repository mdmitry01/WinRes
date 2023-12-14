import AppKit

enum DockServiceError: Error {
    case theDockAppIsNotRunning
    case dockItemsAreMissing
    case dockItemNotFound
}

class DockService {
    private static func getDockAppPID() throws -> pid_t {
        let runningApplications = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock")
        if runningApplications.isEmpty {
            throw DockServiceError.theDockAppIsNotRunning
        }
        return runningApplications[0].processIdentifier
    }
    
    private static func findDockItemWithBundleURL(dockItems: [AXUIElement], bundleURL: URL) throws -> AXUIElement {
        for dockItem in dockItems {
            do {
                let url = try AccessibilityService.getURL(uiElement: dockItem)
                if url == bundleURL {
                    return dockItem
                }
            } catch {
                // error is ignored
            }
        }
        throw DockServiceError.dockItemNotFound
    }
    
    static func openApplication(bundleURL: URL) throws -> Void {
        let dockAppPID = try self.getDockAppPID()
        let appElement = AXUIElementCreateApplication(dockAppPID)
        let dockItemsList: Any? = try AccessibilityService.getChildren(uiElement: appElement)[0]
        guard let dockItemsList = dockItemsList else {
            throw DockServiceError.dockItemsAreMissing
        }
        let dockItems = try AccessibilityService.getChildren(uiElement: dockItemsList as! AXUIElement)
        let dockItem = try self.findDockItemWithBundleURL(dockItems: dockItems, bundleURL: bundleURL)
        try AccessibilityService.performAction(
            uiElement: dockItem,
            action: kAXPressAction
        )
    }
}
