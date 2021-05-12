//
//  InvestmentListVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
class InvestmentListVC: UIViewController {
    var setinvestmentVC : SetInvestmentVC!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var listTB: UITableView!
    var user_id  = "0"
    var spinnerView = JTMaterialSpinner()
    var allInvest = [Investment]()
    var allInvestCategory = Global.allInvestmentCategory
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        listTB.delegate = self
        listTB.dataSource = self
        listTB.register(UINib(nibName: "InvestmentCell", bundle: nil), forCellReuseIdentifier: "cell")
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
        AF.request(Global.baseUrl + "api/getInvestInfo", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.allInvest = []
                let investInfos = value["investInfo"] as? [[String: AnyObject]]
                if investInfos!.count > 0{
                    for i in 0 ... (investInfos!.count)-1 {
                        let id = investInfos![i]["id"] as! String
                        let type = investInfos![i]["type"] as! String
                        let paydate = investInfos![i]["date"] as! String
                        let price = investInfos![i]["price"] as! String
                        let investCell = Investment(id: Int(id)!, price: price, type: Int(type)!, paydate: paydate)
                        self.allInvest.append(investCell)
                    }
                }
                self.listTB.reloadData()
            }
        }
        
    }

    @IBAction func onAddBtn(_ sender: Any) {
        self.setinvestmentVC = self.storyboard?.instantiateViewController(withIdentifier: "setinvestmentVC") as? SetInvestmentVC
        self.setinvestmentVC.modalPresentationStyle = .fullScreen
        self.present(self.setinvestmentVC, animated: true, completion: nil)
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension InvestmentListVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allInvest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InvestmentCell
        let oneInvest = allInvest[indexPath.row]
        let investtitle = allInvestCategory[oneInvest.type]
        cell.titleTxt.text = investtitle
        cell.priceTxt.text = oneInvest.price
        cell.dateTxt.text = oneInvest.paydate
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
