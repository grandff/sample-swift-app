//
//  DataManager.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/02.
//

import Foundation
import CoreData

class DataManager {
    // singleton 으로 개발
    static let shared = DataManager()
    private init() {
        
    }
    
    var mainContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 메모를 저장할 배열 선언
    var memoList = [Memo]()
    
    // 데이터 불러오기 요청
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        // 정렬이 안되어있기 때문에 직접 정렬을 해야함
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        // 데이터 불러오기 실행
        // 예외처리가 필요함
        do{
            memoList = try mainContext.fetch(request)
        }catch {
            print(error)
        }
    }
    
    // 데이터 등록
    func addNewMemo(_ memo: String?) {
        // 메모 모델 생성 (비어있음)
        let newMemo = Memo(context: mainContext)
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        // 메모리스트 배열에도 저장
        // 최근 메모가 앞에 와야하므로 insert 사용
        memoList.insert(newMemo, at: 0)
        
        // 메모 저장
        saveContext()
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SampleSwiftApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
