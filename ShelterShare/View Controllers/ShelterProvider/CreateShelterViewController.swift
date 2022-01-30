//
//  CreateShelterViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit

class CreateShelterViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {

    @IBOutlet var shelterNameTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var yourNameTF: UITextField!
    @IBOutlet var capacityTF: UITextField!
    
    @IBOutlet var shelterTypePickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shelterNameTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
        yourNameTF.delegate = self
        capacityTF.delegate = self
        
        shelterTypePickerView.delegate = self
    }
    
    @IBAction func askForCurrentLocation(_ sender: UIButton) {
        
    }
    
    @IBAction func segueFromCreateShelterToYourShelters(_ sender: UIButton) {
        // if done storing shelter data in firebase
        performSegue(withIdentifier: "createShelterToYourShelters", sender: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
