//
//  ModelsManager.swift
//  PlayMe
//
//  Created by Rafael Nunes G. da Silveira on 23/03/2016.
//  Copyright © 2016 Rafael Nunes. All rights reserved.
//

import Foundation

class ModelsManager {
    
    static let sharedInstance = ModelsManager()

    private var accountModel : Account!
    private var preferencesModel : PreferencesModel!
    
    private init() {
        self.accountModel = Account()
        self.preferencesModel = PreferencesModel()
    }
    
    func setAccountModel(newModel : Account){
        self.accountModel = newModel
    }
    
    func getAccountModel() -> Account {
        return self.accountModel
    }
    
    func getPreferencesModel() -> PreferencesModel {
        return self.preferencesModel
    }
    
    func updateAccountModelAndSavePreferences(newAccountModel : Account){
        self.accountModel = newAccountModel
        self.preferencesModel.saveData(self.accountModel)
    }
}