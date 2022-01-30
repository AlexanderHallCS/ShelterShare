//
//  StartViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit

class StartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? GoogleSignInViewController {
            if segue.identifier == "INeedAShelterToLogin" {
                GlobalUserData.userType = "shelterSeeker"
            } else {
                GlobalUserData.userType = "shelterProvider"
            }
        }
    }

}

