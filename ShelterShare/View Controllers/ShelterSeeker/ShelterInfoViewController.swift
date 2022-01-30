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
                    }
                }
            })
        })
    }

    @IBAction func pressJoin(_ sender: UIButton) {
        let db = Firestore.firestore()
        // add one to current capacity of shelter identified by shelterId
        db.collection("users").document(shelterId).updateData([
            "currCapacity" : FieldValue.increment(Int64(1))
        ])
        // set this user's current shelter to be shelterId
        db.collection("users").document(GlobalUserData.userID).updateData([
            "shelter" : shelterId
        ])
        
        // make button green
        joinButton.setImage(UIImage(named: "JoinedButton"), for: .normal)
        createAlert(message: "You have joined the shelter!")
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {(action: UIAlertAction) -> Void in
            alert.removeFromParent()
        })
        present(alert, animated: true, completion: nil)
    }
    
}
