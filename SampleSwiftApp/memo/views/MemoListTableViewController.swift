//
//  MemoListTableViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/07/31.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    // 날짜 포멧 설정
    let formatter: DateFormatter = {
       let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")  // 한국 날짜
        return f
    }()
    
    // 메모 목록 업데이트
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //tableView.reloadData()  // 시트 넘어가는 방식마다 다 다름 ios11부터는 시트형식으로 올라오는데 그떄는 이 방식을 사용 못함
        //print("view will apper?")
    }
    
    // notification 객체, 즉 토큰을 저장할 변수 생성
    var token : NSObjectProtocol?
    
    // notificatoin 제거 (사용하고나서 꼭 제거해야함)
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }

    // 한번만 실행되는 초기화코드 구현
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // notiication 수신 처리 추가
        // 순서대로 수신받을 noti 이름 / 보통 object는 nil을 쓴다고 함 / 처리할 쓰레드 / 쓰레드에 보낼 closure action
        // 데이터 갱신 요청
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main){
            [weak self] (noti) in self?.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    /* 미사용
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    // cell 카운트 설정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("fucking?")
        // 더미데이터 숫자만큼 설정함
        return MemoModel.dummyMemoList.count
    }

    // cell이 생성될때마다 호출됨
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) // 아까 설정한 identifier로 설정
        
        // 더미데이터 출력
        let target = MemoModel.dummyMemoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(from: target.insetDate)   // 날짜 포멧팅 설정

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
