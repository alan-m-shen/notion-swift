import Foundation
import Combine

class WebViewManager: ObservableObject {
    let newWindowURL = PassthroughSubject<URL, Never>()
}
