//
//  ChangePasswordVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
class ChangePasswordVC: UIViewController {

    @IBOutlet weak var newpasswordTxt: UITextField!
    @IBOutlet weak var oldpasswordTxt: UITextField!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var oldView: UIView!
    var oldpassword = ""
    var newpassword = ""
    var user_id = ""
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        setShadow()
    }

    func setShadow(){
        self.newView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.newView.layer.shadowRadius = 5
        self.newView.layer.shadowOpacity = 0.3
        self.oldView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.oldView.layer.shadowRadius = 5
        self.oldView.layer.shadowOpacity = 0.3
    }
    
    @IBAction func onCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSetBtn(_ sender: Any) {
        oldpassword = oldpasswordTxt.text!
        newpassword = newpasswordTxt.text!
        if !isValid(){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id , "oldpass": oldpassword, "newpass": newpassword]
        AF.request(Global.baseUrl + "api/signup", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "wrongpassword"{
                    self.view.makeToast("Check original password")
                }else if status == "ok"{
                    self.view.makeToast("Update Success!")
                }else {
                    self.view.makeToast("Fail Update")
                }
            }else {
                self.view.makeToast("Fail Update")
            }
        }
        
    }
    func isValid() -> Bool {
        if oldpassword == ""{
            self.view.makeToast("Input password")
            return false
        }else{
            if oldpassword.count < 6{
                self.view.makeToast("Input password more than 6 characters")
                return false
            }
        }
        if newpassword == ""{
            self.view.makeToast("Input password")
            return false
        }else{
            if newpassword.count < 6{
                self.view.makeToast("Input password more than 6 characters")
                return false
            }
        }
        return true
    }
}
