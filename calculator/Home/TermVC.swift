//
//  TermVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit

class TermVC: UIViewController {

    @IBOutlet weak var termView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
    }
    func setShadow(){
        self.termView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.termView.layer.shadowRadius = 5
        self.termView.layer.shadowOpacity = 0.3
    }

}
