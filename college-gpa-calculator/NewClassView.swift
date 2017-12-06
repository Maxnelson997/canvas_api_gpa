//
//  NewClassView.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/10/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//


import UIKit
import Font_Awesome_Swift



class NewClassView: UIView, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate {
    let s_grades:[String] = ["A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F"]
    let s_hours:[String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
  
    let model = GPModel.sharedInstance
    
    @objc func resignText() {
        title_box.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.moveTextField(inView: self, moveDistance: 60, up: false)
        type_pick.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.done_button.alpha = 0
            self.type_pick.alpha = 1
        })

    }
    

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.moveTextField(inView: self, moveDistance: 60, up: true)
        type_pick.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.done_button.alpha = 1
            self.type_pick.alpha = 0
        })

    }
    
    var selected_grade:String = "A"
    var selected_hour:String = "3"
    
    var delegate:GPNewDataDelegate!
    
    var location:Int!
    
    let cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(empty_cell.self, forCellWithReuseIdentifier: "empty_cell")
        cv.register(new_semester_header.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.register(new_semester_footer.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        
        cv.isScrollEnabled = false
        
        //        cv.backgroundColor = UIColor(rgb: 0x3A3A3A).withAlphaComponent(0.8)
        cv.backgroundColor = .clear
        cv.layer.cornerRadius = 12
        cv.layer.masksToBounds = true

        return cv
    }()
    var header_label:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProRegular, withSize: 18)
        l.textAlignment = .center
        l.backgroundColor = .clear
        return l
    }()
    
    var title_label:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProRegular, withSize: 18)
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.text = "NAME: "
        return l
    }()
    
    var done_button:GPLabel = {
        let l = GPLabel()
        l.font = UIFont.init(customFont: .MavenProRegular, withSize: 30)
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.isUserInteractionEnabled = false
        l.text = "DONE"
        return l
    }()
    
    var title_box:UITextField = {
        let l = UITextField()
        l.font = UIFont.init(customFont: .MavenProRegular, withSize: 18)
        l.placeholder = "class name"
        l.textColor = .darkGray
        l.layer.cornerRadius = 12
        l.layer.masksToBounds = true
        l.attributedPlaceholder = NSAttributedString(string: "CLASS NAME", attributes: [NSAttributedStringKey.foregroundColor:UIColor.black.withAlphaComponent(0.5), NSAttributedStringKey.font:UIFont.init(customFont: .MavenProRegular, withSize: 18)!])
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    

   
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "empty_cell", for: indexPath) as! empty_cell
        cell.awakeFromNib()
        cell.contentView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true
        if indexPath.item == 1 {
            //        cell.contentView.backgroundColor = UIColor(rgb: 0x3A3A3A).withAlphaComponent(0.8)
            
            cell.contentView.addSubview(type_pick)
            cell.contentView.addSubview(done_button)
            NSLayoutConstraint.activate(type_pick.getConstraintsOfView(to: cell.contentView))
          
            NSLayoutConstraint.activate([
                done_button.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                done_button.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
                done_button.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor),
                done_button.bottomAnchor.constraint(equalTo: cell.centerYAnchor, constant: 50),
                ])
        } else {
            cell.contentView.addSubview(title_label)
            cell.contentView.addSubview(title_box)


            NSLayoutConstraint.activate([
                
                title_label.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
                title_label.rightAnchor.constraint(equalTo: title_box.leftAnchor),
                title_label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                title_label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                
                title_box.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor, constant: -10),
                title_box.leftAnchor.constraint(equalTo: title_label.rightAnchor),
                title_box.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                
                

        
                
                title_label.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.3),
    
                
                ])
            

        }
        
        return cell
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "SEASON"
        }
        return "YEAR"
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            return CGSize(width: collectionView.frame.width - 40, height: collectionView.frame.height - 20 - 175)
        } else {
            return CGSize(width: collectionView.frame.width - 40, height: 50)
        }
    }
    
    init() {
        super.init(frame: .zero)
        phaseTwo()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        phaseTwo()
    }
    



    
    func phaseTwo() {

      
        
       
        addSubview(cv)
        
        //        NSLayoutConstraint.activate([
        //            cv.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
        //            cv.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
        //            cv.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
        //            cv.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
        //            ])
        done_button.translatesAutoresizingMaskIntoConstraints = false
        done_button.backgroundColor = type_pick.backgroundColor
        done_button.alpha = 0
        
        NSLayoutConstraint.activate(cv.getConstraintsOfView(to: self))
        cv.delegate = self
        cv.dataSource = self
        
        type_pick.delegate = self
        type_pick.dataSource = self
        
        title_box.delegate = self

        //popup view asking for user input
        //pickerview with two columns.
        //SEMESTER - YEAR
        //-------------------
        //FALL        18
        //SPRING      20
        //...
        //NEXT button at the bottom.
        //flips around to class_cv, says: there are no classes in this semester box. tap the plus to add one.
//        for v in self.subviews {
//            v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignText)))
//        }
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.resignText)))
        
        
    }
    
    func load() {
        
        title_box.text = ""
        var indexForGrade:Int = 1
        var indexForHour:Int = 2
        
        if model.class_is_being_edited {
            print(model.class_object_to_edit.grade)
            print(String(describing: model.class_object_to_edit.hours!))
            indexForGrade = s_grades.index(of: model.class_object_to_edit.grade)!
            indexForHour = s_hours.index(of: String(describing: model.class_object_to_edit.hours!))!
            
            title_box.animate(toText: model.class_object_to_edit.name)
        }
        
        type_pick.selectRow(indexForGrade, inComponent: 0, animated: true)
        type_pick.selectRow(indexForHour, inComponent: 1, animated: true)
        
        selected_grade = s_grades[indexForGrade]
        selected_hour = s_hours[indexForHour]
        
        header_label.text = "grade: \(selected_grade)   hour: \(selected_hour)"
    }
    
    fileprivate var type_pick:UIPickerView = {
        let s = UIPickerView()
        s.layer.cornerRadius = 12
        s.layer.masksToBounds = true
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return s_grades.count
        }
        //year pick
        return s_hours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        if component == 0 {
            selected_grade = s_grades[row]
        } else {
            selected_hour = s_hours[row]
        }
        header_label.text = "grade: \(selected_grade)   hour: \(selected_hour)"
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var titleData:String!
        if component == 0 {
            titleData = s_grades[row]
        } else {
            titleData = s_hours[row]
        }
        let myTitle = NSAttributedString(string: titleData!, attributes: [NSAttributedStringKey.font:UIFont.init(customFont: .MavenProRegular, withSize: 15)!,NSAttributedStringKey.foregroundColor:UIColor.black])
        return myTitle
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! new_semester_header
            
            
            header.addSubview(header_label)
            header.frame = CGRect(x: 20, y: 10, width: collectionView.frame.width - 40, height: 50)
            NSLayoutConstraint.activate(header_label.getConstraintsOfView(to: header))
            header.backgroundColor = UIColor.darkGray.withAlphaComponent(0.2)
            header.layer.cornerRadius = 12
            header.layer.masksToBounds = true
            
            
            return header
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! new_semester_footer
            //            footer.frame.size = CGSize(width: collectionView.frame.width - 40, height: 50)
            footer.frame = CGRect(x: 20, y: footer.frame.origin.y, width: collectionView.frame.width - 40, height: 50)
            footer.cancel_button.addTarget(self, action: #selector(self.cancel_class), for: .touchUpInside)
            footer.done_button.addTarget(self, action: #selector(self.add_class), for: .touchUpInside)
            footer.awakeFromNib()
            return footer
        default:
            break
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(scaleX: 1, y: 0.1)
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            cell.alpha = 1.0
            //cell.layer.transform = CATransform3DIdentity
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
    }
    @objc func cancel_class() {
        delegate.showAlpha()
        print("canceled adding class")
        self.removeFromSuperview()
        model.class_is_being_edited = false
    }
    
    @objc func add_class() {
        var title_text:String = ""
        if let text = title_box.text {
            title_text = text
        }
        
        if title_text.isEmpty {
            title_text = "new class"
        }
        delegate.addClass(title: title_text, grade: selected_grade, hour: Int((selected_hour as NSString).intValue))
        self.removeFromSuperview()
        print("added class to semester")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //popup view asking for user input
    //pickerview with two columns.
    //SEMESTER - YEAR
    //-------------------
    //FALL        18
    //SPRING      20
    //...
    //NEXT button at the bottom.
    //flips around to class_cv, says: there are no classes in this semester box. tap the plus to add one.
    
    
}
