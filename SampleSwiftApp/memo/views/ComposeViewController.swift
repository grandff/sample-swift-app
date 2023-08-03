//
//  ComposeViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/01.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTaget: Memo?
    var originalMemoContent: String?    // 편집 이전의 데이터
        
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
    
    
    // 키보드 notification
    var willShowToken : NSObjectProtocol?
    var willHideToken : NSObjectProtocol?
    
    // 옵저버 제거
    deinit{
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // edittarget에 데이터가 있다면 textview에 편집할 메모 설정
        if let memo = editTaget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        }else{
            // 전달된 메모가 없다면 쓰기 모드임
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        
        memoTextView.delegate = self
        
        // 키보드가 생성되기 전 전달되는 noti
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else { return }
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height   // 키보드 높이
                
                var inset = strongSelf.memoTextView.contentInset    // 현재 높이
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                // 스크롤처리
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        // 키보드가 사라질때 전달되는 noti
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in
            guard let strongSelf = self else {return}
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 자동으로 포커스 가게
        memoTextView.becomeFirstResponder()
        navigationController?.presentationController?.delegate = self   // 필수
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 포커스 해제
        memoTextView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil    // 필수
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

// 취소 여부 확인 추가
extension ComposeViewController : UITextViewDelegate {
    // 텍스트가 편집될때마다 호출됨
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent, let edited = textView.text {
            // 수정된것과 실제와 다르면 메모가 편집된것으로 판단함
            isModalInPresentation = original != edited
        }
        
    }
}

extension ComposeViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        // 취소 확인을 alert 생성
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) {
            [weak self] (action) in
            self?.save(action)
        }
        
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel ){
            [weak self] (action) in
            self?.close(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
