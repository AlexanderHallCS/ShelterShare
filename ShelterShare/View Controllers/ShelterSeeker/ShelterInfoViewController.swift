//
//  ShelterInfoViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit

class ShelterInfoViewController: UIViewController {

    @IBOutlet var joinButton: UIButton!
    
    @IBOutlet var shelterNameLabel: UILabel!
    @IBOutlet var shelterTypeLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var hostNameLabel: UILabel!
    
    @IBOutlet var locationViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func pressJoin(_ sender: UIButton) {
        joinButton.setImage(UIImage(named: "JoinedButton"), for: .normal)
    }
    
}
