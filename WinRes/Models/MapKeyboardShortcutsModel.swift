import Foundation
import KeyboardShortcuts

class MapKeyboardShortcutsModel: ObservableObject {
    let id: String
    let shortcutName: KeyboardShortcuts.Name
    
    private func getKey(for keySuffix: String) -> String {
        return self.id + keySuffix;
    }
    
    var keyCharacter = "" {
        willSet {
            UserDefaults.standard.set(newValue, forKey: self.getKey(for: "keyCharacter"))
            objectWillChange.send()
        }
    }
    
    var includesControlModifier = false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: self.getKey(for: "includesControlModifier"))
            objectWillChange.send()
        }
    }
    
    var includesOptionModifier = false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: self.getKey(for: "includesOptionModifier"))
            objectWillChange.send()
        }
    }
    
    var includesCommandModifier = false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: self.getKey(for: "includesCommandModifier"))
            objectWillChange.send()
        }
    }
    
    var includesShiftModifier = false {
        willSet {
            UserDefaults.standard.set(newValue, forKey: self.getKey(for: "includesShiftModifier"))
            objectWillChange.send()
        }
    }

    init(id: String) {
        self.id = id
        self.shortcutName = KeyboardShortcuts.Name(id + "mapKeyboardShortcuts")
        self.keyCharacter = UserDefaults.standard.string(forKey: self.getKey(for: "keyCharacter")) ?? ""
        self.includesControlModifier = UserDefaults.standard.bool(forKey: self.getKey(for: "includesControlModifier"))
        self.includesOptionModifier = UserDefaults.standard.bool(forKey: self.getKey(for: "includesOptionModifier"))
        self.includesCommandModifier = UserDefaults.standard.bool(forKey: self.getKey(for: "includesCommandModifier"))
        self.includesShiftModifier = UserDefaults.standard.bool(forKey: self.getKey(for: "includesShiftModifier"))
    }
}
