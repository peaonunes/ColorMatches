//
//  AccountModel.swift
//  PlayMe
//
//  Created by Rafael Nunes G. da Silveira on 22/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import Foundation

class Account {
    
    var name : String!
    var bestScore : Int!
    
    init(){
        self.name = "NoName!"
        self.bestScore = 0
    }
    
    func setName(newName : String)
    {
        self.name = newName
    }
    
    func setBestScore(newScore : Int){
        self.bestScore = newScore
    }
    
}