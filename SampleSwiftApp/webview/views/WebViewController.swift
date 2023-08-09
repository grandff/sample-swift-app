//
//  WebViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/07/31.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
            
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var webviewreal: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // web url
    let serverUrl = Bundle.main.object(forInfoDictionaryKey: "ServerUrl") as! String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate 설정
        webviewreal.uiDelegate = self
        webviewreal.navigationDelegate = self
        webviewreal.scrollView.delegate = self
                
        loadingImage.isHidden = true
        indicatorView.isHidden = true
        
        // webview 설정
        webViewInit()
    }
    
    // 인터넷 연결 체크
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard InternetConnectCheck.networkConnect() else{
            let alert = UIAlertController(title: "Network Error", message: "네트워크가 연결되어 있지 않습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "종료", style: .default) { (action) in exit(0)}
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    

    func webViewInit() {
        // 캐시 데이터는 앱 실행 시 제거되도록 설정했음
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0)){
            
        }
        
        
        
        // 좌우 스와이프 동작 시 뒤로가기, 앞으로가기 기능 활성화
        webviewreal.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: serverUrl){
            let request = URLRequest(url : url)
            webviewreal.load(request)
        }
            
    }
}

extension WebViewController : WKUIDelegate{
    // 브라우저 경고창 처리
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "알림창", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default){
            (alert) in completionHandler()
        }
        alert.addAction(okAction)
                
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "확인창", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) {
            (action) in completionHandler(true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) {
            (action) in completionHandler(false)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// navigation delegate add
extension WebViewController : WKNavigationDelegate {
    // 웹뷰가 웹페이지를 읽을지 말지 결정하는 메서드임
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // 웹뷰가 콘텐츠 탐색을 시작할 때 호출
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start provision..")
        loadingImage.isHidden = false
        indicatorView.isHidden = false
        loadingImage.startAnimating()
        indicatorView.startAnimating()
    }
    
    // 웹뷰가 콘텐츠 받기를 완료 했을 때 호출
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish..")
        loadingImage.isHidden = true
        indicatorView.isHidden = true
        loadingImage.stopAnimating()
        indicatorView.stopAnimating()
    }
    
    // 웹뷰가 콘텐츠 받는 중 오류가 났을 때 호출
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("fucking erro")
        loadingImage.isHidden = true
        indicatorView.isHidden = true
        loadingImage.stopAnimating()
        indicatorView.stopAnimating()
    }
}

// 스크롤 제어
extension WebViewController : UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
        
    
    // zooming 막기 ? 시발 이거 아니잖아
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
}

extension WebViewController : WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}
