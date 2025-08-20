import Foundation
import KeyboardShortcuts

class IgnoreRightModifierKeysModel: ObservableObject {
    private static let USER_DEFAULTS_KEY = "ignoresRightModifierKeys"

    var ignoresRightModifierKeys = false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Self.USER_DEFAULTS_KEY)
            objectWillChange.send()
        }
    }

    init() {
        self.ignoresRightModifierKeys = UserDefaults.standard.bool(forKey: Self.USER_DEFAULTS_KEY)
    }
}
