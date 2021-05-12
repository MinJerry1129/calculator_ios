//
//  SetAmountVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import iOSDropDown
import JTMaterialSpinner
class SetAmountVC: UIViewController {
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var durationDV: DropDown!
    @IBOutlet weak var nameTxt: UITextField!
    var allDurationCategory = Global.allDurationCategory
    var spinnerView = JTMaterialSpinner()
    var price = ""
    var note = ""
    var sel_duration = 100
    var user_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        setShadow()
        setCategory()
        // Do any additional setup after loading the view.
    }
    func setShadow(){
        self.titleView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.titleView.layer.shadowRadius = 5
        self.titleView.layer.shadowOpacity = 0.3
        self.priceView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.priceView.layer.shadowRadius = 5
        self.priceView.layer.shadowOpacity = 0.3
        self.repeatView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.repeatView.layer.shadowRadius = 5
        self.repeatView.layer.shadowOpacity = 0.3
    }

    @IBAction func onCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSetBtn(_ sender: Any) {
        price = priceTxt.text!
        note = nameTxt.text!
        if(!isValid()){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id , "name": note, "value": price, "type": sel_duration]
        AF.request(Global.baseUrl + "api/setgoal", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    self.view.makeToast("Set a goal Success!")
                }else {
                    self.view.makeToast("Fail set")
                }
            }else {
                self.view.makeToast("Fail set")
            }
        }
        
    }
    
    func setCategory(){
        durationDV.optionArray = allDurationCategory
        durationDV.didSelect{(selectedText , index ,id) in
            self.sel_duration = index
            print("\(index)")
        }
    }
    func isValid() -> Bool {
        if price == ""{
            self.view.makeToast("Input Price")
            return false
        }
        if note == ""{
            self.view.makeToast("Input Name")
            return false
        }
        if sel_duration == 100{
            self.view.makeToast("Select Duration")
            return false
        }
        return true
    }
}
