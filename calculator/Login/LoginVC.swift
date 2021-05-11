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
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var usernameView: UIView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
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
    }
    
    @IBAction func onLoginBtn(_ sender: Any) {
    }
    
    @IBAction func onSignupBtn(_ sender: Any) {
        self.signupVC = self.storyboard?.instantiateViewController(withIdentifier: "signupVC") as? SignupVC
        self.signupVC.modalPresentationStyle = .fullScreen
        self.present(self.signupVC, animated: true, completion: nil)
        
    }
}
