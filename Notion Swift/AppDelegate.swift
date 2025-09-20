import SwiftUI

// This custom window subclass fixes the "canBecomeKeyWindow" warning.
class CustomKeyWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

// This is the App Delegate, responsible for managing our custom window.
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 1. Create the SwiftUI view.
        let contentView = ContentView(urlToLoad: "https://www.notion.so")
        
        // 2. Create a borderless window using our custom subclass.
        window = CustomKeyWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1280, height: 800),
            styleMask: [.borderless, .resizable, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        // --- Core Window Configuration ---
        window.center()
        window.isReleasedWhenClosed = false
        window.title = "Notion Swift"
        window.isMovableByWindowBackground = true
        window.hasShadow = true
        window.backgroundColor = .clear
        
        // 3. Host the SwiftUI view inside the window.
        window.contentView = NSHostingView(rootView: contentView)
        
        // 4. Manually add and position the traffic light buttons.
        setupTrafficLights()
        
        window.makeKeyAndOrderFront(nil)
        window.delegate = self
    }

    private func setupTrafficLights() {
        guard let contentView = window.contentView else { return }
        
        let closeButton = NSWindow.standardWindowButton(.closeButton, for: window.styleMask)!
        let miniaturizeButton = NSWindow.standardWindowButton(.miniaturizeButton, for: window.styleMask)!
        let zoomButton = NSWindow.standardWindowButton(.zoomButton, for: window.styleMask)!
        
        let buttonSize = closeButton.frame.width
        let verticalPadding: CGFloat = 18
        var horizontalPadding: CGFloat = 19
        
        let yPos = window.frame.height - buttonSize - verticalPadding
        
        closeButton.frame.origin = NSPoint(x: horizontalPadding, y: yPos)
        
        horizontalPadding += buttonSize + 8
        miniaturizeButton.frame.origin = NSPoint(x: horizontalPadding, y: yPos)
        
        horizontalPadding += buttonSize + 8
        zoomButton.frame.origin = NSPoint(x: horizontalPadding, y: yPos)
        
        // Use autoresizing masks to keep the buttons pinned to the top-left on resize.
        closeButton.autoresizingMask = [.maxXMargin, .minYMargin]
        miniaturizeButton.autoresizingMask = [.maxXMargin, .minYMargin]
        zoomButton.autoresizingMask = [.maxXMargin, .minYMargin]
        
        contentView.superview?.addSubview(closeButton)
        contentView.superview?.addSubview(miniaturizeButton)
        contentView.superview?.addSubview(zoomButton)
    }
}
