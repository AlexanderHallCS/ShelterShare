//
//  NearbySheltersTableViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit
import CoreLocation
import FirebaseCore
import FirebaseFirestore

class ShelterNearMeCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var capacityLabel: UILabel!
    
    var id = ""
}

class NearbySheltersTableViewController: UITableViewController, CLLocationManagerDelegate {

    let manager = CLLocationManager()
    
    var didGetLocation = false
    var currLocation = CLLocationCoordinate2D()
    
    var shelterNames: [String] = []
    var shelterDistances: [String] = []
    var shelterCapacities: [String] = []
    var ids: [String] = []
    
    var selectedId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!didGetLocation) {
            currLocation = manager.location!.coordinate
            didGetLocation = true
            fetchShelterData()
            print("Current Location: \(currLocation)")
        }
    }
    
    private func fetchShelterData() {
        Firestore.firestore().collection("users").getDocuments(completion: { (snapshot, error) in
            snapshot?.documents.forEach({ (document) in
                let data = document.data()
                if((data["userType"] as! String) == "shelterProvider") {
                    let distanceBetweenYouAndShelter = CLLocation(latitude: self.currLocation.latitude, longitude: self.currLocation.longitude).distance(from: CLLocation(latitude: data["latitude"] as! Double, longitude: data["longitude"] as! Double))
                    print("Distance: \(distanceBetweenYouAndShelter.magnitude)")
                    // if distance to shelter is less than 40 miles
                    if(distanceBetweenYouAndShelter/1609.344 < 40) {
                        self.shelterNames.append("Shelter Name: \(data["shelterName"] as! String)")
                        self.shelterCapacities.append("Capacity: (\(data["currCapacity"] as! NSNumber)/\(data["maxCapacity"] as! NSNumber))")
                        self.shelterDistances.append("Distance: \(String(format: "%.2f", distanceBetweenYouAndShelter.magnitude/1609.344)) miles")
                        self.ids.append(data["id"] as! String)
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
        return shelterNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shelterNearMeCell", for: indexPath) as! ShelterNearMeCell

        cell.nameLabel.text = shelterNames[indexPath.row]
        cell.distanceLabel.text = shelterDistances[indexPath.row]
        cell.capacityLabel.text = shelterCapacities[indexPath.row]
        cell.id = ids[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedId = ids[indexPath.row]
        performSegue(withIdentifier: "sheltersNearMeToInfo", sender: self)
    }
    
    @IBAction func unwindToNearbyShelters(segue: UIStoryboardSegue) {}

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destVC = segue.destination as? ShelterInfoViewController {
            destVC.shelterId = selectedId
        }
    }

}
