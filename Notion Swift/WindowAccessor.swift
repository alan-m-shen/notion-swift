import SwiftUI

/// 一个辅助视图，用于获取其所在的 NSWindow 并进行配置
struct WindowAccessor: NSViewRepresentable {
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        // 使用 DispatchQueue.main.async 确保视图已经被添加到窗口层级中
        DispatchQueue.main.async {
            guard let window = view.window else { return }
            
            // --- 这就是从 CotEditor 学到的核心代码 ---
            window.titlebarAppearsTransparent = true
            window.styleMask.insert(.fullSizeContentView)
            
            // 可选：允许通过拖拽窗口背景来移动窗口
            window.isMovableByWindowBackground = true
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
