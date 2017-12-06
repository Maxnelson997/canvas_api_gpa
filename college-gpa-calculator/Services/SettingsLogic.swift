//
//  SettingsLogic.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 12/5/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import PopupDialog

class SettingsLogic {
    static let instance = SettingsLogic()
    
    var deli:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var ref:DatabaseReference!
    
    @objc func reset() {
        let m = GPModel.sharedInstance
        let c = deli.main_controller
        m.semesters = []
        c?.infoLabel.animate(toText: "0 SEMESTERS")
        c?.is_editing = false
        c?.semester_cv.reloadData()
        m.removeAllCD()
        
        if !m.userIsFreemium {
            resetTheme()
        } else {
            let pop = PopupDialog(title: "App Reset", message: "Semesters and Classes reset")
            c?.present(pop, animated: true, completion: nil)
            delay(4, closure: {
                pop.dismiss()
            })
        }
        
        
       
        
    }
    
    func resetTheme() {
        //change theme user has iap
        GPModel.sharedInstance.currentTheme = getColors(at: 2)
        GPModel.sharedInstance.themeNumber = 2
        deli.main_controller.settings.cv.reloadData()
        (UIApplication.shared.delegate as! AppDelegate).main_controller.maxv.layerColors = getColors(at: 2)
        
        let pop = PopupDialog(title: "App Reset", message: "Semesters - Classes - Themes reset")
        deli.main_controller.present(pop, animated: true, completion: nil)
        delay(4, closure: {
            pop.dismiss()
        })
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
    
    var feedbackView:FeedbackView!
    
    @objc func feedback() {
        feedbackView = FeedbackView()
        deli.main_controller.view.addSubview(feedbackView)
        
        feedbackView.s0.addTarget(self, action: #selector(self.sendFeedback(sender:)), for: .touchUpInside)
        feedbackView.s1.addTarget(self, action: #selector(self.sendFeedback(sender:)), for: .touchUpInside)
        feedbackView.s2.addTarget(self, action: #selector(self.sendFeedback(sender:)), for: .touchUpInside)
    }
    
    @objc func sendFeedback(sender:UIButton) {
        var message:String = feedbackView.message
        var satisfaction:CGFloat!
        //        var satisfactionRatio:CGFloat!
        
        switch sender.tag {
        case 0:
            satisfaction = 1
        //            satisfactionRatio = 3/3 //frown
        case 1:
            satisfaction = 2
        //            satisfactionRatio = 2/3 //hmm
        case 2:
            satisfaction = 3
        //            satisfactionRatio = 1/3 //smile
        default:
            break
        }
        
        if message == "tap here to tell us here what you want to see differently then choose an emoji matching how you feel about this app. or just tap an emoji." {
            message = "no written feedback."
        }
        
        ref = Database.database().reference()
        
        //        self.ref.child("cgafeedback").childByAutoId()
        //        self.ref.child("cgafeedback").setValuesForKeys(["message":message, "satisfaction":satisfaction])
        
        let key = ref.child("gpafeedback").childByAutoId().key
        let post = ["message": message,
                    "satisfaction": satisfaction] as [String : Any]
        let childUpdates = ["/gpafeedback/\(key)": post]
        ref.updateChildValues(childUpdates)
        //        self.db.child("users").child(uid!).updateChildValues(["scanHistory":Model.instance.userSettings.getScanHistoryArray()])
        //        ref.database.setValue(["message":message, "satisfaction":satisfaction], forKey: "cgafeedback")
        //request with feedback
        //satisfactionRequestse params being -> ?message=message&satisfaction=satisfaction&satisfactionRatio=satisfactionRatio
        
    }
    
    @objc func share() {
        //share
        let message = "This app calculuates your GPA and lets you have semesters and stuff. Its Lit & Legendary fam 🔥. \n"
        let link = "http://apple.co/2w4iab8"
        
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [message, link], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = deli.main_controller.view
        deli.main_controller.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @objc func instagram() {
        //guide to my instagram page
        let instagram = URL(string: "instagram://user?username=maxcodes")!
        
        if UIApplication.shared.canOpenURL(instagram) {
            UIApplication.shared.open(instagram, options: ["":""], completionHandler: nil)
        }
    }
    
    
    
    
    
}
