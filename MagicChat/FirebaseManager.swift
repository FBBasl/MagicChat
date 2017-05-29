//
//  FirebaseManager.swift
//  Magic Chat
//
//  Created by Асылбек Жилкайдаров on 21.05.17.
//  Copyright © 2017 Test Inc. All rights reserved.
//

import Foundation
import Firebase

struct LoginInfo {
    var email    :String
    var password :String

    init(email:String, password: String) {
    self.email                 = email
    self.password              = password
    }

    init(dictionary: [String: String]?) {

        if dictionary == nil {
    self.email                 = ""
    self.password              = ""
            return
        }

    self.email                 = dictionary!["email"]!
    self.password              = dictionary!["password"]!
    }

    var dictionary: [String:String] {
        return ["email": self.email, "password": self.password]
    }
}
class FirebaseManager {

    static var isEmailVerified = false

    //This function will be called everytime the app launches
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

        if didLinkToProvider {
            return
        }

        Auth.auth().signInAnonymously { (anonymouslyUser:User?, error:Error?) in

            if error == nil && anonymouslyUser != nil {

                print("Anonymously user signed in")

            } else {

                print("Error singing anonymous user")
            }
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

    static var isLoggedIn      = false

    static var didLinkToProvider:Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: "didLinkToProviderKey")
        }
        get{
            return UserDefaults.standard.bool(forKey: "didLinkToProviderKey")
        }
    }

    static func linkingEmailAndPassword(email: String, password: String, completion: @escaping (_ status: Bool, _ error: Error?) -> Void) {

    let credentials            = EmailAuthProvider.credential(withEmail: email, password: password)

        Auth.auth().currentUser?.link(with: credentials, completion: { (user: User?, error: Error?) in
            if error == nil, user != nil {

                user?.sendEmailVerification(completion: { (error: Error?) in
                    if error == nil {
                        print("Did send varification email")
                    }
                })




    self.loginInfo             = LoginInfo.init(email: email, password: password)
    self.didLinkToProvider     = true
    self.isLoggedIn            = true

                completion(true,nil)

            } else {

                completion(false,error)
            }
        })
    }




     static func login(email: String, password: String, completion: @escaping (_ status: Bool, _ error: Error?) -> Void) {

    let credentials            = EmailAuthProvider.credential(withEmail: email, password: password)

        Auth.auth().signIn(with: credentials) { (user:User?,error:Error?) in

            if self.didLinkToProvider == false {

    self.loginInfo             = LoginInfo.init(email: email, password: password)
    self.didLinkToProvider     = true
        }
    self.isLoggedIn            = true

    if user != nil {
                completion(true,nil)
            }else{
                completion(false,error)
            }
        }


    }

    static func signOut() {
    self.loginInfo             = nil
        try? Auth.auth().signOut()
    }

    static func sendPasswordReset(email: String, password: String, completion: @escaping (_ status: Bool) -> Void) {

        Auth.auth().sendPasswordReset(withEmail: email) { (error:Error?) in
            if error == nil {
                completion(true)
            }else {
                completion(false)
            }
        }

    }

    static func StringFromError(error:Error?) -> String {

    guard let firebaseError    = error as? NSError else {
            return ""
        }

    if let errorCode           = AuthErrorCode(rawValue: firebaseError.code) {

            switch errorCode {

            case .invalidEmail:
                return "Email is not value"

            case .userNotFound:
                return "There is no account with this email adress, Please sign up!"

            case .wrongPassword:
                return "Password is not correct, Forgot your password?"

            case .weakPassword:
                return "Passworf must be at least 6 characters"

            case .emailAlreadyInUse:
                return "Email is already is use with different account, Sign in or try forgot my password!"

            case .accountExistsWithDifferentCredential:
                return "User already linked with differenta account, Sign in!"
            default:
                print("Error General:", error?.localizedDescription ?? "")
                return "Error Singin in"

            }
        }
        return ""
    }


}





