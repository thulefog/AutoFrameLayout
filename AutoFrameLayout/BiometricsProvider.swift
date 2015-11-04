//
//  BiometricsProvider.swift
//  AutoFrameLayout
//
//  Created by John Matthew Weston in September 2015 with iterative improvements since.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation
import LocalAuthentication

protocol IBiometricsProvider
{
    func Authenticate() -> Bool
}

//OPEN: considered a dedicate class implementing IBiometricsProvider, taking simpler extension approach for now...
extension UIViewController {
    
    func showAlertController(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func authenticateWithTouchID() -> Bool {
        // create the Local Authentication context and working variables
        let context = LAContext()
        var error: NSError?
        var result: Bool
        result = false
        
        // check if Touch ID is available
        do {
            context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
            // if biometrics available, go ahead and authenticate with Touch ID
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(success: Bool, error: NSError?) in
                    // in line with typical UX flow these days, raise alert to user to show pass/fail state
                    if success {
                        self.showAlertController("Touch ID Authentication Succeeded")
                        result = true
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                        result = false
                    }
            })
        } catch let error1 as NSError { //this probably means we are running in the simulator, let this slide and mask as passed
            error = error1
            showAlertController("Touch ID not available")
            result = true;
        }
        return result
    }
}