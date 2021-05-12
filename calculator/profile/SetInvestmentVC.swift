//
//  SetInvestmentVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import iOSDropDown
class SetInvestmentVC: UIViewController {

    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var categoryDV: DropDown!
    let allInvestCategory = Global.allInvestmentCategory
    var spinnerView = JTMaterialSpinner()
    @IBOutlet weak var priceTxt: UITextField!
    var user_id = ""
    var price = ""
    var sel_category = 100
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        setShadow()
        setCategory()
    }
    func setShadow(){
        self.priceView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.priceView.layer.shadowRadius = 5
        self.priceView.layer.shadowOpacity = 0.3
        
        self.categoryView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.categoryView.layer.shadowRadius = 5
        self.categoryView.layer.shadowOpacity = 0.3
    }
    

    @IBAction func onCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onSetBtn(_ sender: Any) {
        price = priceTxt.text!
        if(!isValid()){
            return
        }
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id , "value": price, "type": sel_category]
        AF.request(Global.baseUrl + "api/setinvestment", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    self.view.makeToast("Add Investment Success")
                }else {
                    self.view.makeToast("Fail add")
                }
            }else {
                self.view.makeToast("Fail add")
            }
        }
        
    }
    func setCategory(){
        categoryDV.optionArray = allInvestCategory
        categoryDV.didSelect{(selectedText , index ,id) in
            self.sel_category = index
            print("\(index)")
        }
    }
    func isValid() -> Bool {
        if price == ""{
            self.view.makeToast("Input Price")
            return false
        }
        if sel_category == 100{
            self.view.makeToast("Select Category")
            return false
        }
        return true
    }
}
