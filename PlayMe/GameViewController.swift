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
    
    var modelsManager = ModelsManager.sharedInstance
    var model : Account!
    
    var colors : [UIColor] = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor()]
    
    var lastColor : UIColor!
    var currentColor : UIColor!
    var score = 0
    
    var timeLimite : Int = 45
    var counter = 0
    var timer = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model = Account()
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startGame()
    }
    
    @IBAction func yesAction(sender: AnyObject) {
        computeAnswer(true)
    }
    
    @IBAction func noAction(sender: AnyObject) {
        computeAnswer(false)
    }
    
    func computeAnswer(answer : Bool){
        if (answer == isMatch()) {
            score += 1
        } else {
            score -= 1
            errorView.hidden = false
            _ = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(GameViewController.indicateError), userInfo: nil, repeats: false)
        }
        updateLabel()
        changeColor()
    }
    
    func indicateError(){
        errorView.hidden = true
    }
    
    func isMatch() -> Bool {
        if (lastColor == currentColor){
            return true
        } else {
            return false
        }
    }
    
    func updateLabel() {
        self.scoreLabel.text = String(format: "Score: %d", score)
    }
    
    func loadData(){
        self.model.name = modelsManager.getAccountModel().name
        self.model.bestScore = modelsManager.getAccountModel().bestScore
    }
    
    func startGame(){
        let alert = UIAlertController(title: "Get ready!", message: "Pay attetion to the first color!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            action in
            self.chooseColor(0)
            self.colorView.backgroundColor = self.lastColor
            _ = NSTimer.scheduledTimerWithTimeInterval(4.0, target: self, selector: #selector(GameViewController.firstUpdate), userInfo: nil, repeats: false)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func timerAction(){
        counter += 1
        let time = (timeLimite-counter)
        if((time) < 0){
            gameOver()
        } else {
            timeLabel.text = "\(time)"
        }
    }
    
    func chooseColor(color : Int){
        let random = Int(arc4random_uniform(3))
        if (color == 0) {
            lastColor = colors[random]
            currentColor = colors[random]
        } else if (color == 1){
            lastColor = colors[random]
        } else {
            currentColor = colors[random]
        }
    }
    
    func changeColor(){
        lastColor = currentColor
        chooseColor(2)
        self.colorView.backgroundColor = currentColor
    }
    
    func firstUpdate(){
        questionLabel.hidden = false
        yesButton.enabled = true
        noButton.enabled = true
        changeColor()
        gameLoop()
    }
    
    func gameLoop(){
        timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: #selector(GameViewController.timerAction), userInfo: nil, repeats: true)
    }
    
    func clearView(){
        score = 0
    }
    
    func gameOver(){
        timer.invalidate()
        if(isBestScore()){
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
        if (modelsManager.getAccountModel().bestScore < score){
            model.bestScore = score
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
