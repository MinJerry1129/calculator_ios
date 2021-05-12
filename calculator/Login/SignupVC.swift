//
//  SignupVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
class SignupVC: UIViewController {

    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    
    var email = ""
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
    }
    func setShadow(){
        self.emailView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.emailView.layer.shadowRadius = 5
        self.emailView.layer.shadowOpacity = 0.3
        self.usernameView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.usernameView.layer.shadowRadius = 5
        self.usernameView.layer.shadowOpacity = 0.3
        self.passwordView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.passwordView.layer.shadowRadius = 5
        self.passwordView.layer.shadowOpacity = 0.3
    }
    
    @IBAction func onSignupBtn(_ sender: Any) {
        email = emailTxt.text!
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
        let parameters: Parameters = ["email": email , "username": username, "password": password]
        AF.request(Global.baseUrl + "api/signup", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    let alert = UIAlertController(title: "Signup Done", message: "Thanks for your registration", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "O K", style: .default, handler: { _ in
                                self.dismiss(animated: true, completion: nil)
                            }))
                            self.present(alert, animated: true, completion: nil)
                }else if status == "existemail"{
                    self.view.makeToast("Your email already exist")
                }else if status == "existuser"{
                    self.view.makeToast("Your username already exist")
                }else {
                    self.view.makeToast("Fail signup")
                }
            }else {
                self.view.makeToast("Fail signup")
            }
        }
        
    }
    @IBAction func onSigninBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func isValid() -> Bool {
        if email == ""{
            self.view.makeToast("Input Email Address")
            return false
        }else{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailPred.evaluate(with: email){
                self.view.makeToast("Input correct email address")
                return false
            }
        }
        if username == ""{
            self.view.makeToast("Input Username")
            return false
        }
        if password == ""{
            self.view.makeToast("Input password")
            return false
        }else{
            if password.count < 6{
                self.view.makeToast("Input password more than 6 characters")
                return false
            }
        }
        return true
    }
}
