import AppKit

enum AccessibilityError: Error {
    case cannotCopyAttributeValue(cause: AXError? = nil)
    case cannotPerformAction(cause: AXError? = nil)
    case invalidAttributeValue
}

class AccessibilityService {
    static func copyAttributeValue(uiElement: AXUIElement, attribute: CFString) throws -> AnyObject? {
        var value: AnyObject?
        let error = AXUIElementCopyAttributeValue(uiElement, attribute, &value)
        if error != AXError.success {
            throw AccessibilityError.cannotCopyAttributeValue(cause: error)
        }
        return value
    }
    
    static func getChildren(uiElement: AXUIElement) throws -> NSArray {
        let children = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXChildrenAttribute as CFString)
        if let children = children as? NSArray {
            return children
        }
        return []
    }

    static func getIdentifier(uiElement: AXUIElement) throws -> String {
        let id = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXIdentifierAttribute as CFString)
        if let id = id as? String {
            return id
        }
        throw AccessibilityError.invalidAttributeValue
    }
    
    static func getTitle(uiElement: AXUIElement) throws -> String {
        let title = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXTitleAttribute as CFString)
        if let title = title as? String {
            return title
        }
        throw AccessibilityError.invalidAttributeValue
    }

    static func getURL(uiElement: AXUIElement) throws -> URL {
        let url = try self.copyAttributeValue(uiElement: uiElement, attribute: kAXURLAttribute as CFString)
        if let url = url as? URL {
            return url
        }
        throw AccessibilityError.invalidAttributeValue
    }
    
    static func performAction(uiElement: AXUIElement, action: CFString) throws -> Void {
        let error = AXUIElementPerformAction(uiElement, action)
        if error != AXError.success {
            throw AccessibilityError.cannotPerformAction(cause: error)
        }
    }
}
