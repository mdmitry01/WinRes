import AppKit
import Carbon.HIToolbox

enum ApplicationServiceError: Error {
    case appNotFound(appBundleId: String)
    case cannotGetProcessIdOfFrontmostApp
    case cannotOpenAppSettings(_: String)
}

class ApplicationService {
    private static func openApplication(applicationBundleId: String) async throws {
        guard let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: applicationBundleId) else {
            throw ApplicationServiceError.appNotFound(appBundleId: applicationBundleId)
        }
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.activates = true
        try await NSWorkspace.shared.openApplication(at: url, configuration: configuration)
    }

    static func openAppSettings() throws -> Void {
        if #available(macOS 14, *) {
            guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
                throw ApplicationServiceError.cannotOpenAppSettings("Cannot get the bundle ID of the WinRes application")
            }
            let runningApplications = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
            if runningApplications.isEmpty {
                throw ApplicationServiceError.cannotOpenAppSettings("Cannot get the process ID of the WinRes application")
            }
            try Utils.pressKey(
                keyCode: UInt16(kVK_ANSI_Comma),
                flags: [.maskCommand],
                processId: runningApplications[0].processIdentifier
            )
        } else if #available(macOS 13, *) {
            NSApplication.shared.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        } else {
            NSApplication.shared.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
        }
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    static func getProcessIdOfFrontmostApp() throws -> pid_t {
        if let processIdentifier = NSWorkspace.shared.frontmostApplication?.processIdentifier {
            return processIdentifier
        } else {
            throw ApplicationServiceError.cannotGetProcessIdOfFrontmostApp
        }
    }
    
    static func switchToApplication(applicationBundleId: String, opensNewWindow: Bool = false) async throws {
        let runningApplications = NSRunningApplication.runningApplications(withBundleIdentifier: applicationBundleId)
        if runningApplications.isEmpty {
            try await self.openApplication(applicationBundleId: applicationBundleId)
            return
        }
        let runningApplication = runningApplications[0]
        let processId = runningApplication.processIdentifier

        if opensNewWindow {
            try WindowService.openNewWindow(processId: processId)
            return
        }
        
        if runningApplication.isHidden {
            runningApplication.unhide()
            // wait 20ms for the windows to appear
            try await Task.sleep(nanoseconds: UInt64(20 * Double(NSEC_PER_MSEC)))
        }
        
        if WindowService.hasWindowsOnScreenOnly(processId: processId) == false {
            try WindowService.openNewWindow(processId: processId)
            return
        }

        if
            let frontmostApplication = NSWorkspace.shared.frontmostApplication,
            frontmostApplication.bundleIdentifier == applicationBundleId
        {
            try WindowService.switchToNextWindow(processId: processId)
            return
        }

        runningApplication.activate(options: [.activateIgnoringOtherApps])
    }
}
