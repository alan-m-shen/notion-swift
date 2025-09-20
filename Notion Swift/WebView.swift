import SwiftUI
import WebKit
import Combine

struct WebView: NSViewRepresentable {
    
    @EnvironmentObject var webViewManager: WebViewManager
    @Binding var urlToLoad: String
    
    let allowedInternalHosts = ["notion.so"]
    let excludedInternalHosts = ["mail.notion.so", "calendar.notion.so"]

    func makeNSView(context: Context) -> WKWebView {
        
        let userContentController = WKUserContentController()

        // Inject CSS
        if let cssPath = Bundle.main.path(forResource: "macos", ofType: "css"),
           let cssString = try? String(contentsOfFile: cssPath, encoding: .utf8) {
            let cssScript = WKUserScript(source: "var style = document.createElement('style'); style.innerHTML = `\(cssString)`; document.head.appendChild(style);", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(cssScript)
        }
        
        // Inject JS
        if let jsPath = Bundle.main.path(forResource: "inject", ofType: "js"),
           let jsString = try? String(contentsOfFile: jsPath, encoding: .utf8) {
            let jsScript = WKUserScript(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(jsScript)
        }

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        
        context.coordinator.setWebViewManager(webViewManager)
        
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        guard let url = URL(string: urlToLoad) else { return }
        let request = URLRequest(url: url)
        
        if nsView.url != url {
            nsView.load(request)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView
        private var webViewManager: WebViewManager?

        init(_ parent: WebView) {
            self.parent = parent
        }

        func setWebViewManager(_ manager: WebViewManager) {
            self.webViewManager = manager
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url, let host = url.host else {
                decisionHandler(.cancel)
                return
            }

            if navigationAction.navigationType == .linkActivated {
                if parent.excludedInternalHosts.contains(host) {
                    NSWorkspace.shared.open(url)
                    decisionHandler(.cancel)
                    return
                }

                if parent.allowedInternalHosts.contains(where: { host.hasSuffix($0) }) {
                    decisionHandler(.allow)
                    return
                }
                
                NSWorkspace.shared.open(url)
                decisionHandler(.cancel)
            } else {
                 decisionHandler(.allow)
            }
        }
        
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            guard let url = navigationAction.request.url, let host = url.host else {
                return nil
            }

            if parent.allowedInternalHosts.contains(where: { host.hasSuffix($0) }) {
                webViewManager?.newWindowURL.send(url)
            } else {
                NSWorkspace.shared.open(url)
            }
            
            return nil
        }
    }
}
