//
//  LoginVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift

class LoginVC: UIViewController {
    var signupVC : SignupVC!
    var forgotVC : ForgotVC!
    var homeVC : HomeVC!
    var discloserVC : DiscloserVC!
    var spinnerView = JTMaterialSpinner()
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    var username = ""
    var password = ""
    var user_id = ""
    var loginstatus = "no"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? ""
        loginstatus = UserDefaults.standard.string(forKey: "loginstatus") ?? "no"
        setShadow()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if loginstatus == "yes"{
            self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
            self.homeVC.modalPresentationStyle = .fullScreen
            self.present(self.homeVC, animated: true, completion: nil)
        }
    }
    func setShadow(){
        self.usernameView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.usernameView.layer.shadowRadius = 5
        self.usernameView.layer.shadowOpacity = 0.3
        self.passwordView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.passwordView.layer.shadowRadius = 5
        self.passwordView.layer.shadowOpacity = 0.3
    }
    
    @IBAction func onForgotPassword(_ sender: Any) {
        self.forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "forgotVC") as? ForgotVC
        self.forgotVC.modalPresentationStyle = .fullScreen
        self.present(self.forgotVC, animated: true, completion: nil)
    }
    
    @IBAction func onLoginBtn(_ sender: Any) {
        
        username = usernameTxt.text!
        password = passwordTxt.text!
        if !isValid(){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["username": username,"password": password]
        AF.request(Global.baseUrl + "api/login", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["userid"] as? String
                if status == "nouser"{
                    self.view.makeToast("Input correct username")
                }else if status == "wrongpassword"{
                    self.view.makeToast("Input correct password")
                }else{
                    let userInfo = value["userid"] as? [String: AnyObject]
                    let user_id = userInfo!["id"] as! String

                    AppDelegate.shared().userID = user_id

                    UserDefaults.standard.set(user_id, forKey: "userID")
                    UserDefaults.standard.set("yes", forKey: "loginstatus")

                    self.discloserVC = self.storyboard?.instantiateViewController(withIdentifier: "discloserVC") as? DiscloserVC
                    self.discloserVC.modalPresentationStyle = .fullScreen
                    self.present(self.discloserVC, animated: true, completion: nil)


                }
            }
        }
    }
    
    @IBAction func onSignupBtn(_ sender: Any) {
        self.signupVC = self.storyboard?.instantiateViewController(withIdentifier: "signupVC") as? SignupVC
        self.signupVC.modalPresentationStyle = .fullScreen
        self.present(self.signupVC, animated: true, completion: nil)
    }
    func isValid() -> Bool {
        if username == ""{
            self.view.makeToast("Input Username")
            return false
        }
        if password == ""{
            self.view.makeToast("Input password")
            return false
        }
        return true
    }
}
