//
//  CalendarVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Alamofire
import JTMaterialSpinner
import FSCalendar
class CalendarVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    var userVC : UserVC!
    var homeVC : HomeVC!
    var settingVC : SettingVC!
    var user_id = ""
    @IBOutlet weak var liabilityTBHeight: NSLayoutConstraint!
    @IBOutlet weak var incomeTBHeight: NSLayoutConstraint!
    @IBOutlet weak var incomeTB: UITableView!
    @IBOutlet weak var liabilityTB: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var calendarView: FSCalendar!
    var currentdate = ""
    
    var spinnerView = JTMaterialSpinner()
    
    let allIncomeCategory = Global.allIncomeCategory
    let allLiabilityCategory = Global.allLiabilityCategory
    var allIncome = [Income]()
    var allLiability = [Liability]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        calendarView.delegate = self
        calendarView.dataSource = self
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        currentdate = dateFormatterGet.string(from: Date())
        incomeTB.delegate = self
        incomeTB.dataSource = self
        incomeTB.register(UINib(nibName: "IncomeCell", bundle: nil), forCellReuseIdentifier: "cell")
        incomeTB.isUserInteractionEnabled = false
        
        liabilityTB.delegate = self
        liabilityTB.dataSource = self
        liabilityTB.register(UINib(nibName: "LiabilityCell", bundle: nil), forCellReuseIdentifier: "cell")
        liabilityTB.isUserInteractionEnabled = false
        setShadow()
        getData()
    }
    func setShadow(){
        self.bottomView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.bottomView.layer.shadowRadius = 5
        self.bottomView.layer.shadowOpacity = 0.3
    }
    
    func getData(){
        print(currentdate)
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id,"date": currentdate]
        AF.request(Global.baseUrl + "api/getCaldata", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.allIncome = []
                self.allLiability = []
                
                let payInfos = value["payinfo"] as? [[String: AnyObject]]
                if payInfos!.count > 0{
                    for i in 0 ... (payInfos!.count)-1 {
                        let id = payInfos![i]["id"] as! String
                        let categoryid = payInfos![i]["categoryid"] as! String
                        let price = payInfos![i]["price"] as! String
                        let paydate = payInfos![i]["date"] as! String
                        let paytype = payInfos![i]["paytype"] as! String
                        if paytype == "income"{
                            let incomeCell = Income(id: id, categoryid: Int(categoryid)!, price: price, paydate: paydate, paytype: paytype)
                            self.allIncome.append(incomeCell)
                        }else{
                            let liabilityCell = Liability(id: id, categoryid: Int(categoryid)!, price: price, paydate: paydate, paytype: paytype)
                            self.allLiability.append(liabilityCell)
                        }
                    }
                }
                self.incomeTBHeight.constant = CGFloat(30 * self.allIncome.count)
                self.liabilityTBHeight.constant = CGFloat(30 * self.allLiability.count)
                self.incomeTB.layoutIfNeeded()
                self.liabilityTB.layoutIfNeeded()
                self.incomeTB.updateConstraints()
                self.liabilityTB.updateConstraints()
                self.incomeTB.reloadData()
                self.liabilityTB.reloadData()
            }
        }
    }

    @IBAction func onUserBtn(_ sender: Any) {
        self.userVC = self.storyboard?.instantiateViewController(withIdentifier: "userVC") as? UserVC
        self.userVC.modalPresentationStyle = .fullScreen
        self.present(self.userVC, animated: true, completion: nil)
    }
    
    @IBAction func onHomeBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
    }
    @IBAction func onSettingBtn(_ sender: Any) {
        self.settingVC = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as? SettingVC
        self.settingVC.modalPresentationStyle = .fullScreen
        self.present(self.settingVC, animated: true, completion: nil)
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        currentdate = dateFormatterGet.string(from: date)
        self.getData()
    }
}
extension CalendarVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 200{
            return allIncome.count
        }else{
            return allLiability.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 200{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IncomeCell
            let oneIncome = allIncome[indexPath.row]
            let income_title = allIncomeCategory[oneIncome.categoryid].title
            let income_image = allIncomeCategory[oneIncome.categoryid].imageUrl
            cell.priceImg.image = UIImage(named: income_image)
            cell.priceTitle.text = income_title
            cell.priceValue.text = oneIncome.price
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LiabilityCell
            let oneLiability = allLiability[indexPath.row]
            let liability_title = allLiabilityCategory[oneLiability.categoryid].title
            let income_image = allLiabilityCategory[oneLiability.categoryid].imageUrl
            cell.priceImg.image = UIImage(named: income_image)
            cell.priceTitle.text = liability_title
            cell.priceValue.text = oneLiability.price
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
}
