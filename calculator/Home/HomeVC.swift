//
//  HomeVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Charts
import Alamofire
import JTMaterialSpinner

class HomeVC: UIViewController {
    var seldurationVC : SelDurationVC!
    var setincomeVC : SetIncomeVC!
    var setlibilityVC : SetLiabilityVC!
    var userVC : UserVC!
    var calendarVC : CalendarVC!
    var settingVC : SettingVC!
    
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var incomeTB: UITableView!
    @IBOutlet weak var liabilityTB: UITableView!
    
    @IBOutlet weak var incomeTxt: UILabel!
    @IBOutlet weak var liabilityTxt: UILabel!
    @IBOutlet weak var remainTxt: UILabel!
    
    @IBOutlet weak var incomeTBHeight: NSLayoutConstraint!
    @IBOutlet weak var liabilityTBHeight: NSLayoutConstraint!
    
    var spinnerView = JTMaterialSpinner()
    
    let allIncomeCategory = Global.allIncomeCategory
    let allLiabilityCategory = Global.allLiabilityCategory
    let parties = ["Remain", "Liability"]
    var prices = [0.0, 0.0]
    var sel_type = 8
    var user_id = ""
    var allIncome = [Income]()
    var allLiability = [Liability]()

    var income_price = 1
    var liability_price = 8
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "userID") ?? "1"
        
        incomeTB.delegate = self
        incomeTB.dataSource = self
        incomeTB.register(UINib(nibName: "IncomeCell", bundle: nil), forCellReuseIdentifier: "cell")
        incomeTB.isUserInteractionEnabled = false
        
        liabilityTB.delegate = self
        liabilityTB.dataSource = self
        liabilityTB.register(UINib(nibName: "LiabilityCell", bundle: nil), forCellReuseIdentifier: "cell")
        liabilityTB.isUserInteractionEnabled = false
        setShadow()
        setDataCount()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd")
        let dateString = formatter.string(from: Date())
        dateTxt.text = dateString
        
        sel_type = AppDelegate.shared().duration
        getData();
    }
    func getData(){
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["id": user_id,"type": sel_type]
        AF.request(Global.baseUrl + "api/gethomedata", method: .post, parameters: parameters, encoding:JSONEncoding.default).responseJSON{ response in
            print(response)
            self.spinnerView.endRefreshing()
            if let value = response.value as? [String: AnyObject] {
                self.allIncome = []
                self.allLiability = []
                self.income_price = 0
                self.liability_price = 0
                
                let payInfos = value["payinfo"] as? [[String: AnyObject]]
                if payInfos!.count > 0{
                    for i in 0 ... (payInfos!.count)-1 {
                        let id = payInfos![i]["id"] as! String
                        let categoryid = payInfos![i]["categoryid"] as! String
                        let price = payInfos![i]["price"] as! String
                        let paydate = payInfos![i]["date"] as! String
                        let paytype = payInfos![i]["paytype"] as! String
                        if paytype == "income"{
                            self.income_price = self.income_price + Int(price)!
                            let incomeCell = Income(id: id, categoryid: Int(categoryid)!, price: price, paydate: paydate, paytype: paytype)
                            self.allIncome.append(incomeCell)
                        }else{
                            self.liability_price = self.liability_price + Int(price)!
                            let liabilityCell = Liability(id: id, categoryid: Int(categoryid)!, price: price, paydate: paydate, paytype: paytype)
                            self.allLiability.append(liabilityCell)
                        }
                    }
                }
                self.incomeTxt.text = String(self.income_price) + "$"
                self.liabilityTxt.text = String(self.liability_price) + "$"
                self.remainTxt.text = String(self.income_price - self.liability_price) + "$"
                self.setDataCount()
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
    
    func setShadow(){
        self.bottomView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.bottomView.layer.shadowRadius = 5
        self.bottomView.layer.shadowOpacity = 0.3
    }
    func setDataCount() {
        let total_price = Double(income_price)
        var remain_price = income_price - liability_price
        if remain_price < 0 {
            remain_price = 0
        }
        if total_price == 0 {
            prices[0] = 1.0
            prices[1] = 0.0
        }else{
            prices[0] = Double(remain_price) * 100.0 / total_price
            prices[1] = Double(liability_price) * 100.0 / total_price
        }
        
        let entries = (0..<2).map { (i) -> PieChartDataEntry in
            return PieChartDataEntry(value: prices[i],
                                     label: parties[i],
                                     icon: nil)
        }
        
        let set = PieChartDataSet(entries: entries)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [UIColor(red: 2/255, green: 195/255, blue: 154/255, alpha: 1)]
            + [UIColor(red: 5/255, green: 102/255, blue: 141/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    @IBAction func onSummaryBtn(_ sender: Any) {
        self.seldurationVC = self.storyboard?.instantiateViewController(withIdentifier: "seldurationVC") as? SelDurationVC
        self.seldurationVC.modalPresentationStyle = .fullScreen
        self.present(self.seldurationVC, animated: true, completion: nil)
    }
    @IBAction func onSetIncomeBtn(_ sender: Any) {
        self.setincomeVC = self.storyboard?.instantiateViewController(withIdentifier: "setincomeVC") as? SetIncomeVC
        self.setincomeVC.modalPresentationStyle = .fullScreen
        self.present(self.setincomeVC, animated: true, completion: nil)
    }
    @IBAction func onSetLiabilityBtn(_ sender: Any) {
        self.setlibilityVC = self.storyboard?.instantiateViewController(withIdentifier: "setlibilityVC") as? SetLiabilityVC
        self.setlibilityVC.modalPresentationStyle = .fullScreen
        self.present(self.setlibilityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func onUserBtn(_ sender: Any) {
        self.userVC = self.storyboard?.instantiateViewController(withIdentifier: "userVC") as? UserVC
        self.userVC.modalPresentationStyle = .fullScreen
        self.present(self.userVC, animated: true, completion: nil)
    }
    
    @IBAction func onCalendarBtn(_ sender: Any) {
        self.calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "calendarVC") as? CalendarVC
        self.calendarVC.modalPresentationStyle = .fullScreen
        self.present(self.calendarVC, animated: true, completion: nil)
    }
    @IBAction func onSettingBtn(_ sender: Any) {
        self.settingVC = self.storyboard?.instantiateViewController(withIdentifier: "settingVC") as? SettingVC
        self.settingVC.modalPresentationStyle = .fullScreen
        self.present(self.settingVC, animated: true, completion: nil)
        
    }
}
extension HomeVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1000{
            return allIncome.count
        }else{
            return allLiability.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1000{
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
