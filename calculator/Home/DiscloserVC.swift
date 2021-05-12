//
//  DiscloserVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit
import SimpleCheckbox
class DiscloserVC: UIViewController {
    @IBOutlet weak var termCheck: Checkbox!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var discloserView: UIView!
    var termVC : TermVC!
    override func viewDidLoad() {
        super.viewDidLoad()
        setShadow()
        termCheck.addTarget(self, action: #selector(checkboxValueChanged(sender:)), for: .valueChanged)
        
    }
    func setShadow(){
        self.discloserView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.discloserView.layer.shadowRadius = 5
        self.discloserView.layer.shadowOpacity = 0.3
    }
    @objc func checkboxValueChanged(sender: Checkbox) {
        if sender.isChecked {
            confirmBtn.isEnabled = true
        }else{
            confirmBtn.isEnabled = false
        }
    }
    @IBAction func onConfirmBtn(_ sender: Any) {
        self.termVC = self.storyboard?.instantiateViewController(withIdentifier: "termVC") as? TermVC
        self.termVC.modalPresentationStyle = .fullScreen
        self.present(self.termVC, animated: true, completion: nil)
    }
}
