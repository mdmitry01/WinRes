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
    public static func ignoreModifierKeysIfEnabled(model: IgnoreModifierKeysModel) -> Void {
        // inspired by https://github.com/huytd/OctoCmd/blob/0339242971c892986c466d987c85e9537050a250/OctoCmd/Apps/AppDelegate.swift#L56-L72
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { event in
            if model.ignoredModifierKeys.isEmpty {
                return
            }
            if event.modifierFlags.intersection([.shift, .control, .option, .command]).isEmpty {
                // key up
                DispatchQueue.main.async {
                    KeyboardShortcuts.isEnabled = true
                }
                return;
            }
            // key down
            guard let modifierKey = KeyboardModifierKey(rawValue: event.keyCode) else {
                return
            }
            let isIgnored = model.ignoredModifierKeys[modifierKey] ?? false
            if isIgnored {
                DispatchQueue.main.async {
                    KeyboardShortcuts.isEnabled = false
                }
            }
        })
    }
}
