//
//  PreferencesModel.swift
//  PlayMe
//
//  Created by Rafael Nunes G. da Silveira on 23/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import Foundation

class PreferencesModel {
    
    var defaults : NSUserDefaults!
    
    init(){
        defaults = NSUserDefaults.standardUserDefaults()
    }
    
    func saveData(accountModel : Account){
        defaults.setObject(accountModel.name , forKey: "name")
        defaults.setObject(accountModel.bestScore, forKey: "bestScore")
    }
    
    func checkForSavedData(accountModel : Account) -> Int{
        
        // if an account does exist then go directly to Menu
        if let name : String = defaults.stringForKey("name"){
            if name.isEmpty == false {
                accountModel.name = name
                if let bestScore = defaults.stringForKey("bestScore"){
                    accountModel.bestScore = Int(bestScore)
                    return 0
                }
            } else {
                return 1
            }
        }
        return 2
    }
    
    func deletePreferences(){
        defaults.removeObjectForKey("name")
        defaults.removeObjectForKey("bestScore")
    }

}