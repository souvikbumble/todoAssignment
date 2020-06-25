//
//  TodoTableViewCell.swift
//  Assignment
//
//  Created by Souvik on 24/06/20.
//  Copyright © 2020 DemoApp. All rights reserved.
//

import UIKit
import CoreData

protocol cellDelegate: class {
    func updateData(index: Int, title: String?, desc: String?)
}

class TodoTableViewCell: UITableViewCell {
    
    //UI Property
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var checkBox: UIButton!
    
    
    var delegate: cellDelegate?
    var model: NSManagedObject?
    var currentIndex: Int?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func dataInitalize() {
        
        if let model = model {
            
            if model.value(forKey: "title") != nil &&  model.value(forKey: "desc") != nil{
                titleLbl.text = (model.value(forKey: "title") as! String)
                descLbl.text = (model.value(forKey: "desc") as! String)
            }
            
            if (model.value(forKey: "selected") as! Bool) == true {
                checkBox.setImage(UIImage(named: "check"), for: .normal)
                checkBox.isUserInteractionEnabled = false
            } else {
                checkBox.setImage(UIImage(named: "uncheck"), for: .normal)
                checkBox.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func buttonChecker(_ sender: Any) {
        
        if let currentIndex = currentIndex {
            //model?.selected = true
            delegate?.updateData(index: currentIndex, title: (model?.value(forKey: "title") as! String), desc: (model?.value(forKey: "desc") as! String))
        }
    }
    
}

extension TodoTableViewCell {
    
    @discardableResult
    func set(withData model: NSManagedObject?, index: Int?) -> Self {
        
        if let index = index {
            currentIndex = index
        }
        
        if let list = model {
            self.model = list
            dataInitalize()
        }
        
        return self
    }
}
