//
//  ComposeViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/01.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTaget: Memo?
    
    // 닫기 액션
    @IBAction func close(_ sender: Any) {
        // dismiss 사용
        // completion은 닫았을 떄 실행하는 코드가 들어가야함.. 여기선 아무것도 안할거라서 Nil
        dismiss(animated: true, completion: nil)
    }
    
    // 저장 액션
    @IBAction func save(_ sender: Any) {
        guard let memo = memoTextView.text,
              memo.count > 0 else {
            // 메모가 비어있으면 경고창으로 안내
            alert(message: "메모를 입력하세요!")
            return
        }
        // 메모 추가 (더미데이터)
        //let newMemo = MemoModel(content: memo)
        //MemoModel.dummyMemoList.append(newMemo)
        
        // 수정일때와 쓰기일때 나눠서 처리
        if let target = editTaget {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        } else{
            // 메모 추가 (코어데이터)
            DataManager.shared.addNewMemo(memo)
            // notification 전달
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
                    
        
        // 메모 등록 화면 닫기
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // edittarget에 데이터가 있다면 textview에 편집할 메모 설정
        if let memo = editTaget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        }else{
            // 전달된 메모가 없다면 쓰기 모드임
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// 등록 후 데이터 변경 처리를 위한 notification 추가
extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")   // 메모 등록
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
