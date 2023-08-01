//
//  WebViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/07/31.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
            
    @IBOutlet weak var webviewreal: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate 설정
        webviewreal.uiDelegate = self
        
        // webview 설정
        webViewInit()
        
        
    }
    

    func webViewInit() {
        // 캐시 데이터는 앱 실행 시 제거되도록 설정했음
        WKWebsiteDataStore.default().removeData(ofTypes: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache], modifiedSince: Date(timeIntervalSince1970: 0)){
            
        }
        
        // 좌우 스와이프 동작 시 뒤로가기, 앞으로가기 기능 활성화
        webviewreal.allowsBackForwardNavigationGestures = true
        
        if let url = URL(string: "https://m.naver.com"){
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
    
    /*
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async -> Bool {
        <#code#>
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo) async -> String? {
        <#code#>
    }
     */
}
