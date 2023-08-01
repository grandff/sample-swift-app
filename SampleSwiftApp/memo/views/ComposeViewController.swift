//
//  ComposeViewController.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/01.
//

import UIKit

class ComposeViewController: UIViewController {
    
    // 닫기 액션
    @IBAction func close(_ sender: Any) {
        // dismiss 사용
        // completion은 닫았을 떄 실행하는 코드가 들어가야함.. 여기선 아무것도 안할거라서 Nil
        dismiss(animated: true, completion: nil)
    }
    
    
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
