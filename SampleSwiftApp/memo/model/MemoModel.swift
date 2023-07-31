//
//  MemoModel.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/07/31.
//

import Foundation

class MemoModel{
    var content: String // 메모내용
    var insetDate: Date // 메모날짜
    
    // 초기화
    init(content: String) {
        self.content = content
        insetDate = Date()
    }
    
    static var dummyMemoList = [        
        MemoModel(content : "Hi My name is Memo. How are you I'm fine and you 1 ? "),
        MemoModel(content: "Hi My name is Memo. How are you I'm fine and you 2 ? "),
        MemoModel(content: "Hi My name is Memo. How are you I'm fine and you 3 ? "),
        MemoModel(content: "Hi My name is Memo. How are you I'm fine and you 4 ? "),
        MemoModel(content: "Hi My name is Memo. How are you I'm fine and you 5 ? "),
        MemoModel(content: "Hi My name is Memo. How are you I'm fine and you 6 ? ")
    ]
}
