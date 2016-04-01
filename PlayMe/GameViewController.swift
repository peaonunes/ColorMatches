//
//  GameViewController.swift
//  PlayMe
//
//  Created by Rafael Nunes G. da Silveira on 22/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var modelsManager = ModelsManager.sharedInstance
    var model : Account!
    var gameModel : GameModel!
    
    var clockTimer = NSTimer()
    var countdownToStartTimer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Account()
        self.gameModel = GameModel(gameTimeLimit: 45, numberOfColors: 3)
        loadData()
    }
    
    func loadData(){
        self.model.name = modelsManager.getAccountModel().name
        self.model.bestScore = modelsManager.getAccountModel().bestScore
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        prepareGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yesAction(sender: AnyObject) {
        verifyAnswer(true)
    }
    
    @IBAction func noAction(sender: AnyObject) {
        verifyAnswer(false)
    }
    
    func prepareGame(){
        let alert = UIAlertController(title: "Get ready!", message: "Pay attetion to the first color!", preferredStyle: UIAlertControllerStyle.Alert)
       
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            self.updateState(0)
           
            self.countdownToStartTimer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(GameViewController.updateCountdownLabel), userInfo: nil, repeats: true)
            
            _ = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(GameViewController.startGame), userInfo: nil, repeats: false)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updateCountdownLabel(){
        if (self.gameModel.countdownToStart > 0){
            self.countdownLabel.text = "\(self.gameModel.countdownToStart)"
            self.gameModel.countdownToStart -= 1
        } else {
            self.countdownLabel.hidden = true
            self.countdownToStartTimer.invalidate()
        }
    }

    func startGame(){
        self.timeLabel.hidden = false
        self.questionLabel.hidden = false
        
        self.yesButton.enabled = true
        self.yesButton.hidden = false
        
        self.noButton.enabled = true
        self.noButton.hidden = false
       
        self.updateState(2)
        
        self.gameLoop()
    }
    
    func gameLoop(){
        self.clockTimer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(GameViewController.checkCountdown), userInfo: nil, repeats: true)
    }
    
    func checkCountdown(){
        self.gameModel.timeCounter += 1
        let actualTime = (self.gameModel.gameTimeLimit-self.gameModel.timeCounter)
        
        if(actualTime < 0){
            self.gameOver()
        } else {
            self.timeLabel.text = "\(actualTime)"
        }
    }
    
    func gameOver(){
        self.clockTimer.invalidate()
        
        if(self.isBestScore()){
            self.modelsManager.updateAccountModelAndSavePreferences(self.model)
            
            let alert = UIAlertController(title: "Best Score!", message: "Congrats! You have a new best score!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.Cancel, handler: {
                action in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Game Over!", message: "Try it again!", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: {
                action in
                self.navigationController?.popViewControllerAnimated(true)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func isBestScore() -> Bool{
        if (modelsManager.getAccountModel().bestScore < self.gameModel.gameScore){
            model.bestScore = self.gameModel.gameScore
            return true
        }
        return false
    }
    
    func changeColor(whichColor: Int){
        self.colorView.backgroundColor = self.gameModel.changeColor(whichColor)
    }

    func verifyAnswer(answer : Bool){
        
        if (answer == self.gameModel.isMatch()) {
            self.gameModel.gameScore += 1
        } else {
            
            self.gameModel.gameScore -= 1
            
            self.errorView.hidden = false
            _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(GameViewController.hideErrorView), userInfo: nil, repeats: false)
        }

        self.updateState(2)
    }
    
    func hideErrorView(){
         self.errorView.hidden = true
    }
    
    func updateState(whichColor: Int) {
        self.scoreLabel.text = String(format: "Score: %d", self.gameModel.gameScore)
        self.changeColor(whichColor)
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.colorView.transform = CGAffineTransformMakeScale(0.95, 0.95)
        })
        { (finished: Bool) -> Void in
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.colorView.transform = CGAffineTransformIdentity
            })
        }
    }

}
