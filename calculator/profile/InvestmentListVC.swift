//
//  InvestmentListVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit

class InvestmentListVC: UIViewController {

    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        // Do any additional setup after loading the view.
    }
    
    func setShadow(){
        self.topView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.topView.layer.shadowRadius = 5
        self.topView.layer.shadowOpacity = 0.3
    }

}
