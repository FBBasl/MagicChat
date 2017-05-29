//
//  Registration2ViewController.swift
//  Magic Chat
//
//  Created by Асылбек Жилкайдаров on 28.05.17.
//  Copyright © 2017 Test Inc. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goButton   : UIButton!
    @IBOutlet weak var nicknameTF : UITextField!
    @IBOutlet weak var emailTF    : UITextField!
    @IBOutlet weak var passwordTF : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInterfaceSettings()
        
        // Do any additional setup after loading the view.
    }
    
    private func setInterfaceSettings() {
        for tf in [passwordTF,emailTF,nicknameTF] {
            tf?.layer.cornerRadius = 10
            tf?.layer.borderWidth  = 1
            tf?.layer.borderColor  = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        }
        
        goButton.layer.borderWidth  = 1
        goButton.layer.borderColor  = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        goButton.layer.cornerRadius = 26
        
        passwordTF.attributedPlaceholder = NSAttributedString(string: "   password",
                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTF.attributedPlaceholder = NSAttributedString(string: "   email",
                                                           attributes: [NSForegroundColorAttributeName: UIColor.white])
        nicknameTF.attributedPlaceholder = NSAttributedString(string: "   nickname",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])

        
    }
    
    @IBAction func goBackAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}

