import Foundation

class LocalizationService {
    private static var localizationDictionary: NSDictionary?
    
    private static func getLocalizationDictionary() -> NSDictionary {
        if let localizationDictionary = self.localizationDictionary {
            return localizationDictionary
        }

        let appKitBundle = Bundle(identifier: "com.apple.AppKit")
        if let fileURL = appKitBundle?.url(forResource: "MenuCommands", withExtension: "loctable") {
            do {
                let localizationDictionary = try NSDictionary(contentsOf: fileURL, error: ())
                self.localizationDictionary = localizationDictionary
                return localizationDictionary
            } catch {
                print("Cannot load localization file, \(error)")
            }
        } else {
            print("Cannot get localization file URL")
        }

        self.localizationDictionary = [:]
        return [:]
    }
    
    static func getCurrentLanguageCode() -> String? {
        if NSLocale.preferredLanguages.isEmpty {
            return nil
        }
        // get the first 2 characters from a string like en-UA
        return String(Locale.preferredLanguages[0].prefix(2))
    }

    static func localizedString(forKey: String) -> String {
        let languageCode = self.getCurrentLanguageCode() ?? "en"
        let localizations = self.getLocalizationDictionary()[languageCode]
        guard let localizations = localizations as? NSDictionary else {
            return forKey
        }
        let localizedString = localizations[forKey]
        guard let localizedString = localizedString as? String else {
            return forKey
        }
        return localizedString
    }
}
