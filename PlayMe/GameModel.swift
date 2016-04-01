//
//  GameModel.swift
//  ColorMatches
//
//  Created by Rafael Nunes G. da Silveira on 31/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import UIKit
import Foundation

protocol GameModelProtocol {
    
    // properties
    var gameTimeLimit : Int { get }
    var numberOfColors : Int { get }
    var gameScore : Int { get set }
    var currentColor : UIColor! { get set }
    var lastColor : UIColor! { get set }
    var timeCounter : Int { get set }
    var countdownToStart : Int { get set }
    
    // methods
    func isMatch() -> Bool
    func changeColor(whichColor: Int) -> UIColor
    
}

class GameModel : GameModelProtocol{
    
    var gameTimeLimit : Int
    var numberOfColors : Int
    var gameScore : Int
    var currentColor : UIColor!
    var lastColor : UIColor!
    var timeCounter : Int
    var countdownToStart: Int
    
    internal var uiColors : [UIColor] = [UIColor.redColor(), UIColor.greenColor(), UIColor.blueColor(), UIColor.brownColor(), UIColor.cyanColor(), UIColor.darkGrayColor()]
    
    init(gameTimeLimit:Int,numberOfColors: Int){
        self.gameTimeLimit = gameTimeLimit
        self.numberOfColors = numberOfColors
        self.gameScore = 0
        let color = UIColor.whiteColor()
        self.currentColor = color
        self.lastColor = color
        self.timeCounter = 0
        self.countdownToStart = 3
    }
    
    // whichColor defines if it's first use or not
    internal func chooseColor(whichColor: Int) {
        if (self.numberOfColors <= uiColors.count){
            
            let random = Int(arc4random_uniform(UInt32(self.numberOfColors)))
        
            if (whichColor == 0) {

                self.lastColor = self.uiColors[random]
                self.currentColor = self.uiColors[random]
                
            } else if (whichColor == 1){
                
                self.lastColor = self.uiColors[random]
                
            } else {
                self.currentColor = self.uiColors[random]
            }
        }
    }
    
    func changeColor(whichColor: Int) -> UIColor {
        self.lastColor = self.currentColor
        self.chooseColor(whichColor)
        return self.currentColor
    }
    
    func isMatch() -> Bool {
        if (self.lastColor == self.currentColor){
            return true
        } else {
            return false
        }
    }
    

}