//
//  CreateTodoViewController.swift
//  Assignment
//
//  Created by Souvik on 25/06/20.
//  Copyright © 2020 DemoApp. All rights reserved.
//

import UIKit

class CreateTodoViewController: UIViewController {
    
    // UI Property
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var viewModel = createTodoViewModel()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiSetup(button: cancelBtn)
        uiSetup(button: doneBtn)
        textViewInitial()
        viewModel.delegate = self
        doneButtonValidator(checkEmpty: false)
        
    }
    
    @IBAction func DoneAction(_ sender: Any) {
        
        if let appDelegate = appDelegate {
            viewModel.saveModel(title: titleTextField.text ?? "", desc: descriptionTextView.text, appDelegate: appDelegate)
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateTodoViewController: TodoCreateDelegate {
    func refreshData() {
//        if let model = viewModel.model, let title = model.titile {
//            titleTextField.text = title
//            descriptionTextView.text = model.desc
//        }
    }
    
    func saveSuccess() {
        
        titleTextField.text = ""
        textViewInitial()
        let alert = UIAlertController(title: "Todo Item", message: "Saved Succesfully", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UI Setup
extension CreateTodoViewController {
    
    private func uiSetup(button: UIButton) {
        button.layer.cornerRadius = 5.0
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1.0
        button.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    private func textViewInitial() {
        
        descriptionTextView.text = "Enter Description"
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        titleTextField.delegate = self
    }
    
    private func doneButtonValidator(checkEmpty: Bool) {
        
        if checkEmpty == true {
            doneBtn.alpha = 1.0
            doneBtn.isUserInteractionEnabled = true
        } else {
            doneBtn.alpha = 0.6
            doneBtn.isUserInteractionEnabled = false
        }
    }
}

// MARK: TExtView Delegate
extension CreateTodoViewController: UITextViewDelegate, UITextFieldDelegate {
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (titleTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if text != "" && descriptionTextView.text != "Enter Description" && descriptionTextView.text != "" {
            doneButtonValidator(checkEmpty: true)
        } else {
            doneButtonValidator(checkEmpty: false)
        }
        
        if text.count > 40 {
            return false
        }
        return true
    }
    
    internal func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let text = (descriptionTextView.text! as NSString).replacingCharacters(in: range, with: text)
        
        if text != "" && titleTextField.text != "" {
            doneButtonValidator(checkEmpty: true)
        } else {
            doneButtonValidator(checkEmpty: false)
        }
        return true
        
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter Description"
            textView.textColor = UIColor.lightGray
        }
        
    }
}
