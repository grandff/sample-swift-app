//
//  SampleDataManager.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/10.
//

import Foundation
import CoreData

class UserInfoDataManager{
    // singleton 으로 개발
    static let shared = UserInfoDataManager()
    private init() {
        
    }
    
    var userInfo = [UserInfo]()
    
    var mainContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // 데이터 불러오기
    func fetchToken() {
        let request: NSFetchRequest<UserInfo> = UserInfo.fetchRequest()
        
        do{
            userInfo = try mainContext.fetch(request)
        }catch {
            print(error)
        }
    }
    
    // 데이터 등록
    func updateToken(_ token: String?){
        // 토큰 모델 생성
        let newUserInfo = UserInfo(context: mainContext)
        newUserInfo.token = token
        
        userInfo.insert(newUserInfo, at: 0)
        saveContext()
    }
    
    // 데이터 삭제
    func deleteToken(_ info: UserInfo?){
        if let info = info {
            mainContext.delete(info)
            saveContext()
        }
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
