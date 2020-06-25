//
//  TodoListTVC.swift
//  Assignment
//
//  Created by Souvik on 24/06/20.
//  Copyright © 2020 DemoApp. All rights reserved.
//

import UIKit
import CoreData

class TodoListTVC: UITableViewController {
    
    // UI Property
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTxtField: UITextField!
    
    
    var viewModel = TodoListViewModel()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchView.layer.cornerRadius = 10
        searchView.clipsToBounds = true
        viewModel.delegate = self
        
        tableView.rowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if let delegate = appDelegate {
            viewModel.fetchFromDB(appDelegate: delegate)
            searchTxtField.delegate = self
        }
    }
    
    @IBAction func AddItem(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateTodoViewController") as! CreateTodoViewController
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if viewModel.list.count > 0 {
            tableView.restore()
            return viewModel.list.count
        } else {
            tableView.setEmptyView(title: "TodoList", message: "No item addedin TodoList")
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Allocate Cell
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as? TodoTableViewCell {
            
            cell.delegate = self
            cell.set(withData: viewModel.list[indexPath.row], index: indexPath.row)
            
            return cell
        } else {
            return TodoTableViewCell()
        }
    }
    
}

extension TodoListTVC: cellDelegate {
    func updateData(index: Int, title: String?, desc: String?) {
        
        if let appDelegate = appDelegate {
            viewModel.deleteData(appDelegate: appDelegate, index: index)
            viewModel.insertData(appDelegate: appDelegate, title: title ?? "", desc: desc ?? "", index: index)
        }
        
    }
}

extension TodoListTVC: TodoDelegate {
    func refreshData() {
        if viewModel.list.count == 0 {
        } else {
            viewModel.filteData()
        }
        tableView.reloadData()
    } 
}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Roobert", size: 20)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
    }
    func restore() {
        self.backgroundView = nil
    }
}

// MARK: TExtView Delegate
extension TodoListTVC: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (searchTxtField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if let appDelegate = appDelegate {
            if text != "" {
              viewModel.fetchFromDB(appDelegate: appDelegate, searchTxt: text)
            } else {
                viewModel.fetchFromDB(appDelegate: appDelegate, searchTxt: nil)
            }
            
        }
        return true
    }
}
