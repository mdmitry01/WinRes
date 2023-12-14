import AppKit

enum AccessibilityError: Error {
    case cannotCopyAttributeValue(cause: AXError? = nil)
    case cannotPerformAction(cause: AXError? = nil)
    case invalidAttributeValue
}

class AccessibilityService {
    static func copyAttributeValue(uiElement: AXUIElement, attribute: String) throws -> AnyObject? {
        var value: AnyObject?
        let error = AXUIElementCopyAttributeValue(uiElement, attribute as CFString, &value)
        if error != AXError.success {
            throw AccessibilityError.cannotCopyAttributeValue(cause: error)
        }
        return value
    }
    
    static func getChildren(uiElement: AXUIElement) throws -> [AXUIElement] {
        let children = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXChildrenAttribute)
        if let children = children as? [AXUIElement] {
            return children
        }
        return []
    }

    static func getIdentifier(uiElement: AXUIElement) throws -> String {
        let id = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXIdentifierAttribute)
        if let id = id as? String {
            return id
        }
        throw AccessibilityError.invalidAttributeValue
    }
    
    static func getTitle(uiElement: AXUIElement) throws -> String {
        let title = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXTitleAttribute)
        if let title = title as? String {
            return title
        }
        throw AccessibilityError.invalidAttributeValue
    }

    static func getURL(uiElement: AXUIElement) throws -> URL {
        let url = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXURLAttribute)
        if let url = url as? URL {
            return url
        }
        throw AccessibilityError.invalidAttributeValue
    }
    
    static func getWindows(appElement: AXUIElement) throws -> [AXUIElement] {
        let windows = try AccessibilityService.copyAttributeValue(
            uiElement: appElement,
            attribute: kAXWindowsAttribute
        )
        if let windows = windows as? [AXUIElement] {
            return windows
        }
        throw AccessibilityError.invalidAttributeValue
    }
    
    static func performAction(uiElement: AXUIElement, action: String) throws -> Void {
        let error = AXUIElementPerformAction(uiElement, action as CFString)
        if error != AXError.success {
            throw AccessibilityError.cannotPerformAction(cause: error)
        }
    }
}
