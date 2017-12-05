//
//  extension.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

enum CustomFont: String {
    case MavenProRegular = "MavenPro-Regular"
    case MavenProBlack = "MavenPro-Black"
    case MavenProBold = "MavenPro-Bold"
    case MavenProMedium = "MavenPro-Medium"
}

extension UIFont {
    convenience init?(customFont: CustomFont, withSize size: CGFloat) {
        self.init(name: customFont.rawValue, size: size)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    func addDropShadowToView(){
        self.layer.masksToBounds =  false
        self.layer.shadowColor = UIColor.darkGray.cgColor;
        self.layer.shadowOffset = CGSize(width: 8.0, height: 11.0)
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5
    }
}

extension UILabel {
    func animate(toText:String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.text = toText
            UIView.animate(withDuration: 0.35, animations: {
                self.alpha = 1
            })
        })
    }
}

extension UITextField {
    func animate(toText:String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { finished in
            self.text = toText
            UIView.animate(withDuration: 0.35, animations: {
                self.alpha = 1
            })
        })
    }
    
    func moveTextField(inView: UIView, moveDistance: Int, up: Bool)
    {
        let moveDuration = 0.3
        //movement similar to isset in php. if up true + if !up true -
        let movement: CGFloat = CGFloat(up ? -moveDistance : moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        //animated way
        UIView.setAnimationBeginsFromCurrentState(true)
        //completion timer
        UIView.setAnimationDuration(moveDuration)
        //
        inView.frame = inView.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
}
