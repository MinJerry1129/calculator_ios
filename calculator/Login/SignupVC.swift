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
    }
    @IBAction func onSigninBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
