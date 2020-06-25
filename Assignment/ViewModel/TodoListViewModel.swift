//
//  TodoListViewModel.swift
//  Assignment
//
//  Created by Souvik on 25/06/20.
//  Copyright © 2020 DemoApp. All rights reserved.
//

import Foundation
import CoreData

protocol TodoDelegate: class {
    func refreshData()
}

class TodoListViewModel {
    
    var delegate: TodoDelegate?
    var list = [NSManagedObject]()
    
    func fetchFromDB(appDelegate: AppDelegate, searchTxt: String? = nil) {
        
        list.removeAll()
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        
        if let searchTxt = searchTxt {
            //fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchTxt)
        }
        
        //
        do {
            list = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch {
        }
        
        delegate?.refreshData()
    }
    
    func filteData() {
        let dSelected  = list.filter {$0.value(forKey: "selected") as! Bool == false}
        let selected = list.filter {$0.value(forKey: "selected") as! Bool == true}
        list.removeAll()
        list = dSelected + selected
    }
    
    func deleteData(appDelegate: AppDelegate, index: Int){
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do
        {
            let objectToDelete = list[index]
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
    }
    
    func insertData(appDelegate: AppDelegate, title: String?, desc: String?, index: Int) {
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let todoEntity = NSEntityDescription.entity(forEntityName: "TodoList", in: managedContext)!
        
        let list = NSManagedObject(entity: todoEntity, insertInto: managedContext)
        
        list.setValue(title ?? "", forKey: "title")
        list.setValue(desc ?? "", forKey: "desc")
        list.setValue(true, forKey: "selected")
        
        do {
            try managedContext.save()
            fetchFromDB(appDelegate: appDelegate)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
