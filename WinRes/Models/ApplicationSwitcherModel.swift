import Foundation
import KeyboardShortcuts

class ApplicationSwitcherModel: ObservableObject {
    let id: String
    let shortcutName: KeyboardShortcuts.Name
    private let appBundleIdKey: String
    private let opensNewWindowKey: String
    
    // https://www.hackingwithswift.com/quick-start/swiftui/how-to-send-state-updates-manually-using-objectwillchange
    var appBundleId = "" {
        willSet {
            UserDefaults.standard.set(newValue, forKey: appBundleIdKey)
            objectWillChange.send()
        }
    }
    
    var opensNewWindow = false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: opensNewWindowKey)
            objectWillChange.send()
        }
    }

    init(id: String) {
        self.id = id
        self.appBundleIdKey = id + "appBundleId"
        self.opensNewWindowKey = id + "opensNewWindow"
        self.shortcutName = KeyboardShortcuts.Name(id)
        self.appBundleId = UserDefaults.standard.string(forKey: self.appBundleIdKey) ?? ""
        self.opensNewWindow = UserDefaults.standard.bool(forKey: self.opensNewWindowKey)
    }
}
