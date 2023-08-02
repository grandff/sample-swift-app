//
//  UIViewController+Alert.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/02.
//

import UIKit

extension UIViewController {
    // 공통으로 사용할 alert
    // style은 크게 alert 또는 action sheet로 나뉨
    func alert(title : String = "알림", message :String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)   // alert 창
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)    // 선택가능한 action
        alert.addAction(okAction)   // 추가한 action을 등록함
        
        present(alert, animated: true, completion: nil) // 경고창을 띄워줌
    }
}
