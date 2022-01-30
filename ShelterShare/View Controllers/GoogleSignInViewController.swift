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
//        var ref: DatabaseReference!
//
//        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInWithGoogle(_ sender: GIDSignInButton) {
        // MARK: Truncated boiler code from Google Sign for iOS documentation
        print("starting to sign in!")
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
                // user is signed in
                print("signed in!")
            }
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("signed out!")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
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
