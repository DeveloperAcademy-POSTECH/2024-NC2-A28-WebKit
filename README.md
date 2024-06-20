# 2024-NC2-A28-WebKit
## 🎥 Youtube Link
(추후 만들어진 유튜브 링크 추가)

## 💡 About WebView
- `WKWebView`를 활용해 HTML/CSS/JavaScript로 이루어진 **웹 콘텐츠를 앱 내에 표시**
- 프로토콜 `WKUIDelegate`
    - JavaScript **Alert / Confirm 패널 / Text Input 패널** 표시
- `WKBackForwardList` 클래스
    - `backItem` / `currentItem` / `forwardItem`으로 방문한 **웹 페이지 목록 순회**
- `evaluateJavaScript` 메소드
    - WKWebView로 표시된 **웹 콘텐츠에 JavaScript 주입**

## 🎯 What we focus on?
### func evaluateJavascript()

#### Evaluates the specified JavaScript string.

WebView 사용 시 WebView 안에서 **사용자가 취해야 하는 액션이 많음**

스크립트 주입으로 웹뷰 사용 중 사용자가 취해야 하는 **액션을 자동화**한다면 ?

**더 나은 사용자 경험 !**
## 💼 Use Case
티켓팅 플랫폼과 서버시간을 함께 띄워주자!

## 🖼️ Prototype
티켓팅 플랫폼을 선택하면, 상단의 네이비즘 웹뷰에 스크립트가 주입되어 해당 플랫폼의 서버시간을 찾아 오고 웹뷰 내에서 서버시간 시계가 위치한 곳으로 웹뷰를 스크롤합니다.

![Untitled (2)](https://github.com/DeveloperAcademy-POSTECH/2024-NC2-A28-WebKit/assets/55729213/82c97671-6df0-48d2-a918-3bc7ec86429c)

## 🛠️ About Code
```swift
// 스크립트 주입 함수
func injectScript(webView: NavyismWebView, url: String) {
    let script = """
    document.querySelector('#inputhere').value = '\(url)';
    document.querySelector('#buttonFight').click();
    """
    webView.webView.evaluateJavaScript(script) { result, error in
        if let error = error {
            print(error.localizedDescription)
        }
    }
}
```
```swift
// 네이비즘 웹뷰
import SwiftUI
import WebKit

struct NavyismWebView: UIViewRepresentable {
    var url: String
    let webView: WKWebView = WKWebView()
    @State var isLoading = true
    
    // 코디네이터 클래스
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: NavyismWebView

        init(_ parent: NavyismWebView) {
            self.parent = parent
        }
        // 웹컨텐츠 로드 완료시 스크립트 주입
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.querySelector('#time_area').scrollIntoView({behavior: 'smooth', block: 'start'});") { _, error in
                if error == nil {
                    self.parent.isLoading = false
                }
            }
        }
    }
    // 코디네이터 생성
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    // UIView 생성
    func makeUIView(context: Context) -> UIView {
        let containerView = UIView()
        
        guard let url = URL(string: url) else {
            return containerView
        }
        
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        
        let hostingController = UIHostingController(rootView: Text("네이비즘 불러오는 중 🏃🏃").font(.title3).bold())
        hostingController.view.frame = containerView.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(hostingController.view)
        
        if !isLoading {
            webView.frame = containerView.bounds
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.addSubview(webView)
        }
        
        return containerView
    }
    // UIView 업데이트
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let url = URL(string: url) else { return }
        
        if isLoading {
            webView.load(URLRequest(url: url))
        } else {
            for subview in uiView.subviews {
                if subview is WKWebView {
                    subview.removeFromSuperview()
                }
            }
            
            webView.frame = uiView.bounds
            webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            uiView.addSubview(webView)
        }
    }
}
```
```swift
// 플랫폼 웹뷰
import SwiftUI
import WebKit
import Photos

struct PlatformWebView: UIViewRepresentable {
    var url: String
    let webView: WKWebView = WKWebView()
    
    var homeVM: HomeViewModel

    // 코디네이터
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: PlatformWebView

        init(_ parent: PlatformWebView) {
            self.parent = parent
            self.parent.webView.allowsBackForwardNavigationGestures = true
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.homeVM.canGoBack = webView.canGoBack
            parent.homeVM.canGoForward = webView.canGoForward
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.homeVM.canGoBack = webView.canGoBack
            parent.homeVM.canGoForward = webView.canGoForward
        }
    }
    // 코디네이터 생성
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    // UIView 생성
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(webView, action: #selector(WKWebView.webViewPullToRefreshHandler(source:)), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl
        webView.scrollView.bounces = true
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        
        return webView
    }
    // UIView 업데이트
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: url) else { return }
        
        webView.load(URLRequest(url: url))
    }
    
}

// 스냅샷 생성 및 저장 함수
extension PlatformWebView {
    func takeAndStoreSnapshot(completion: @escaping (Bool) -> Void) {
        let config = WKSnapshotConfiguration()
        webView.takeSnapshot(with: config) { image, error in
            guard let image = image, error == nil else {
                print("Snapshot error: \(String(describing: error))")
                completion(false)
                return
            }
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
        }
    }
}

// PTR 핸들러 함수
extension WKWebView {
    @objc func webViewPullToRefreshHandler(source: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.reload()
            source.endRefreshing()
        }
    }
}
```
