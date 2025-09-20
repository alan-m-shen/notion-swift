import SwiftUI

struct ContentView: View {
    @State var urlToLoad: String

    var body: some View {
        WebView(urlToLoad: $urlToLoad)
            // 添加一个非常细微的背景，以确保窗口有内容可以渲染圆角
            .background(Color(nsColor: .windowBackgroundColor).opacity(0.001))
    }
}
