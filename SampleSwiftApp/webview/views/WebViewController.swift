//
//  WebViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/07/31.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
        
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // webview 설정
        webViewInit()
    }
    

    func webViewInit() {
        
    }
}
