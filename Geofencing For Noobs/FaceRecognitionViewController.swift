//
//  FaceRecognitionViewController.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 17/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit
import LocalAuthentication

class FaceRecognitionViewController: UIViewController {
    
    var context = LAContext()
    enum AuthenticationState {
        case loggedin, loggedout
    }
    var state = AuthenticationState.loggedout 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        context = LAContext()
        var error:NSError?
        
        // edit line - deviceOwnerAuthentication
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            //showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        let reason = "Log in to your account"
        
        // edit line - deviceOwnerAuthentication
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            
            // edit line - deviceOwnerAuthentication
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        print("Authentication was successful")
                        self.state = .loggedin
                        self.performSegue(withIdentifier: "faceID", sender: self)
                    }
                }else {
                    DispatchQueue.main.async {
                        //self.displayErrorMessage(error: error as! LAError )
                        print("Authentication was error")
                    }
                }
            })
        }else {
            // self.showAlertWith(title: "Error", message: (errorPointer?.localizedDescription)!)
        }
    }

}
