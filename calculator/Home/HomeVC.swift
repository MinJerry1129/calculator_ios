//
//  HomeVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import Charts
class HomeVC: UIViewController {
    let parties = ["Income", "Liability"]
    var prices = [0.0, 0.0]
    @IBOutlet weak var chartView: PieChartView!
    @IBOutlet weak var bottomView: UIView!
    var income_price = 1.0
    var liability_price = 8.0
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        setDataCount()
        // Do any additional setup after loading the view.
    }
    
    func setShadow(){
        self.bottomView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.bottomView.layer.shadowRadius = 5
        self.bottomView.layer.shadowOpacity = 0.3
    }
    func setDataCount() {
        let total_price = income_price + liability_price
        if total_price == 0 {
            prices[0] = 1.0
            prices[1] = 1.0
        }else{
            prices[0] = income_price * 100.0 / total_price
            prices[1] = liability_price * 100.0 / total_price
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

}
