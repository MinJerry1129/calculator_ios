//
//  SavingListVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import Toast_Swift
class SavingListVC: UIViewController {
    var onesavingVC : OneSavingVC!
    @IBOutlet weak var topView: UIView!    
    @IBOutlet weak var listTB: UITableView!
    var spinnerView = JTMaterialSpinner()
    var allSaving = [Saving]()
    var user_id = "1"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        listTB.delegate = self
        listTB.dataSource = self
        listTB.register(UINib(nibName: "SavingCell", bundle: nil), forCellReuseIdentifier: "cell")
        listTB.isUserInteractionEnabled = false
        setShadow()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
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
        let parameters: Parameters = ["id": user_id]
        AF.request(Global.baseUrl + "api/getSavingsInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.allSaving = []
                let savingInfos = value["savingInfo"] as? [[String: AnyObject]]
                if savingInfos!.count > 0{
                    for i in 0 ... (savingInfos!.count)-1 {
                        let id = savingInfos![i]["id"] as! String
                        let name = savingInfos![i]["name"] as! String
                        let startdate = savingInfos![i]["startdate"] as! String
                        let enddate = savingInfos![i]["enddate"] as! String
                        let type = savingInfos![i]["type"] as! String
                        let price = savingInfos![i]["price"] as! String
                        
                        let savingCell = Saving(id: Int(id)!, title: name, startdate: startdate, enddate: enddate, type: Int(type)!, price: price)
                        self.allSaving.append(savingCell)
                    }
                }
                self.listTB.isUserInteractionEnabled = true
                self.listTB.reloadData()
            }
        }
        
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension SavingListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSaving.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavingCell
        let oneSaving = allSaving[indexPath.row]
        cell.titleTxt.text = oneSaving.title
        cell.priceTxt.text = oneSaving.price
        cell.startDateTxt.text = oneSaving.startdate
        cell.endDateTxt.text = oneSaving.enddate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared().sel_saving = allSaving[indexPath.row].id
        self.onesavingVC = self.storyboard?.instantiateViewController(withIdentifier: "onesavingVC") as? OneSavingVC
        self.onesavingVC.modalPresentationStyle = .fullScreen
        self.present(self.onesavingVC, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
