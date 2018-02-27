//
//  ActionSheetViewController.swift
//  Utility
//
//  Created by Jasmee Sengupta on 27/02/18.
//  Copyright © 2018 Jasmee Sengupta. All rights reserved.
//  Present an action sheet with default, cancel and destructive type buttons, with appropriate completion handlers.

import Foundation
import UIKit

class ActionSheetViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func actionSheetButtonTapped(_ sender: UIButton) {
        showActionSheet()
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: "Choose your deal.", message: "Save, delete or simply cancel this action.", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {action in
            
        })
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {action in
            print("Save your data here")
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteData(_:))
        actionSheet.addAction(cancelAction)// cancel always bottom most
        actionSheet.addAction(deleteAction)//destructive buttons on top
        actionSheet.addAction(saveAction)// adds vertically top to down in order
        present(actionSheet, animated: true, completion: nil)
    }
    
    func deleteData(_ action: UIAlertAction) {//(action: UIAlertAction) works with deleteData(action:)
        print("Going to delete - destructive action")
    }
    
}
