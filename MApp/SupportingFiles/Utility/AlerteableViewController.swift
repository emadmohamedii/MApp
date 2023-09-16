//
//  AlerteableViewController.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import Foundation
import UIKit
import RxSwift


protocol AlerteableViewController {
    
    func presentAlert(title: String?,
                      message: String?,
                      textField: AlertTextField?,
                      buttonTitle: String?,
                      cancelButtonTitle: String?,
                      alertClicked: ((AlertButtonClicked) -> Void)?)
    
}


enum AlertButtonClicked {
    case Button
    case ButtonWithText(String?)
    case Cancel
}

func == (lhs: AlertButtonClicked, rhs: AlertButtonClicked) -> Bool {
    switch (lhs, rhs) {
    case (.Button, .Button):
        return true
    case (.ButtonWithText, .ButtonWithText):
        return true
    case (.Cancel, .Cancel):
        return true
    default:
        return false
    }
}

struct AlertTextField {
    let text: String?
    let placeholder: String?
    
    init(text: String?, placeholder: String?) {
        self.text = text
        self.placeholder = placeholder
    }
}
extension UIViewController {
    func showAlertDialogueWithAction(title:String = "", withMessage message:String?, withActions actions: UIAlertAction... , withStyle style:UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if actions.count == 0 {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        } else {
            for action in actions {
                alert.addAction(action)
            }
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertDialogue( title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
