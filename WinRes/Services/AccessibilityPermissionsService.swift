import SwiftUI

// based on https://github.com/MrKai77/Loop/blob/7e9d0db152ffd910af42b7b39b5619c66973eb61/Loop/Managers/AccessibilityManager.swift#L11
class AccessibilityPermissionsService {
    static func getStatus() -> Bool {
        // Get current state for accessibility access
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: false]
        let status = AXIsProcessTrustedWithOptions(options)
        
        return status
    }
    
    static func requestAccess() -> Bool {
        if AccessibilityPermissionsService.getStatus() {
            return true
        }
        resetAccessibility() // In case WinRes is actually in the list, but the signature is different
        Utils.showErrorAlert("\(Bundle.main.appName) needs accessibility permissions to function properly.", title: "\(Bundle.main.appName) Needs Accessibility Permissions")
        
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as NSString: true]
        let status = AXIsProcessTrustedWithOptions(options)
        
        return status
    }
    
    private static func resetAccessibility() {
        _ = try? Process.run(URL(filePath: "/usr/bin/tccutil"), arguments: ["reset", "Accessibility", Bundle.main.bundleID])
    }
    
    public static func onAccessibilityPermissionGranted(callback: @escaping () -> Void) -> Void {
        if self.getStatus() {
            callback()
            return
        }
        
        var observer: NSObjectProtocol? = nil
        // Register to observe the System Preferences "com.apple.accessibility.api" distributed notification,
        // to learn when the user toggles access for any application in the Privacy pane's Accessibility list.
        observer = DistributedNotificationCenter.default.addObserver(
            forName: NSNotification.Name("com.apple.accessibility.api"),
            object: nil,
            queue: nil
        ) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if self.getStatus() == true {
                    if let observer = observer {
                        DistributedNotificationCenter.default.removeObserver(observer)
                    }
                    callback()
                }
            }
        }
    }
}
