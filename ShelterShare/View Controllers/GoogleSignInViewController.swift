//
//  GoogleSignInViewController.swift
//  ShelterShare
//
//  Created by Alexander Hall on 1/29/22.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import GoogleSignIn

class GoogleSignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInWithGoogle(_ sender: GIDSignInButton) {
        // MARK: Truncated boiler code from Google Sign for iOS documentation
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if(error != nil) {
                    print("There was an error!")
                }
                // assume user does not have multi-factor auth enabled (no phone confirmation)
                // signed in
                GlobalUserData.userID = (user?.userID)!
                goToSpecificVC()
            }
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            // signed out
            createAlert(message: "You have been logged out!")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func createAlert(message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) {(action: UIAlertAction) -> Void in
            alert.removeFromParent()
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func goToSpecificVC() {
        switch GlobalUserData.userType {
        case "shelterSeeker":
            performSegue(withIdentifier: "loginToSheltersNearMe", sender: self)
        default:
            performSegue(withIdentifier: "loginToShelterActions", sender: self)
        }
    }

}
