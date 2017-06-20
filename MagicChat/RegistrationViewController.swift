//
//  Registration2ViewController.swift
//  Magic Chat
//
//  Created by Асылбек Жилкайдаров on 28.05.17.
//  Copyright © 2017 Test Inc. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewController: UIViewController {


    @IBOutlet  weak var errorLabel : UILabel!
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
        tf?.layer.cornerRadius             = 10
        tf?.layer.borderWidth              = 1
        tf?.layer.borderColor              = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        }

        goButton.layer.borderWidth         = 1
        goButton.layer.borderColor         = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor
        goButton.layer.cornerRadius        = 26

        passwordTF.attributedPlaceholder   = NSAttributedString(string: "password",
                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
        emailTF.attributedPlaceholder      = NSAttributedString(string: "email",
                                                           attributes: [NSForegroundColorAttributeName: UIColor.white])
        nicknameTF.attributedPlaceholder   = NSAttributedString(string: "nickname",
                                                               attributes: [NSForegroundColorAttributeName: UIColor.white])

    }

    @IBAction func goBackAction(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func goButton(_ sender: AnyObject) {
        register()
    }

    func register() {
        let email                          = emailTF.text
        let password                       = passwordTF.text
        let nickname                       = nicknameTF.text

        FirebaseManager.registerWithDataset(email: email!, password: password!, nickname: nickname!) { (errText: String?) in
        let errText                        = errText

            if errText == "Confirm registration in your mail" {
        self.errorLabel.textColor          = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            } else {

            }
            switch errText {
                
            case "Confirm registration in your mail"?
               : self.errorLabel.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            default
               : self.errorLabel.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            }
            
            

        self.errorLabel.text               = errText
        self.setThePageControllers()
        }

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












