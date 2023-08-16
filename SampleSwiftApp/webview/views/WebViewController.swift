//
//  WebViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/07/31.
//

import UIKit
import WebKit
import SwiftyUUID

class WebViewController: UIViewController {
            
    @IBOutlet weak var loadingImage: UIImageView!
    @IBOutlet weak var webviewreal: WKWebView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    // webView main url
    let serverUrl = Bundle.main.object(forInfoDictionaryKey: "ServerUrl") as! String
    
    // toast view
    private let toastView = ToastView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width - 40, height: 40))
    
    
    // window.open webview
    var popupView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate 설정
        webviewreal.uiDelegate = self
        webviewreal.navigationDelegate = self
        webviewreal.scrollView.delegate = self
                
        // loading bar
        loadingImage.isHidden = true
        indicatorView.isHidden = true
        
        // webview configuration add
        // INFO storyboard에 추가를 해놨기 때문에 이렇게 하는거고, 만약 스토리보드 안쓰고 하는거면 설정 방식이 다름!!
        let contentController = webviewreal.configuration.userContentController // javascript bridge
        
        // url schema setting
        // INFO iOS14 부터 달라진 설정 방식때문에 나눠놨음. 자바스크립트 설정 허용 추가.
        let webViewConfiguration = webviewreal.configuration
        let webPreferences = webviewreal.configuration.preferences
        let webpagePreferences = WKWebpagePreferences()
        if #available(iOS 14.0, *) {
            webpagePreferences.allowsContentJavaScript = true
            webViewConfiguration.defaultWebpagePreferences = webpagePreferences
        } else {
            webPreferences.javaScriptEnabled = true
        }
        webPreferences.javaScriptCanOpenWindowsAutomatically = true
                        
        
        // 자바스크립트 통신을 위한 브릿지 추가
        let callBackSampleScript : WKUserScript = WKUserScript(source: "callFunctionFromNative()", injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: true)  // natvie에서 web으로 호출할 함수
        contentController.addUserScript(callBackSampleScript)
        
        // 웹에서 설정해놓은 콜백이름으로 추가
        contentController.add(self, name: Constants.WebSchema.callBackHandlerKey)
        contentController.add(self, name: Constants.WebSchema.coreDataCall)
        contentController.add(self, name: Constants.WebSchema.goToNatviePage)
                
        // webview 설정
        webViewInit()
        
        // toast add
        view.addSubview(toastView)
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
        
        // TODO 캐시데이터 설정하는거 필요함
                    
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
        print("\(#function)")
                
        // url schema 자바스크립트 실행
        // url schema가 앱에서 설정한 것과 동일한지 확인
        if let url = navigationAction.request.url, let urlSchema = url.scheme, let urlHost = url.host, urlSchema.uppercased() == Constants.WebSchema.schema.uppercased() {
            print("url : \(url)")
            print("urlSchema : \(urlSchema)")
            print("urlHost: \(urlHost)")
            
            decisionHandler(.cancel)
            
            // call back
            webviewreal.evaluateJavaScript("callSchemaCallBack('\(urlHost)')")
            return
        }
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
        
        // toast show
        toastView.setMessage("Web view init!")
        toastView.alpha = 1.0
        UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
            self.toastView.alpha = 0.0
        }, completion: nil)
        
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
    // 웹뷰에서 줌 확대 동작 방지
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
        print("message name : \(message.name)")
        // 앱에서 설정한 핸들러로 왔을 경우
        if message.name == Constants.WebSchema.callBackHandlerKey {
            print("message body : \(message.body)")
            
            // test callback 확인
            if let dictionary = message.body as? Dictionary<String, AnyObject> {    // 만약 데이터를 json형태로 보낸경우
                print(dictionary)
                var popupPrintString = ""
                dictionary.forEach{
                    (key,value) in
                        popupPrintString += "\(key):\(value)"
                }
                // 전달받은 데이터를 다시 콜백메시지로 보내줌
                webviewreal.evaluateJavaScript("callNativeCallBack('\(popupPrintString)');"){
                    (result, error) in
                    if let error = error {
                        print("error : \(error)")
                    }else if let result = result as? String{
                        print("result : \(result)")
                    }
                }
            }else{  // 아닌 경우
                webviewreal.evaluateJavaScript("callNativeCallBack('\(String(describing:message.body))');")
            }
        }
        
        // web -> natvie page move 를 위한 자바스크립트 리스너
        if message.name == Constants.WebSchema.goToNatviePage, let targetPage = message.body as? String {
            print("targetpage : \(targetPage)")
            if targetPage == "memoPage" {
                moveToMemoPage()
            }
        }
        
        // web <-> app core data 주고 받기
        if message.name == Constants.WebSchema.coreDataCall {
            // 현재 저장되어있는 토큰이 있는지 확인
            let userInfo = UserInfoDataManager.shared.userInfo
            var returnToken :String?
                                    
            if userInfo.count == 0{    // 토큰이 없다면 새로 생성해줌
                let uuid = SwiftyUUID.UUID()
                returnToken = uuid.CanonicalString()
                UserInfoDataManager.shared.updateToken(returnToken)
            }else{  // 토큰이 있다면 기존 토큰을 보내줌
                returnToken = userInfo[0].token
            }
            // 해당 로직이 완료 되고 토스트메시지 부여
            toastView.setMessage("Token is here!")
            toastView.alpha = 1.0
            UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
                self.toastView.alpha = 0.0
            }, completion: nil)
            
            // 현재 토큰 정보 리턴
            webviewreal.evaluateJavaScript("returnAppToken('\(String(describing: returnToken))')")
        }
    }
    
    // natvie page로 이동(kxcoding의 메모화면으로 이동시킴)
    func moveToMemoPage() {
        let targetViewController = self.storyboard?.instantiateViewController(identifier: "MemoList")
        targetViewController?.modalTransitionStyle = .coverVertical // ??
        targetViewController?.modalPresentationStyle = .fullScreen   // 풀스크린으로 설정
        self.present(targetViewController!, animated: true, completion: nil)
        //navigationController?.present(targetViewController!, animated: true)
        //navigationController?.pushViewController(targetViewController, animated: true)
    }
}

// window.open 대응
extension WebViewController {
    // popupview 기본 설정
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // add safe area
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let safeAreaInsets = window?.safeAreaInsets ?? UIEdgeInsets.zero
        let popupFrame = CGRect(x: safeAreaInsets.left, y: safeAreaInsets.top, width: self.view.window!.windowScene!.screen.bounds.width - safeAreaInsets.left - safeAreaInsets.right, height: self.view.window!.windowScene!.screen.bounds.height - safeAreaInsets.top - safeAreaInsets.bottom)
                        
        popupView = WKWebView(frame: popupFrame, configuration: configuration)
        //popupView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupView?.uiDelegate = self
        popupView?.navigationDelegate = self
        
        // webview 닫기를 추가했는데 동작은 안함.. 안보임 일단
        let closeButton = UIButton()
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closePopupView), for: .touchUpInside)
        popupView?.addSubview(closeButton)
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: popupView!.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: popupView!.leadingAnchor, constant: 8),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])
            
        view.addSubview(popupView!)
        
        return popupView
    }
    
    @objc func closePopupView() {
        popupView?.removeFromSuperview()
        popupView = nil
    }
    
    // popupview 닫기
    func webViewDidClose(_ webView: WKWebView) {
        if webView == popupView {
            closePopupView()
        }
    }
}
