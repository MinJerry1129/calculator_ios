//
//  ForgotVC.swift
//  calculator
//
//  Created by bird on 5/12/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
class ForgotVC: UIViewController {
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var usernameView: UIView!
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    
    var email = ""
    var username = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func setShadow(){
        self.usernameView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.usernameView.layer.shadowRadius = 5
        self.usernameView.layer.shadowOpacity = 0.3
        self.emailView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.emailView.layer.shadowRadius = 5
        self.emailView.layer.shadowOpacity = 0.3
    }
    @IBAction func onUpdatePasswordBtn(_ sender: Any) {
        email = emailTxt.text!
        username = usernameTxt.text!
        if !isValid(){
            return
        }
    }
    
    @IBAction func onLoginBtn(_ sender: Any) {
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
        return true
    }
}
