//
//  Authentication2ViewController.swift
//  Magic Chat
//
//  Created by Асылбек Жилкайдаров on 28.05.17.
//  Copyright © 2017 Test Inc. All rights reserved.
//

import UIKit
import Firebase

class AuthenticationViewController: UIViewController {

    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var authLabel  : UILabel!
    @IBOutlet weak var parolTF    : UITextField!
    @IBOutlet weak var emailTF    : UITextField!
    @IBOutlet weak var loginButton: UIButton!

    @IBAction func loginButton(_ sender: Any) {
        
        FirebaseManager.linkingWithEmailAndPassword(email: emailTF.text!, password: parolTF.text!) { (status, errorText) in
            
            self.errorLabel.text = errorText
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setInterfaceSettings()
        // Do any additional setup after loading the view.
    }
    
    private func setInterfaceSettings() {
        for tf in [parolTF,emailTF] {
        tf?.layer.cornerRadius         = 10
        tf?.layer.borderWidth          = 1
        tf?.layer.borderColor          = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        }

        loginButton.layer.borderWidth  = 1
        loginButton.layer.borderColor  = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        loginButton.layer.cornerRadius = 26

        parolTF.attributedPlaceholder  = NSAttributedString(string: "password",
                                                           attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTF.attributedPlaceholder  = NSAttributedString(string: "email",
                                                           attributes: [NSForegroundColorAttributeName: UIColor.white])

    }
    
    func setThePageControllers() {
        UIView.animate(withDuration: 0.6) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let pageVCs = storyboard.instantiateViewController(withIdentifier:String(describing: GeneralPageController.self)) as! GeneralPageController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = pageVCs
            
            print("Auth done")
        }
    }

}
