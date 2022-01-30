//
//  ShelterMembersTableViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/30/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class MemberCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
}

class ShelterMembersTableViewController: UITableViewController {

    var memberNames: [String] = []
    var memberPhones: [String] = []
    var memberEmails: [String] = []
    
    var shelterId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("users").getDocuments(completion: { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let data = document.data()
                if((data["userType"] as! String) == "shelterSeeker") {
                    if((data["shelter"] as! String) == self.shelterId) {
                        self.memberNames.append("Name: \(data["name"] as! String)")
                        self.memberPhones.append("Phone: \(data["phone"] as! String)")
                        self.memberEmails.append("Email: \(data["email"] as! String)")
                    }
                }
            })
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberCell

        cell.nameLabel.text = memberNames[indexPath.row]
        cell.phoneLabel.text = memberPhones[indexPath.row]
        cell.emailLabel.text = memberEmails[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107.0
    }

}
