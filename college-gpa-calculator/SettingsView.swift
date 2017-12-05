//
//  SettingsView.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 12/3/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Font_Awesome_Swift

class SettingCell:UICollectionViewCell {
    var name:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProBold, withSize: 15)
        l.backgroundColor = .clear
        l.textAlignment = .center
        return l
    }()
    var icon:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProBold, withSize: 35)
        l.backgroundColor = .clear
        l.textAlignment = .center
        return l
    }()

    fileprivate lazy var stack:GPStackView = {
        let s = GPStackView(arrangedSubviews: [ self.name, self.icon])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    var exists:Bool = false
    
    override func awakeFromNib() {
        if !exists {
            exists = true
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 5
            self.contentView.addSubview(stack)
            NSLayoutConstraint.activate(stack.getConstraintsOfView(to: contentView, withInsets: UIEdgeInsets(top: 20, left: 20, bottom: -20, right: -20)))
            NSLayoutConstraint.activate([
                name.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.25),
                icon.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.75),
                icon.centerXAnchor.constraint(equalTo: stack.centerXAnchor),
                name.centerXAnchor.constraint(equalTo: stack.centerXAnchor)
                ])
            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dothis)))
        }
    }
    
    
    func dothis() {
        print("unk")
    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

class SettingsView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
    
    var stack:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        return s
    }()
    
    var title:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProBold, withSize: 25)
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        l.textColor = UIColor.darkGray
        l.backgroundColor = .clear
        l.text = "SETTINGS"
        return l
    }()
    
    var cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(SettingCell.self, forCellWithReuseIdentifier: "sc")
        cv.backgroundColor = .clear
        return cv
    }()
    
    var layerColors:[CGColor] {
        set {
            if let laya = self.layer as? CAGradientLayer {
                laya.colors = newValue
                laya.locations = [0.0, 1.0]
            }
        }
        get {
            return [ UIColor(rgb: 0x82D15C).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        }
    }


    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    let space:UIView = UIView()
    func phaseTwo() {
        
        if let laya = self.layer as? CAGradientLayer {
            laya.colors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
            laya.locations = [0.0, 1.20]
        }
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        addSubview(stack)
        NSLayoutConstraint.activate(stack.getConstraintsOfView(to: self))
        stack.addArrangedSubview(space)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(cv)
        NSLayoutConstraint.activate([
            space.heightAnchor.constraint(equalToConstant: 40)
            ])

            self.cv.delegate = self
            self.cv.dataSource = self
            
 

    }
    
    
}


extension SettingsView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    //data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GPModel.sharedInstance.settingInfo.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sc", for: indexPath) as! SettingCell
        cell.awakeFromNib()
        let s = GPModel.sharedInstance.settingInfo[indexPath.item]
        cell.name.text = s.name
        cell.icon.setFAIcon(icon: s.icon, iconSize: 30)
        return cell
    }
    
    //delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}
