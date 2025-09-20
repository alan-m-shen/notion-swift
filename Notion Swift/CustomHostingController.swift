import SwiftUI
import WebKit

// 创建一个 NSWindow 的子类，以便我们可以覆盖一些行为
class CustomWindow: NSWindow {
    // 覆盖这个属性，以确保我们的自定义无边框窗口可以成为主窗口
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

// 创建一个 NSHostingController 的子类来管理我们的窗口
class CustomHostingController<Content: View>: NSHostingController<Content> {

    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let window = self.view.window else { return }
        
        // --- 1. 应用最核心的窗口样式 ---
        window.styleMask.remove(.titled) // 移除原生标题栏，这是实现完全自定义窗口的第一步
        window.styleMask.insert(.fullSizeContentView)
        
        window.isMovableByWindowBackground = true // 允许通过拖拽背景移动窗口
        window.titlebarAppearsTransparent = true
        
        // --- 2. 找到并重新定位红绿灯按钮 ---
        guard let container = window.standardWindowButton(.closeButton)?.superview else { return }
        
        let buttonSize: CGFloat = 12
        let spacing: CGFloat = 8

        // 清除现有的约束，以便我们完全控制
        container.translatesAutoresizingMaskIntoConstraints = true
        
        // 精确设置红绿灯的位置和大小，这才是真正的 hiddenInset
        container.frame = NSRect(x: 19, y: window.frame.height - buttonSize - 18, width: 60, height: buttonSize)
        
        // 当窗口大小改变时，保持红绿灯在左上角
        container.autoresizingMask = [.maxXMargin, .minYMargin]
        
        // 将红绿灯的容器视图提到最前面，确保它在 WebView 之上且可点击
        window.contentView?.superview?.addSubview(container)
    }
}
