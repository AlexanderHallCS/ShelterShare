//
//  YourSheltersTableViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class ShelterTableViewCell: UITableViewCell {
    @IBOutlet var shelterNameLabel: UILabel!
    @IBOutlet var shelterTypeLabel: UILabel!
    @IBOutlet var shelterPhoneLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
}

class YourSheltersTableViewController: UITableViewController {

    var shelterNames: [String] = []
    var shelterTypes: [String] = []
    var shelterPhones: [String] = []
    var shelterEmails: [String] = []
    var shelterCapacities: [String] = []
    var shelterLocations: [String] = []
    
    var ids: [String] = []
    
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("users").getDocuments(completion: { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let data = document.data()
                if((data["userType"] as! String) == "shelterProvider") {
                    self.shelterNames.append("Shelter Name: \(data["shelterName"] as! String)")
                    self.shelterTypes.append("Shelter Type: \(data["shelterType"] as! String)")
                    self.shelterPhones.append("Phone: \(data["phone"] as! String)")
                    self.shelterEmails.append("Email: \(data["email"] as! String)")
                    self.shelterLocations.append("Location: (\(String(format: "%.2f", data["latitude"] as! Double)),\(String(format: "%.2f", data["longitude"] as! Double)))")
                    self.shelterCapacities.append("Capacity: (\(data["currCapacity"] as! NSNumber)/\(data["maxCapacity"] as! NSNumber))")
                    self.ids.append(data["id"] as! String)
                    print("DATA: \(data)")
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
        return shelterNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelterCell", for: indexPath) as! ShelterTableViewCell

        cell.shelterNameLabel.text = shelterNames[indexPath.row]
        cell.shelterTypeLabel.text = shelterTypes[indexPath.row]
        cell.shelterPhoneLabel.text = shelterPhones[indexPath.row]
        cell.emailLabel.text = shelterEmails[indexPath.row]
        cell.locationLabel.text = shelterLocations[indexPath.row]
        cell.capacityLabel.text = shelterCapacities[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = ids[indexPath.row]
        performSegue(withIdentifier: "mySheltersToShelterMembers", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? ShelterMembersTableViewController {
            destVC.shelterId = selectedId
        }
    }
    
    @IBAction func unwindToYourSheltersVC(segue: UIStoryboardSegue) {}

}
