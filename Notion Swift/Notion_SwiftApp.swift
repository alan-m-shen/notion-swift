import SwiftUI

@main
struct Notion_SwiftApp: App {
    // This line tells SwiftUI to use our custom AppDelegate for the app's lifecycle.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        // The Scene is empty because the AppDelegate now creates and manages the window.
        Settings {
            EmptyView()
        }
    }
}
