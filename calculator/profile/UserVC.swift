//
//  UserVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
class UserVC: UIViewController {
    var calendarVC : CalendarVC!
    var homeVC : HomeVC!
    var settingVC : SettingVC!
    var savinglistVC : SavingListVC!
    var investmentlistVC : InvestmentListVC!
    var mortgageVC : MortgageVC!
    var setamountVC : SetAmountVC!
    
    @IBOutlet weak var bottomView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        // Do any additional setup after loading the view.
    }
    func setShadow(){
        self.bottomView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.bottomView.layer.shadowRadius = 5
        self.bottomView.layer.shadowOpacity = 0.3
    }
    
    @IBAction func onSavingBtn(_ sender: Any) {
        self.savinglistVC = self.storyboard?.instantiateViewController(withIdentifier: "savinglistVC") as? SavingListVC
        self.savinglistVC.modalPresentationStyle = .fullScreen
        self.present(self.savinglistVC, animated: true, completion: nil)
    }
    
    @IBAction func onInvestmentBtn(_ sender: Any) {
        self.investmentlistVC = self.storyboard?.instantiateViewController(withIdentifier: "investmentlistVC") as? InvestmentListVC
        self.investmentlistVC.modalPresentationStyle = .fullScreen
        self.present(self.investmentlistVC, animated: true, completion: nil)
    }
    
    @IBAction func onMortgageBtn(_ sender: Any) {
        self.mortgageVC = self.storyboard?.instantiateViewController(withIdentifier: "mortgageVC") as? MortgageVC
        self.mortgageVC.modalPresentationStyle = .fullScreen
        self.present(self.mortgageVC, animated: true, completion: nil)
    }
    
    @IBAction func onAmountBtn(_ sender: Any) {
        self.setamountVC = self.storyboard?.instantiateViewController(withIdentifier: "setamountVC") as? SetAmountVC
        self.setamountVC.modalPresentationStyle = .fullScreen
        self.present(self.setamountVC, animated: true, completion: nil)
    }
    
    @IBAction func onCalendarBtn(_ sender: Any) {
        self.calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "calendarVC") as? CalendarVC
        self.calendarVC.modalPresentationStyle = .fullScreen
        self.present(self.calendarVC, animated: true, completion: nil)
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
}
