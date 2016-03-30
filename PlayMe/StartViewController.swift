//
//  StartViewController.swift
//  PlayMe
//
//  Created by Rafael Nunes G. da Silveira on 22/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var buttonCreate: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var model : Account!
    var name : String!
    var modelsManager = ModelsManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        // initialize the account
        self.model = Account()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // check for saved data
        checkForSavedData()
    }
    
    func checkForSavedData(){
        if (modelsManager.getPreferencesModel().checkForSavedData(model) == 0){
            self.performSegueWithIdentifier("gotoMenu", sender: self)
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.name = self.nameTextField.text
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func createButtonClicked(sender: AnyObject) {
        if(nameTextField.text?.isEmpty == false){
            if (self.name == nil) {
                self.name = self.nameTextField.text
            }
            self.model.name = self.name
            self.model.bestScore = 0
            self.performSegueWithIdentifier("gotoMenu", sender: self)
        } else {
            let alert = UIAlertController(title: "Ops...", message: "Please don't fogert to write your name!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "gotoMenu" {
            modelsManager.updateAccountModelAndSavePreferences(model)
        }
    }

}
