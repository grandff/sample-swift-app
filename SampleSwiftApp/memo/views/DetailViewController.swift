//
//  DetailViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/02.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    // 전달받은 데이터. 없을 수도 있으니 ? 붙이기.
    var memo:Memo?
    
    // 날짜 포멧 설정
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")  // 한국 날짜
        return f
    }()
    
    // 편집화면으로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            // 편집할 메모 전달
            vc.editTaget = memo
            
        }
    }
    
    // 공유하기
    @IBAction func share(_ sender: Any) {
        guard let memo = memo?.content else {return}
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)        
        present(vc, animated: true, completion: nil)
    }
    
    // 메모 삭제
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive){
            [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo)
            // 이전화면으로 돌아가기
            // 네비게이션을 통해 이전 화면으로 접근한 다음 popview를 호출함
            self?.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(okAction)
        
        // 취소는 직접 기능 구현을 안해도 됨
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    var token: NSObjectProtocol?
    
    deinit{
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // 옵저버 추가
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in self?.memoTableView.reloadData()})
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

// uitableviewdatasource extension 연결
extension DetailViewController: UITableViewDataSource{
    // 테이블 뷰가 표시할 셀 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // 데이터 표시할 위치 지정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 몇번째 셀인지 설정
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = memo?.content
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = memo?.content
            }
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.secondaryText = formatter.string(for: memo?.insertDate)
                content.secondaryTextProperties.color = .gray
                content.secondaryTextProperties.alignment = .center
                // 폰트사이즈 설정
                let fontDescriptor = content.secondaryTextProperties.font.fontDescriptor.withSize(10)
                content.secondaryTextProperties.font = UIFont(descriptor: fontDescriptor, size: 0)
                cell.contentConfiguration = content
            } else {
                cell.detailTextLabel?.text = formatter.string(for: memo?.insertDate)
            }
            return cell
        default:
            fatalError()
        }
    }
    
    
}
