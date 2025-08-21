import Foundation
import KeyboardShortcuts

class IgnoreModifierKeysModel: ObservableObject {
    private(set) var ignoredModifierKeys: [KeyboardModifierKey: Bool] = [:]
    
    private func getUserDefaultsKey(_ key: KeyboardModifierKey) -> String {
        switch key {
        case .leftShift: return "ignoresLeftShiftKey"
        case .rightShift: return "ignoresRightShiftKey"
        case .leftOption: return "ignoresLeftOptionKey"
        case .rightOption: return "ignoresRightOptionKey"
        case .leftControl: return "ignoresLeftControlKey"
        case .rightControl: return "ignoresRightControlKey"
        case .leftCommand: return "ignoresLeftCommandKey"
        case .rightCommand: return "ignoresRightCommandKey"
        }
    }
    
    private func setIgnored(_ isIgnored: Bool, for key: KeyboardModifierKey) -> Void {
        objectWillChange.send()
        ignoredModifierKeys[key] = isIgnored
        UserDefaults.standard.set(isIgnored, forKey: self.getUserDefaultsKey(key))
    }

    private func isIgnored(_ key: KeyboardModifierKey) -> Bool {
        return ignoredModifierKeys[key] ?? false
    }

    init() {
        for key in KeyboardModifierKey.allCases {
            ignoredModifierKeys[key] = UserDefaults.standard.bool(forKey: self.getUserDefaultsKey(key))
        }
    }
    
    var ignoresLeftShift: Bool {
        get { isIgnored(.leftShift) }
        set { setIgnored(newValue, for: .leftShift) }
    }
    
    var ignoresRightShift: Bool {
        get { isIgnored(.rightShift) }
        set { setIgnored(newValue, for: .rightShift) }
    }
    
    var ignoresLeftOption: Bool {
        get { isIgnored(.leftOption) }
        set { setIgnored(newValue, for: .leftOption) }
    }
    
    var ignoresRightOption: Bool {
        get { isIgnored(.rightOption) }
        set { setIgnored(newValue, for: .rightOption) }
    }
    
    var ignoresLeftControl: Bool {
        get { isIgnored(.leftControl) }
        set { setIgnored(newValue, for: .leftControl) }
    }
    
    var ignoresRightControl: Bool {
        get { isIgnored(.rightControl) }
        set { setIgnored(newValue, for: .rightControl) }
    }
    
    var ignoresLeftCommand: Bool {
        get { isIgnored(.leftCommand) }
        set { setIgnored(newValue, for: .leftCommand) }
    }
    
    var ignoresRightCommand: Bool {
        get { isIgnored(.rightCommand) }
        set { setIgnored(newValue, for: .rightCommand) }
    }
}
