//
//  CreateANewAccount.swift
//  FirebaseIM
//
//  Created by Safina Lifa on 8/29/16.
//  Copyright © 2016 Safina Lifa. All rights reserved.
//

import UIKit
import Firebase

class CreateANewAccount: UIViewController {
    
    @IBOutlet weak var createNewEmail: UITextField!
    
    @IBOutlet weak var createNewPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateANewAccount.dismissKeyboard))
        view.addGestureRecognizer(tap)
        let swipeRec = UISwipeGestureRecognizer()
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func signUpNewAcct(sender: AnyObject) {
        let email = createNewEmail.text!
        let password = createNewPassword.text!
        FIRAuth.auth()?.createUserWithEmail(email, password: password) { (user, error) in
            
            if error != nil {
                
                // There was an error logging in to this account
                let alertController = UIAlertController(
                    title: "Hey user!",
                    message: "You have already created an account under this e-mail address!",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                
                let cancelAction = UIAlertAction(
                    title: "Cancel",
                style: UIAlertActionStyle.Destructive) { (action) in
                    // ...
                }
                
                let confirmAction = UIAlertAction(
                title: "OK", style: UIAlertActionStyle.Default) { (action) in
                    // ...
                }
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                let alertController = UIAlertController(
                    title: "Hey user!",
                    message: "You have signed up!",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                let cancelAction = UIAlertAction(
                    title: "Cancel",
                style: UIAlertActionStyle.Destructive) { (action) in
                    // ...
                }
                
                let confirmAction = UIAlertAction(
                    title: "OK", style: UIAlertActionStyle.Default, handler: {
                        (action) in self.performSegueWithIdentifier("Success", sender: self)
                })
                // ...
                
                
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
}