//
//  ToastView.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/16.
//

import UIKit

class ToastView : UIView {
    // 토스트메시지에 내용을 표시하기 위해 색상, 정렬, 글꼴 등 속성 설정
    private let messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    // 인스턴스 생성 및 배경색 설정
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.2, alpha: 0.8)
        layer.cornerRadius = 8
        addSubview(messageLabel)
    }
        
    required init?(coder aDecoder:NSCoder) {
        fatalError("message view error")
    }
    
    // 메시지 설정
    func setMessage(_ message:String) {
        messageLabel.text = message
    }
    
    // toastview의 레이아웃이 변경될때마다 호출
    override func layoutSubviews() {
        super.layoutSubviews()
        messageLabel.frame = bounds.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
}
