//
//  SetLiabilityVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
import iOSDropDown
class SetLiabilityVC: UIViewController {
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var noteTxt: UITextField!
    @IBOutlet weak var repeatDV: DropDown!
    @IBOutlet weak var liabilityDV: DropDown!
    @IBOutlet weak var priceTxt: UITextField!
    
    var spinnerView = JTMaterialSpinner()
    var price = ""
    var note = ""
    var allLiabilityString = [String]()
    var allRepeatCategory = Global.allRepeatCategory
    var allLiabilityCategory = Global.allLiabilityCategory
    var sel_liability = 100
    var sel_repeat = 100
    var user_id = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        setDropdownData()
    }
    func setShadow(){
        self.repeatView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.repeatView.layer.shadowRadius = 5
        self.repeatView.layer.shadowOpacity = 0.3
        self.noteView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.noteView.layer.shadowRadius = 5
        self.noteView.layer.shadowOpacity = 0.3
        self.categoryView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.categoryView.layer.shadowRadius = 5
        self.categoryView.layer.shadowOpacity = 0.3
        self.priceView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.priceView.layer.shadowRadius = 5
        self.priceView.layer.shadowOpacity = 0.3
    }
    @IBAction func onCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSetBtn(_ sender: Any) {
        price = priceTxt.text!
        note = noteTxt.text!
        if(!isValid()){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id , "value": price, "categoryid": sel_liability, "repeatid": sel_repeat, "note" : note]
        AF.request(Global.baseUrl + "api/addliability", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    self.view.makeToast("Add liability Success")
                }else {
                    self.view.makeToast("Fail add")
                }
            }else {
                self.view.makeToast("Fail add")
            }
        }
        
    }
    func setDropdownData(){
        for i in 0 ... (allLiabilityCategory.count)-1 {
            let name = allLiabilityCategory[i].title
            self.allLiabilityString.append(name)
        }
        setCategory()
    }
    func setCategory(){
        liabilityDV.optionArray = allLiabilityString
        liabilityDV.didSelect{(selectedText , index ,id) in
            self.sel_liability = index
            print("\(index)")
        }
        repeatDV.optionArray = allRepeatCategory
        repeatDV.didSelect{(selectedText , index ,id) in
            self.sel_repeat = index
            print("\(index)")
        }
    }
    func isValid() -> Bool {
        if price == ""{
            self.view.makeToast("Input Price")
            return false
        }
        if sel_liability == 100{
            self.view.makeToast("Select Category")
            return false
        }
        if sel_repeat == 100{
            self.view.makeToast("Select Repeat")
            return false
        }
        return true
    }
    
}
