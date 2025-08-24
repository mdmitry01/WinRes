import SwiftUI
import Carbon.HIToolbox
import KeyboardShortcuts

enum KeyboardModifierKey: UInt16, CaseIterable {
    case leftShift = 56
    case rightShift = 60
    case leftOption = 58
    case rightOption = 61
    case leftControl = 59
    case rightControl = 62
    case leftCommand = 55
    case rightCommand = 54
}

class ModifierKeysService {
    // a static property to hold the EventMonitor reference and keep it alive
    private static var flagsEventMonitor: EventMonitor?
    
    public static func startIgnoringModifierKeysIfEnabled(model: IgnoreModifierKeysModel) {
        AccessibilityPermissionsService.onAccessibilityPermissionGranted() {
            guard self.flagsEventMonitor == nil else {
                return
            }
            // based on https://github.com/MrKai77/Loop/blob/7e9d0db152ffd910af42b7b39b5619c66973eb61/Loop/Managers/KeybindMonitor.swift#L74-L86
            self.flagsEventMonitor = CGEventMonitor(eventMask: .flagsChanged) { cgEvent in
                guard
                    !model.ignoredModifierKeys.isEmpty,
                    cgEvent.type == .flagsChanged,
                    let event = NSEvent(cgEvent: cgEvent)
                else {
                    return Unmanaged.passUnretained(cgEvent)
                }
                if event.modifierFlags.intersection([.shift, .control, .option, .command]).isEmpty {
                    // key up
                    DispatchQueue.main.async {
                        KeyboardShortcuts.isEnabled = true
                    }
                    return Unmanaged.passUnretained(cgEvent)
                }
                // key down
                guard let modifierKey = KeyboardModifierKey(rawValue: event.keyCode) else {
                    return Unmanaged.passUnretained(cgEvent)
                }
                let isIgnored = model.ignoredModifierKeys[modifierKey] ?? false
                if isIgnored {
                    DispatchQueue.main.async {
                        KeyboardShortcuts.isEnabled = false
                    }
                }
                return Unmanaged.passUnretained(cgEvent)
            }
            self.flagsEventMonitor!.start()
        }
    }
}
