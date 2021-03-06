//
//  CreateShelterViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit
import CoreLocation
import FirebaseCore
import FirebaseFirestore

class CreateShelterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet var shelterNameTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var yourNameTF: UITextField!
    @IBOutlet var capacityTF: UITextField!
    
    @IBOutlet var shelterTypePickerView: UIPickerView!
    
    var manager = CLLocationManager()
    
    var didGetLocation = false
    var currLocation = CLLocationCoordinate2D()
    
    // picker model
    var pickerChoices = ["House", "Store", "Church", "Building", "Alternate"]
    
    var shelterType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        shelterNameTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
        yourNameTF.delegate = self
        capacityTF.delegate = self
        
        shelterTypePickerView.delegate = self
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
            print("Current Location: \(currLocation)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func askForCurrentLocation(_ sender: UIButton) {
        manager.requestAlwaysAuthorization()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerChoices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerChoices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shelterType = pickerChoices[row] as String
    }
    
    @IBAction func segueFromCreateShelterToYourShelters(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("users").document(GlobalUserData.userID).setData([
            "shelterName" : shelterNameTF.text!,
            "shelterType" : shelterType,
            "phone" : phoneTF.text!,
            "email" : emailTF.text!,
            "organizerName" : yourNameTF.text!,
            "maxCapacity" : Int(capacityTF.text!) ?? 0,
            "currCapacity" : 0,
            "latitude" : 30.64228, // hard-coded. Alter: (currLocation.latitude)
            "longitude" : -96.36422, // hard-coded. Alter: (currLocation.longitude)
            "userType" : GlobalUserData.userType,
            "id" : GlobalUserData.userID
        ])
        performSegue(withIdentifier: "createShelterToYourShelters", sender: nil)
    }

}
