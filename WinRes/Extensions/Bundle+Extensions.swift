import Foundation

// based on https://github.com/MrKai77/Loop/blob/7e9d0db152ffd910af42b7b39b5619c66973eb61/Loop/Extensions/Bundle%2BExtensions.swift
extension Bundle {
    var appName: String {
        getInfo("CFBundleName") ?? "⚠️"
    }

    var displayName: String {
        getInfo("CFBundleDisplayName") ?? "⚠️"
    }

    var bundleID: String {
        getInfo("CFBundleIdentifier") ?? "⚠️"
    }

    var copyright: String {
        getInfo("NSHumanReadableCopyright") ?? "⚠️"
    }

    var appBuild: Int? {
        Int(getInfo("CFBundleVersion") ?? "")
    }

    var appVersion: String? {
        getInfo("CFBundleShortVersionString")
    }

    func getInfo(_ str: String) -> String? {
        infoDictionary?[str] as? String
    }
}
