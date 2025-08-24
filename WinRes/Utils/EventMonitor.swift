import Cocoa

protocol EventMonitor {
    var isEnabled: Bool { get }
    func start()
    func stop()
}

// based on https://github.com/MrKai77/Loop/blob/7e9d0db152ffd910af42b7b39b5619c66973eb61/Loop/Utilities/EventMonitor.swift#L91
class CGEventMonitor: EventMonitor, Identifiable, Equatable {
    let id = UUID()

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var eventCallback: (CGEvent) -> Unmanaged<CGEvent>?
    private(set) var isEnabled: Bool = false

    init(
        eventMask: NSEvent.EventTypeMask,
        callback: @escaping (CGEvent) -> Unmanaged<CGEvent>?
    ) {
        self.eventCallback = callback

        self.eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: eventMask.rawValue,
            callback: { _, _, event, refcon in
                let observer = Unmanaged<CGEventMonitor>.fromOpaque(refcon!).takeUnretainedValue()

                // If disabled, simply pass the event through without processing.
                if event.type == .tapDisabledByTimeout || event.type == .tapDisabledByUserInput {
                    return Unmanaged.passUnretained(event)
                }

                return observer.handleEvent(event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )

        if let eventTap {
            self.runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            if let runLoopSource {
                CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            }
        } else {
            print("ERROR: Failed to create event tap (event mask: \(eventMask)")
        }
    }

    deinit {
        if isEnabled {
            stop()
        }

        // Clean up run loop source and event tap
        if let runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
            self.runLoopSource = nil
        }

        if let eventTap {
            CFMachPortInvalidate(eventTap)
            self.eventTap = nil
        }
    }

    private func handleEvent(event: CGEvent) -> Unmanaged<CGEvent>? {
        eventCallback(event)
    }

    func start() {
        guard let eventTap else { return }
        CGEvent.tapEnable(tap: eventTap, enable: true)
        isEnabled = true
    }

    func stop() {
        guard isEnabled else { return }

        guard let eventTap else { return }
        CGEvent.tapEnable(tap: eventTap, enable: false)
        isEnabled = false
    }

    static func == (lhs: CGEventMonitor, rhs: CGEventMonitor) -> Bool {
        lhs.id == rhs.id
    }
}
