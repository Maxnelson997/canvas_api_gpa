//
//  GPFlipView.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class GPFlipView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        phaseTwo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isFlipped:Bool = false
    
    var firstView:GPView!
    var secondView:GPView!
    
    var flipViews:(front:UIView, back:UIView)?
    
    var current_view_cons:[NSLayoutConstraint]!
    var second_cons:[NSLayoutConstraint]!
    
//    let viewColor = UIColor.init(red: 175/255, green: 175/255, blue: 175/255, alpha: 0.5)
    let viewColor = UIColor.clear
    
    func phaseTwo() {
        firstView = GPView()
        secondView = GPView()
    

        flipViews = (front: firstView, back: secondView)
        
        addSubview(flipViews!.front)
        
        setup_cons()
    }
    
    func setup_cons() {
        current_view_cons = [
            self.flipViews!.front.leftAnchor.constraint(equalTo: self.leftAnchor),
            self.flipViews!.front.rightAnchor.constraint(equalTo: self.rightAnchor),
            self.flipViews!.front.topAnchor.constraint(equalTo: self.topAnchor),
            self.flipViews!.front.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(current_view_cons)
    }
    
   
    func switchViews(completion: @escaping () -> Void) {
        var transitionOptions:UIViewAnimationOptions!
        if isFlipped {
            transitionOptions = .transitionFlipFromLeft
            flipViews = (front: firstView, back: secondView)
        } else {
            transitionOptions = .transitionFlipFromRight
            flipViews = (front: secondView, back: firstView)
        }
        isFlipped = !isFlipped
        
        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: {
            self.flipViews!.back.removeFromSuperview()
            self.addSubview(self.flipViews!.front)
            self.setup_cons()
        }, completion: { finished in
            completion()
        })
    }
    
    
    func flip(to: FlipViewSide, completion: @escaping () -> Void) {
        var transitionOptions:UIViewAnimationOptions!
        if to == .firstView {
            transitionOptions = .transitionFlipFromLeft
            flipViews = (front: firstView, back: secondView)
        } else if to == .secondView {
            transitionOptions = .transitionFlipFromRight
            flipViews = (front: secondView, back: firstView)
        }
        
        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: {
            self.flipViews!.back.removeFromSuperview()
            self.addSubview(self.flipViews!.front)
            self.setup_cons()
        }, completion: { finished in
            completion()
        })
    }
    
    
    

}

struct FlipViewSide: OptionSet {
    //bit mask value
    let rawValue:Int
    
    //options
    static let firstView = FlipViewSide(rawValue: 1)
    static let secondView = FlipViewSide(rawValue: 2)
}
