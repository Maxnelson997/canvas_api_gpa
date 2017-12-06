//
//  feedback.swift
//  College Weighted Average Grade Calculator
//
//  Created by Max Nelson on 11/25/17.
//  Copyright © 2017 AsherApps. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

func emojiBro(emoji:String) -> UIButton {
    let b = UIButton()
    b.backgroundColor = UIColor.clear
    b.layer.cornerRadius = 15
    let e = UILabel()
    e.font = UIFont.init(customFont: .MavenProBold, withSize: 35)
    e.adjustsFontSizeToFitWidth = true
    e.translatesAutoresizingMaskIntoConstraints = false
    e.backgroundColor = .clear
    e.layer.cornerRadius = 15
    e.text = emoji
    e.textAlignment = .center
    
    b.addSubview(e)
    NSLayoutConstraint.activate(e.getConstraintsOfView(to: b))
    
    return b
}


class FeedbackView:UIView, UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == UIColor.lightGray {
            textField.text = nil
            textField.textColor = UIColor.black
        }
        
        self.gestureRecognizers?.removeAll()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
        boxView.animateView(direction: .up, distance: 120)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if (textField.text?.isEmpty)! {
            textField.text = "roast me here, then tap an emoji."
            textField.textColor = UIColor.lightGray
        }
        boxView.animateView(direction: .down, distance: 0)
    }
    

    @objc func dismissKeyboard() {
        feedbackText.resignFirstResponder()
        self.gestureRecognizers?.removeAll()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
    }
    
    
    func donebtn()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.dismissKeyboard))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        feedbackText.inputAccessoryView = doneToolbar
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        phaseTwo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var boxView:MaxView = {
        let m = MaxView()
        return m
    }()
    
    
    var message:String {
        get {
            return feedbackText.text!
        }
        set {
            feedbackText.text = message
        }
    }
    
    
    
    @objc func dismissAlert() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.boxView.transform = CGAffineTransform(translationX: 0, y: 200)
            self.alpha = 0
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    var stack:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.axis = .vertical
        return stack
    }()
    
    var smiles:UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 0
        stack.axis = .horizontal
        return stack
    }()
    
    let feedbackLabel:GPLabel = {
        let g = GPLabel()
        g.backgroundColor = UIColor.clear
        g.textColor = UIColor.darkGray
        g.textAlignment = .center
        g.text = "elaborate 🤔"
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 30)
        return g
    }()
    
    let feedbackText:UITextField = {
        let n =  UITextField()
        n.text = "roast me here, then tap an emoji."
        n.textColor = UIColor.lightGray
        n.font = UIFont.init(customFont: .MavenProBold, withSize: 11)
        n.textAlignment = .left
        n.backgroundColor = UIColor.white.withAlphaComponent(1)
        n.layer.cornerRadius = 5
        n.translatesAutoresizingMaskIntoConstraints = false
        
        //        n.attributedPlaceholder = NSAttributedString.init(string: "tell us in this box what you would like to see differently and we WILL make the changes! just type here and select a face below to send your message to our developers.", attributes: [NSAttributedStringKey.foregroundColor:UIColor.cellColor.withAlphaComponent(0.3)])
        return n
    }()
    
    let s0 = emojiBro(emoji: "😤")//iconView(type: .FAFrownO)
    let s1 = emojiBro(emoji: "😐")//iconView(type: .FAMehO)
    let s2 = emojiBro(emoji: "😃")//iconView(type: .FAFrownO)
    //    😃😐😤
    
    
    
    func phaseTwo() {
        self.feedbackText.delegate = self
        self.boxView.layer.cornerRadius = 15
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert)))
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        self.addSubview(boxView)
        let textContainer = UIView()
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.addSubview(feedbackText)
        NSLayoutConstraint.activate(feedbackText.getConstraintsOfView(to: textContainer, withInsets: UIEdgeInsetsMake(5, 5, -5, -5)))
        boxView.addSubview(stack)
        stack.addArrangedSubview(feedbackLabel)
        stack.addArrangedSubview(textContainer)
        stack.addArrangedSubview(smiles)
        
        smiles.addArrangedSubview(s0)
        smiles.addArrangedSubview(s1)
        smiles.addArrangedSubview(s2)
        
        s0.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        s1.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        s2.addTarget(self, action: #selector(self.dismissAlert), for: .touchUpInside)
        
        s0.tag = 0
        s1.tag = 1
        s2.tag = 2
        
        NSLayoutConstraint.activate([
            boxView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            boxView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            boxView.widthAnchor.constraint(equalToConstant: 200),
            boxView.heightAnchor.constraint(equalToConstant: 300),
            
            feedbackLabel.heightAnchor.constraint(equalToConstant: 60),
            feedbackText.heightAnchor.constraint(lessThanOrEqualTo: stack.heightAnchor),
            smiles.heightAnchor.constraint(equalToConstant: (200/3) - 15),
            s0.widthAnchor.constraint(equalTo: smiles.widthAnchor, multiplier: 1/3),
            s1.widthAnchor.constraint(equalTo: smiles.widthAnchor, multiplier: 1/3),
            s2.widthAnchor.constraint(equalTo: smiles.widthAnchor, multiplier: 1/3),
            ])
        NSLayoutConstraint.activate(stack.getConstraintsOfView(to: boxView))
        self.alpha = 0
        self.boxView.transform = CGAffineTransform(translationX: 0, y: 200)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4, initialSpringVelocity: 5, options: .curveEaseOut, animations: {
            self.boxView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.alpha = 1
        }) { (true) in
            
        }
        
        donebtn()
        
    }
    
    
}

