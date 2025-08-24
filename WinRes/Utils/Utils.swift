import AppKit

enum KeyPressError: Error {
    case cannotCreateKeyboardEvents
}

class Utils {
    static func showErrorAlert(_ text: String, title: String = "Error") {
        // https://www.hackingwithswift.com/read/9/4/back-to-the-main-thread-dispatchqueuemain
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = text
            alert.alertStyle = NSAlert.Style.warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
        }
    }
    
    // based on https://github.com/sindresorhus/touch-bar-simulator/blob/835ffdf7022bd25fb94b64f179227d702071da77/Touch%20Bar%20Simulator/Utilities.swift#L229-L236
    static func pressKey(keyCode: CGKeyCode, flags: CGEventFlags = [], processId: pid_t? = nil) throws {
        let eventSource = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: false)
        guard let keyUp = keyUp, let keyDown = keyDown else {
            throw KeyPressError.cannotCreateKeyboardEvents
        }
        keyDown.flags = flags
        if let processId = processId {
            keyDown.postToPid(processId)
            keyUp.postToPid(processId)
            return
        }
        keyDown.post(tap: .cghidEventTap)
        keyUp.post(tap: .cghidEventTap)
    }
}
