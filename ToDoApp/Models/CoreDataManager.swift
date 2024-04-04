//
//  MemoDataManager.swift
//  ToDoApp
//
//  Created by 이가을 on 4/4/24.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    // singleton!!
    static let shared = CoreDataManager()
    private init() {}
    
    // AppDelegate의 persistent containser에서 context를 불러오기
    let appDelegate = UIApplication.shared.delegate as? AppDelegate // AppDelegate 가져오기
    lazy var context = appDelegate?.persistentContainer.viewContext // context(임시 저장소) 가져오기
    
    let modelName: String =  "ToDoData" // 엔티티 이름
    
    // MARK: - [Read] 코어데이터에 저장된 데이터 모두 읽어오기
    func getToDoListFromCoreData() -> [ToDoData] {
        var toDoList: [ToDoData] = []
        if let context = context { // 임시저장소 있는지 확인
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName) // 요청서
            let dateOrder = NSSortDescriptor(key: "date", ascending: false) // 정렬순서를 정해서 요청서에 넘겨주기
            request.sortDescriptors = [dateOrder]
            
            do {
                // 임시저장소에서 (요청서를 통해서) 데이터 가져오기 (fetch메서드)
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] {
                    toDoList = fetchedToDoList
                }
            } catch {
                print("가져오기 실패")
            }
        }
        
        return toDoList
    }
    
    // MARK: - [Create] 코어데이터에 데이터 생성하기
    func saveToDoData(memo: String, colorInt: Int64) {
        if let context = context { // 임시저장소 있는지 확인
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) { // 임시저장소에 있는 데이터를 그려줄 형태 파악하기
                if let toDoData = NSManagedObject(entity: entity, insertInto: context) as? ToDoData { // 임시저장소에 올라가게 할 객체만들기 (NSManagedObject ===> ToDoData)
                    toDoData.memoText = memo
                    toDoData.date = Date()
                    toDoData.color = colorInt
                    
                    //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - [Delete] 코어데이터에서 데이터 삭제하기 (일치하는 데이터 찾아서 ===> 삭제)
    func deleteToDo(data: ToDoData) {
        guard let date = data.date else { return }
        
        if let context = context { // 임시저장소 있는지 확인
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName) // 요청서
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg) // 단서 / 찾기 위한 조건 설정
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] { // 요청서를 통해서 데이터 가져오기 (조건에 일치하는 데이터 찾기)
                    if let targetToDo = fetchedToDoList.first { // 임시저장소에서 (요청서를 통해서) 데이터 삭제하기 (delete메서드)
                        context.delete(targetToDo)
                        
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            } catch {
                print("지우기 실패")
            }
        }
    }
    
    
    // MARK: - [Update] 코어데이터에서 데이터 수정하기 (일치하는 데이터 찾아서 ===> 수정)
    func updateToDo(newData: ToDoData) {
        guard let date = newData.date else { return }
        
        if let context = context { // 임시저장소 있는지 확인
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName) // 요청서
            request.predicate = NSPredicate(format: "date = %@", date as CVarArg) // 단서 / 찾기 위한 조건 설정
            
            do {
                if let fetchedToDoList = try context.fetch(request) as? [ToDoData] { // 요청서를 통해서 데이터 가져오기
                    if var targetToDo = fetchedToDoList.first {
                        targetToDo = newData // 실제 데이터 재할당(바꾸기)
                        
                        //appDelegate?.saveContext() // 앱델리게이트의 메서드로 해도됨
                        if context.hasChanges {
                            do {
                                try context.save()
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            } catch {
                print("업데이트 실패")
            }
        }
    }
    
}
