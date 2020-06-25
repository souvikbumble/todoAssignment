//
//  createTodoViewModel.swift
//  Assignment
//
//  Created by Souvik on 25/06/20.
//  Copyright © 2020 DemoApp. All rights reserved.
//

import Foundation
import CoreData

protocol TodoCreateDelegate: class {
    func refreshData()
    func saveSuccess()
}

class createTodoViewModel {
    
    var delegate: TodoCreateDelegate?
    
    var list = [NSManagedObject]()
    
    func saveModel(title: String, desc: String?, appDelegate: AppDelegate) {
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext

        let todoEntity = NSEntityDescription.entity(forEntityName: "TodoList", in: managedContext)!
        
        let list = NSManagedObject(entity: todoEntity, insertInto: managedContext)
        list.setValue(title, forKey: "title")
        list.setValue(desc, forKey: "desc")
        list.setValue(false, forKey: "selected")
        do {
            try managedContext.save()
            delegate?.saveSuccess()
           
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
  
    }
    
}
