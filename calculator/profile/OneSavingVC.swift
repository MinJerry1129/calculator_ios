//
//  OneSavingVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
import MBCircularProgressBar
class OneSavingVC: UIViewController {
    @IBOutlet weak var moneyPBV: MBCircularProgressBarView!
    @IBOutlet weak var dayPBV: MBCircularProgressBarView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var passdayTxt: UILabel!
    @IBOutlet weak var totaldayTxt: UILabel!
    @IBOutlet weak var targetTxt: UILabel!
    @IBOutlet weak var savingTxt: UILabel!
    var user_id = ""
    var sel_saving = 0
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        sel_saving = AppDelegate.shared().sel_saving
        setShadow()
        getData()
    }
    func setShadow(){
        self.topView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.topView.layer.shadowRadius = 5
        self.topView.layer.shadowOpacity = 0.3
    }
    func getData(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id , "savingid": "\(sel_saving)"]
        AF.request(Global.baseUrl + "api/getSavingInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
//                let status = value["status"] as? String
//                if status == "ok"{
//                    self.dismiss(animated: true, completion: nil)
//                }else {
//                    self.view.makeToast("Fail delete")
//                }
            }else {
                self.view.makeToast("Fail loading")
            }
        }
    }

    @IBAction func onDeleteBtn(_ sender: Any) {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id , "savingid": "\(sel_saving)"]
        AF.request(Global.baseUrl + "api/deletesavinginfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                let status = value["status"] as? String
                if status == "ok"{
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.view.makeToast("Fail delete")
                }
            }else {
                self.view.makeToast("Fail add")
            }
        }
    }
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func onCheckBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
