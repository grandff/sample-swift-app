//
//  DetailViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/02.
//

import UIKit

class DetailViewController: UIViewController {
    
    // 전달받은 데이터. 없을 수도 있으니 ? 붙이기.
    var memo: MemoModel?
    
    // 날짜 포멧 설정
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")  // 한국 날짜
        return f
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                content.secondaryText = formatter.string(for: memo?.insetDate)
                content.secondaryTextProperties.color = .gray                
                content.secondaryTextProperties.alignment = .center
                // 폰트사이즈 설정
                let fontDescriptor = content.secondaryTextProperties.font.fontDescriptor.withSize(10)
                content.secondaryTextProperties.font = UIFont(descriptor: fontDescriptor, size: 0)
                cell.contentConfiguration = content
            } else {
                cell.detailTextLabel?.text = formatter.string(for: memo?.insetDate)
            }
            return cell
        default:
            fatalError()
        }
    }
    
    
}
