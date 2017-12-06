//
//  SettingsLogic.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 12/5/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class SettingsLogic {
    static let instance = SettingsLogic()
    
    var deli:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @objc func reset() {
        
    }
    
    @objc func theme() {
        deli.main_controller.settings.selectingTheme = !deli.main_controller.settings.selectingTheme
        deli.main_controller.rotateIcon(yes: deli.main_controller.settings.selectingTheme)
        if deli.main_controller.settings.selectingTheme {
            deli.main_controller.fade.removeTarget(nil, action: nil, for: .allTouchEvents)
            deli.main_controller.fade.addTarget(self, action: #selector(self.theme), for: .touchUpInside)
        } else {
            deli.main_controller.fade.removeTarget(nil, action: nil, for: .allTouchEvents)
            deli.main_controller.fade.addTarget(deli.main_controller, action: #selector(deli.main_controller.animateSettings), for: .touchUpInside)
        }
    }
    
    @objc func feedback() {
        
    }
    
    @objc func share() {
        
    }
    
    @objc func instagram(){
        
    }
    
}
