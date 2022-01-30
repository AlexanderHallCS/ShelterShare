//
//  ShelterInfoViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class ShelterInfoViewController: UIViewController {

    @IBOutlet var joinButton: UIButton!
    
    @IBOutlet var shelterNameLabel: UILabel!
    @IBOutlet var shelterTypeLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var hostNameLabel: UILabel!
    
    @IBOutlet var locationViewButton: UIButton!
    
    var shelterId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("users").getDocuments(completion: { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let data = document.data()
                if((data["userType"] as! String) == "shelterProvider") {
                    if((data["id"] as! String) == self.shelterId) {
                        self.shelterNameLabel.text = "\(data["shelterName"] as! String)"
                        self.shelterTypeLabel.text = "\(data["shelterType"] as! String)"
                        self.phoneLabel.text = "\(data["phone"] as! String)"
                        self.emailLabel.text = "\(data["email"] as! String)"
                        self.hostNameLabel.text = "\(data["organizerName"] as! String)"
                        print("DATA: \(data)")
                    }
                }
            })
        })
    }

    @IBAction func pressJoin(_ sender: UIButton) {
        joinButton.setImage(UIImage(named: "JoinedButton"), for: .normal)
    }
    
}
