//
//  GPCellViews.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class empty_cell:UICollectionViewCell {
    var exists:Bool = false
    override func awakeFromNib() {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.purple
//        addSubview(view)
//        NSLayoutConstraint.activate(view.getConstraintsOfView(to: contentView))
    }
    override func prepareForReuse() {
        
    }

}

class semester_cell:UICollectionViewCell {
    
    var name:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProBold, withSize: 15)
        l.backgroundColor = .clear

        return l
    }()
    var gpa:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProBold, withSize: 35)
        l.backgroundColor = .clear

        return l
    }()
    
    fileprivate lazy var stack:GPStackView = {
        let s = GPStackView(arrangedSubviews: [self.name, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical

        return s
    }()
    
    var stack_cons:[NSLayoutConstraint]!
    
    var exists:Bool = false

    override func awakeFromNib() {

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        if !exists {
            contentView.addSubview(stack)
            stack_cons = [
                stack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
            NSLayoutConstraint.activate(stack_cons)
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.3),
                gpa.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.7),
                ])
            exists = true
        }
    }
    override func prepareForReuse() {
        
    }
    
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}


class class_cell:UICollectionViewCell {
    
    var name:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 25)
        g.textAlignment = .center
        return g
    }()
    var grade:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        g.textAlignment = .center
        return g
    }()
    var hours:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        g.textAlignment = .center
        return g
    }()
    var gpa:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        g.textAlignment = .center
        return g
    }()
    
    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.grade, self.hours, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.isUserInteractionEnabled = false
        return s
    }()
    
    fileprivate lazy var stack1:GPStackView = {
        let s = GPStackView(arrangedSubviews: [self.name, self.stack])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
         s.isUserInteractionEnabled = false
        return s
    }()
    
    var stack1_cons:[NSLayoutConstraint]!
    var stack_cons:[NSLayoutConstraint]!
    var name_cons:[NSLayoutConstraint]!
    var exists:Bool = false

    override func awakeFromNib() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        name.backgroundColor = .clear
        grade.backgroundColor = .clear
        hours.backgroundColor = .clear
        gpa.backgroundColor = .clear

        if !exists {
            contentView.addSubview(stack1)
            
            stack1_cons = [
                stack1.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
                stack1.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
                stack1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
                stack1.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            ]
            
            NSLayoutConstraint.activate(stack1_cons)


            NSLayoutConstraint.activate([
                grade.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/3),
                hours.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/3),
                gpa.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1/3),
                ])
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack1.heightAnchor, multiplier: 0.5),
                stack.heightAnchor.constraint(equalTo: stack1.heightAnchor, multiplier: 0.5),
      
                ])

            exists = true
            
        }
        
    }
    
    override func prepareForReuse() {
        
    }
}


class CVHeader:UICollectionReusableView {
    
    var backBtn = UIButton(type: .custom)
    let grade:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProRegular, withSize: 15)
        g.text = "GRADE"
        g.textAlignment = .center
        return g
    }()
    let hour:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProRegular, withSize: 15)
        g.text = "HOURS"
        g.textAlignment = .center
        return g
    }()
    let gpa:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProRegular, withSize: 15)
        g.text = "GPA"
        g.textAlignment = .center
        return g
    }()
    
    fileprivate lazy var info_stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.grade, self.hour, self.gpa])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        return s
    }()
    
    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.backBtn, self.info_stack])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    
    var stack_cons:[NSLayoutConstraint]!
    var active:Bool = false
    override func awakeFromNib() {
        backBtn.setFAIcon(icon: FAType.FAArrowLeft, forState: .normal)
        //        backBtn.setTitleColor(UIColor.white, for: .normal)
        
        if !active {
            active = true
            addSubview(stack)
            stack_cons = stack.getConstraintsOfView(to: self)
            NSLayoutConstraint.activate(stack_cons)
            NSLayoutConstraint.activate([
                
                grade.widthAnchor.constraint(equalTo: info_stack.widthAnchor, multiplier: 1/3),
                hour.widthAnchor.constraint(equalTo: info_stack.widthAnchor, multiplier: 1/3),
                gpa.widthAnchor.constraint(equalTo: info_stack.widthAnchor, multiplier: 1/3),
                
                backBtn.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.5),
                info_stack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.5)
                
                ])
        }
    }
    
    override func prepareForReuse() {
        
    }
}

class CVFooter:UICollectionReusableView {
    
    var plus_button:UIButton = UIButton()
    var minus_button:UIButton = UIButton()
    var cancel_button:UIButton = UIButton()

    fileprivate var plus:UIBarButtonItem!
    fileprivate var minus:UIBarButtonItem!
    fileprivate var flexspace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    fileprivate let toolbar = UIToolbar()
    
    fileprivate var cancel:UIBarButtonItem!
    
    var active:Bool = false
    var is_editing:Bool = false
    var cons:Bool = false
    
    var toolbar_cons:[NSLayoutConstraint]!
    
    override func awakeFromNib() {
        if !active {
            plus_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            plus_button.setFAIcon(icon: FAType.FAPlus, forState: .normal)
            plus = UIBarButtonItem(customView: plus_button)
            
            minus_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            minus_button.setFAIcon(icon: FAType.FAMinus, forState: .normal)
            minus = UIBarButtonItem(customView: minus_button)
            
            toolbar.setItems([plus, flexspace, minus], animated: true)
            toolbar.barStyle = .blackOpaque
            toolbar.layer.cornerRadius = 12
            toolbar.layer.masksToBounds = true
            //            toolbar.setBackgroundImage(UIImage(),
            //                                            forToolbarPosition: .any,
            //                                            barMetrics: .default)
            //            toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
            toolbar.translatesAutoresizingMaskIntoConstraints = false
            if !cons {
                cons = true
                self.addSubview(toolbar)
                //            NSLayoutConstraint.activate(toolbar.getConstraintsOfView(to: self))
                toolbar_cons = [
                    toolbar.topAnchor.constraint(equalTo: self.topAnchor),
                    toolbar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    toolbar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
                    toolbar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30)
                ]
                NSLayoutConstraint.activate(toolbar_cons)
            }

            active = true
        }
        

        if is_editing {
            cancel_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            cancel_button.setFAIcon(icon: FAType.FAClose, forState: .normal)
            cancel = UIBarButtonItem(customView: cancel_button)
            toolbar.setItems([flexspace, cancel, flexspace], animated: true)
            is_editing = false
            active = false
        }
        

        
    }
    
    override func prepareForReuse() {

    }
}



class GPStackView:UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        phaseTwo()
    }
    

    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var layerColors:[CGColor] {
        set {
            if let laya = self.layer as? CAGradientLayer {
                laya.colors = newValue
                laya.locations = [0.0, 0.5]
            }
        }
        get {
            return [ UIColor(rgb: 0x82D15C).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        }
    }
    
    var colors:[CGColor] = [ UIColor(rgb: 0x42C8FF).withAlphaComponent(1).cgColor, UIColor(rgb: 0x575858).withAlphaComponent(1).cgColor ]
    
    func phaseTwo() {
        if let laya = self.layer as? CAGradientLayer {
//yellowgreenishbluefade            laya.colors = [ UIColor(rgb: 0x82D15C).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
            laya.colors = self.colors
            laya.locations = [0.0, 1.5]
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 13
        self.addDropShadowToView()
        
        
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

class MaxView:UIView {
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
    
    func phaseTwo() {
        if let laya = self.layer as? CAGradientLayer {
            laya.colors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
            laya.locations = [0.0, 1.20]
        }
        self.addDropShadowToView()
    }
    
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}


class new_semester_header:UICollectionReusableView {

    override func awakeFromNib() {

    }
    
    override func prepareForReuse() {
        
    }
}

class new_semester_footer:UICollectionReusableView {
    
    var cancel_button:UIButton = UIButton()
    var done_button:UIButton = UIButton()
    
    var active:Bool = false
    
    override func awakeFromNib() {
        if !active {
            cancel_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            cancel_button.setFAIcon(icon: FAType.FAThumbsDown, forState: .normal)
            let plus = UIBarButtonItem(customView: cancel_button)
            
            done_button.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            done_button.setFAIcon(icon: FAType.FAThumbsUp, forState: .normal)
            let minus = UIBarButtonItem(customView: done_button)
            
            let flexspace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let toolbar = UIToolbar()
            toolbar.barStyle = .blackOpaque
            toolbar.layer.cornerRadius = 12
            toolbar.layer.masksToBounds = true

            toolbar.translatesAutoresizingMaskIntoConstraints = false
            toolbar.setItems([plus, flexspace, minus], animated: true)
            self.addSubview(toolbar)
            
            //            NSLayoutConstraint.activate(toolbar.getConstraintsOfView(to: self))
            NSLayoutConstraint.activate([
                toolbar.topAnchor.constraint(equalTo: self.topAnchor),
                toolbar.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                toolbar.leftAnchor.constraint(equalTo: self.leftAnchor),
                toolbar.rightAnchor.constraint(equalTo: self.rightAnchor)
                ])
        }
    }
    
    override func prepareForReuse() {
        
    }
}

