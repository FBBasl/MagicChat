//
//  FirebaseManager.swift
//  MagicChat
//
//  Created by Асылбек Жилкайдаров on 30.05.17.
//  Copyright © 2017 Test Inc. All rights reserved.
//

import Firebase
import UIKit

struct LoginInfo {
    var email    :String
    var password :String
    var nickname : String
    
    init(email:String, nickname: String, password: String) {
        self.email              = email
        self.password           = password
        self.nickname           = nickname
    }

    init(dictionary: [String: String]?) {

        if dictionary == nil {
        self.email              = ""
        self.password           = ""
        self.nickname           = ""
            return
        }

        self.email              = dictionary!["email"]!
        self.password           = dictionary!["password"]!
        self.nickname           = dictionary!["nickname"]!
    }

    var dictionary: [String:String] {
        return ["email": self.email, "password": self.password, "nickname": self.nickname]
    }
}


class FirebaseManager {

    static var errorText: String?
    
    static var isEmailVerified = false
    
    static var didLinkToProvider:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "didLinkToProviderKey")
        }
        get{
            return UserDefaults.standard.bool(forKey: "didLinkToProviderKey")
        }
    }
    
    static var loginInfo: LoginInfo? {
        set{
            UserDefaults.standard.set(newValue?.dictionary, forKey: "loginInfoKey")
        }
        get {
            return LoginInfo.init(dictionary: (UserDefaults.standard.dictionary(forKey: "loginInfoKey") as? [String: String])!)
        }
    }
    
    static func setup() {
        
        Auth.auth().addStateDidChangeListener { (Auth, user: User?) in
            
            if let user                = user, user.isEmailVerified && didLinkToProvider{
                
                self.isEmailVerified       = true
                
            } else if let user         = user, !user.isEmailVerified && didLinkToProvider {
                
                self.isEmailVerified       = false
                
            } else {
                print("User not authenticated")
            }
        }
    }
    
    static func linkingWithEmailAndPassword(email: String, password: String, completion: @escaping (_ status: Bool, _ errorText: String?) -> Void) {
        
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                print(error!)
                
                error != nil ? completion(false, StringFromError(error: error)) : completion(false, "")
                
                return
            }
        
            setThePageControllers()
            
            (user?.isEmailVerified)! ? print("verified") : print("is not varified")
            
        })
        
    }
    
    static func setThePageControllers() {
        UIView.animate(withDuration: 0.6) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let pageVCs = storyboard.instantiateViewController(withIdentifier:String(describing: GeneralPageController.self)) as! GeneralPageController
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = pageVCs
            
            print("Auth done")
        }
    }

    static func registerWithDataset(email: String, password: String, nickname: String, completion: @escaping (_ errorText: String?) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in

            //Проверка на ошибки
            if error != nil{

                print(error!)

                completion(StringFromError(error: error))

                return
            }
            
        //Проверка на успешность регистрации
        guard let uid           = user?.uid else {
                return
            }
            
            user?.sendEmailVerification(completion: { (error) in
                if error == nil {
                    print("Did send verification")
                }
            })
            
            //Успешно зарегистрированный юзер
            let ref            = Database.database().reference(fromURL: "https://magicchat-e3815.firebaseio.com/")
            
            //Добавляем юзера в ветку users
            let usersReference = ref.child("users").child(uid)
            
            let values         = ["nickname": nickname as AnyObject, "email": email as AnyObject] as [String : AnyObject]
            
            //Созданному юзеру добавляем его данные
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in

                if err != nil {
                    print(err!)
                    return
                }
                
                print("Saved user successfully into Firebase db")

            })
            
            completion("Confirm registration in your mail")
            
            self.loginInfo = LoginInfo.init(email: email, nickname: nickname, password: password)
            self.didLinkToProvider     = true

        })
    }

    static func StringFromError(error:Error?) -> String {

        guard let firebaseError = error as NSError? else {
            return ""
        }

        //Для ошибки возвращаем из метода его текст
        if let errorCode        = AuthErrorCode(rawValue: firebaseError.code) {

            switch errorCode {

            case .invalidEmail:
                return "Email is not correct"

            case .userNotFound:
                return "There is no account with this email adress, Please sign up!"

            case .wrongPassword:
                return "Password is not correct, Forgot your password?"

            case .weakPassword:
                return "Password must be at least 6 characters"

            case .emailAlreadyInUse:
                return "The email address is already in use by another account"

            case .accountExistsWithDifferentCredential:
                return "User already linked with different account, Sign in!"
            default:
                print("Error General:", error?.localizedDescription ?? "")
                return "Error Singin in"

            }
        }
        return ""
    }




}















