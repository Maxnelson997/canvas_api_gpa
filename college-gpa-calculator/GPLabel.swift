//
//  GPLabel.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit

class GPLabel: UILabel {

    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        phaseTwo()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func phaseTwo()
    {
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 12
        self.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
        self.textColor = .white
        self.adjustsFontSizeToFitWidth = true
        self.adjustsFontForContentSizeCategory = true
        self.font = UIFont.init(customFont: .MavenProRegular, withSize: 18)
        
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)))
    }

    

}
