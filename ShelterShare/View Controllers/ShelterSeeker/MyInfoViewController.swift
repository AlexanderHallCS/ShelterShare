//
//  MyInfoViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class MyInfoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTF: UITextField!
    @IBOutlet var phoneTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameTF.delegate = self
        phoneTF.delegate = self
        emailTF.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func pressConfirm(_ sender: UIButton) {
        let db = Firestore.firestore()
        db.collection("users").document(GlobalUserData.userID).setData([
            "name" : nameTF.text!,
            "phone" : phoneTF.text!,
            "email" : emailTF.text!,
            "userType" : GlobalUserData.userType,
            "shelter" : "" // identified by id
        ])
        performSegue(withIdentifier: "myInfoToSheltersTable", sender: self)
    }
}
