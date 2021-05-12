//
//  TermVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit

class TermVC: UIViewController {
    var homeVC : HomeVC!
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
    @IBAction func onContinueBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
}
