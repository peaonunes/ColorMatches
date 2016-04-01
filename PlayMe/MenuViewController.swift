//
//  MenuViewController.swift
//  PlayMe
//
//  Created by Rafael Nunes G. da Silveira on 22/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var helloOutlet: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var modelsManager = ModelsManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func loadData(){
        helloOutlet.text = String(format: "Hello, %@", modelsManager.getAccountModel().name)
        scoreLabel.text = String(format: "Your last score was: %d", modelsManager.getAccountModel().bestScore)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonClicked(sender: AnyObject) {
        self.performSegueWithIdentifier("playGame", sender: self)
    }
   
    @IBAction func deleteButtonClicked(sender: AnyObject) {

        let alert = UIAlertController(title: "Hold on...", message: "Would you like to delete this account?", preferredStyle: UIAlertControllerStyle.Alert)

        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler: { action in
            self.modelsManager.getPreferencesModel().deletePreferences()
            self.performSegueWithIdentifier("deleteAccountSegue", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "playGame"{
            //In case of future needs
        } else if segue.identifier == "deleteAccountSegue" {
            
        }
    }
}
