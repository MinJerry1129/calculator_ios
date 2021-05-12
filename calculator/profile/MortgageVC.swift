//
//  MortgageVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit

class MortgageVC: UIViewController {

    @IBOutlet weak var loanView: UIView!
    @IBOutlet weak var RateView: UIView!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var amountTxt: UITextField!
    @IBOutlet weak var rateTxt: UITextField!
    @IBOutlet weak var periodTxt: UITextField!
    
    @IBOutlet weak var monthlyTxt: UILabel!
    @IBOutlet weak var totalTxt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
    }
    func setShadow(){
        self.topView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.topView.layer.shadowRadius = 5
        self.topView.layer.shadowOpacity = 0.3
        
        self.loanView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.loanView.layer.shadowRadius = 5
        self.loanView.layer.shadowOpacity = 0.3
        self.RateView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.RateView.layer.shadowRadius = 5
        self.RateView.layer.shadowOpacity = 0.3
        self.amountView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.amountView.layer.shadowRadius = 5
        self.amountView.layer.shadowOpacity = 0.3
    }
    @IBAction func amountChange(_ sender: Any) {
        cal_Mortgage()
    }
    @IBAction func rateChange(_ sender: Any) {
        cal_Mortgage()
    }
   
    @IBAction func periodChange(_ sender: Any) {
        cal_Mortgage()
    }
    func cal_Mortgage(){
        if amountTxt.text! == ""{
            totalTxt.text = "0"
            monthlyTxt.text = "0"
            return
        }
        if periodTxt.text! == ""{
            totalTxt.text = "0"
            monthlyTxt.text = "0"
            return
        }
        if rateTxt.text! == ""{
            totalTxt.text = "0"
            monthlyTxt.text = "0"
            return
        }
        let amount = Double(amountTxt.text!) ?? 0.0
        let rate = Double(rateTxt.text!) ?? 0.0
        let period = Double(periodTxt.text!) ?? 0.0
        let interst_rate = rate / 1200.0
        let total_month = period * 12.0
        let value_c = pow(interst_rate + 1, total_month)
        let value_monthly = amount * (interst_rate * value_c)/(value_c - 1)
        let month_price = Double(round(10 * value_monthly)/10)
        let total_price = Double(round(10 * value_monthly*total_month)/10)
        totalTxt.text = "\(total_price)"
        monthlyTxt.text = "\(month_price)"
        
        
        
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
