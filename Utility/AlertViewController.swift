//
//  AlertViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 22/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  Understanding UIAlertController - Alerts and Actionsheets
//  // check alarm etc style
// add each alert to IBAction for tutorial purpose, label text for action.

import UIKit

class AlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Warning: Attempt to present <UIAlertController: 0x7f86b6039600> on <Utility.ViewController: 0x7f86b4408610> whose view is not in the window hierarchy!
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showSettingsAlert()
    }
    
    // call : showSimpleAlert(title: "Do you want to have coffee?", message: "Let's go!")
    // call : showSimpleAlert(title: "Do you want to have coffee?", message: "Let's go!", style: .actionSheet)
    func showSimpleAlert(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // call : showStandardAlertWithAction(title: "Do you want to have coffee?", message: "Let's go!")
    func showStandardAlertWithAction(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            print("You Agreed!")//add in a label on app
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelTapped(action:))
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // call : showAlertWithChangedPreferredAction(title: "Do you want to have coffee?", message: "Let's go!")
    func showAlertWithChangedPreferredAction(title: String, message: String, style: UIAlertControllerStyle = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // App crashes if preferred before adding
        //Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'The -preferredAction of an alert controller must be contained in the -actions array or be nil.'
        //alert.preferredAction = okAction
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        //Changing default preferred action from cancel to OK
        alert.preferredAction = okAction
        present(alert, animated: true, completion: nil)
    }
    
    func cancelTapped(action: UIAlertAction) {
        print("Sorry to see you go!")
    }
    
    // call : showSettingsAlert
    func showSettingsAlert() {
        let alert = UIAlertController(title: "Do you want to turn on location services for this app?", message: "Go to settings!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Settings", style: .default, handler: {action in
            if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                }// It is showing general settings.. how? no settings for the app added in info.plist so?
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // call : showAlertWithUserInput()
    func showAlertWithUserInput() {
        let alert = UIAlertController(title: "Type \"Yes\" if you agree!", message: "", preferredStyle: .alert)
        //alert.addTextField(configurationHandler: nil) // shows up healthy, but no config
        // plus we can add many textfields and access using the array
        alert.addTextField(configurationHandler:{textfield in
            textfield.placeholder = "Yes/No"
        })
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in
            if let textfield = alert.textFields?.first {
                if let textInput = textfield.text {
                    print(textInput)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // call : showAlertWithMorethanTwoOptions()
    func showAlertWithMorethanTwoOptions() {
        let alert = UIAlertController(title: "More than two options", message: "Eh! Crowded!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        let huhAction = UIAlertAction(title: "Huh", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // >2 options, comes vertically in order of adding, ok on top
        alert.addAction(okAction)
        alert.addAction(huhAction)
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

}

