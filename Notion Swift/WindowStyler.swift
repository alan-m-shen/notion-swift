import SwiftUI

/// 一个辅助视图，它将用最简单、最正确的方式来配置窗口
struct WindowStyler: NSViewRepresentable {
    
    // 创建一个 Coordinator 来作为 Toolbar 的代理
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            
            // --- 1. 创建一个 Toolbar 以启用现代化的窗口样式 ---
            let toolbar = NSToolbar(identifier: "WorkaroundToolbar")
            toolbar.delegate = context.coordinator
            
            // --- 2. 关键：将 Toolbar 设为不可见 ---
            // 我们只是利用它来触发正确的窗口 chrome，但我们不希望看到它
            toolbar.isVisible = false
            
            window.toolbar = toolbar
            window.toolbarStyle = .unified // .unified 或 .unifiedCompact 都可以
            
            // --- 3. 应用其他必要的窗口属性 ---
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)
            window.isMovableByWindowBackground = true
            
            // --- 4. 移除所有手动移动 Traffic Light 的代码 ---
            // 系统在满足以上条件时，会自动处理 Traffic Light 的 inset 布局。
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
    
    // --- Toolbar 的代理实现 ---
    // 返回空即可，因为我们不需要任何真实的 item
    class Coordinator: NSObject, NSToolbarDelegate {
        func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { [] }
        func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { [] }
        func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? { nil }
    }
}
