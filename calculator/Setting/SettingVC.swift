//
//  SettingVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit

class SettingVC: UIViewController {
    var userVC : UserVC!
    var homeVC : HomeVC!
    var calendarVC :CalendarVC!
    
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
    
    @IBAction func onHomeBtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.homeVC.modalPresentationStyle = .fullScreen
        self.present(self.homeVC, animated: true, completion: nil)
    }
}
