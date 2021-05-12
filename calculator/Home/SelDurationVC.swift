//
//  SelDurationVC.swift
//  calculator
//
//  Created by bird on 5/11/21.
//

import UIKit

class SelDurationVC: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var durationTB: UITableView!
    var allDuration = Global.allDurationCategory
    override func viewDidLoad() {
        super.viewDidLoad()
        durationTB.delegate = self
        durationTB.dataSource = self
        durationTB.register(UINib(nibName: "DurationCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        setShadow()
    }
    func setShadow(){
        self.topView.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.topView.layer.shadowRadius = 5
        self.topView.layer.shadowOpacity = 0.3
    }
    
    @IBAction func onBackBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SelDurationVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allDuration.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DurationCell
        cell.titleTxt.text = allDuration[indexPath.row]        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppDelegate.shared().duration = indexPath.row
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
