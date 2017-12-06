//
//  ViewController.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import Font_Awesome_Swift
import NVActivityIndicatorView
import StoreKit

class MainController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, GPNewDataDelegate {
    
    
    var fade:UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        return v
    }()

    var done_button:GPLabel = {
        let l = GPLabel()
//        l.font = UIFont.init(customFont: .MavenProRegular, withSize: 40)
        l.textAlignment = .center
        l.backgroundColor = .clear
        l.isUserInteractionEnabled = false
//        l.text = "done"
        l.setFAIcon(icon: .FAChevronRight, iconSize: 35)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    
    let gpaLabel:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        g.textAlignment = .center
        return g
    }()
    
    let gpaBoxLabel:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 65)
        
        return g
    }()
    
    
    let sideMenuButton:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 65)
        g.setFAIcon(icon: .FAChevronLeft, iconSize: 20)
        g.isUserInteractionEnabled = true
        g.setFAColor(color: .darkGray)
        return g
    }()
    
    let space0:GPLabel = GPLabel()
    
    let infoLabel:GPLabel = {
        let g = GPLabel()
        g.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
        g.textAlignment = .center
        return g
    }()
    
    fileprivate var longPressGesture:UILongPressGestureRecognizer!
    fileprivate var longPressGestureClasses:UILongPressGestureRecognizer!
    
    let model:GPModel = GPModel.sharedInstance
    let viewModel:ViewModel = ViewModel()
    
    let flipView:GPFlipView = GPFlipView()
    let settings = SettingsView()
    let semester_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(semester_cell.self, forCellWithReuseIdentifier: "semester_cell")
        cv.register(CVHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.register(CVFooter.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        cv.backgroundColor = .clear
        return cv
    }()
    
    let class_cv:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.sectionFootersPinToVisibleBounds = true
        layout.sectionHeadersPinToVisibleBounds = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(class_cell.self, forCellWithReuseIdentifier: "class_cell")
        cv.register(CVHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: "header")
        cv.register(CVFooter.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionFooter", withReuseIdentifier: "footer")
        cv.layer.borderColor = UIColor.darkGray.cgColor
        cv.backgroundColor = .clear
        return cv
    }()

    fileprivate lazy var stack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.topStack, self.space0, self.flipView])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        //        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .vertical
        return s
    }()
    
    fileprivate lazy var topStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.sideMenuButton, self.labelStack, self.gpaBoxLabel])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        //        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .horizontal
        return s
    }()
    
    fileprivate lazy var labelStack:UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.gpaLabel, self.infoLabel])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.backgroundColor = .clear
        //        s.layerColors = [ UIColor(rgb: 0xFFFFFF).cgColor, UIColor(rgb: 0x11C2D3).cgColor ]
        s.axis = .vertical
        return s
    }()
    var is_editing:Bool = false
    var gpa_cons:[NSLayoutConstraint]!
    var stack_cons:[NSLayoutConstraint]!
    var top_stack_cons:[NSLayoutConstraint]!
    var label_stack_cons:[NSLayoutConstraint]!
    var cv_cons:[NSLayoutConstraint]!
    @objc func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.semester_cv.indexPathForItem(at: gesture.location(in: self.semester_cv)) else {
                break
            }
            semester_cv.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            semester_cv.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            semester_cv.endInteractiveMovement()
        default:
            semester_cv.cancelInteractiveMovement()
        }
    }
    @objc func handleLongGestureClasses(_ gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.class_cv.indexPathForItem(at: gesture.location(in: self.class_cv)) else {
                break
            }
            class_cv.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            class_cv.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            class_cv.endInteractiveMovement()
        default:
            class_cv.cancelInteractiveMovement()
        }
    }
    
    var maxv = MaxView(frame: UIScreen.main.bounds)
    override func viewDidLoad() {
        super.viewDidLoad()
        model.themeInfo = [
            ThemeModel(name: "classic blue", colors: getColors(at: 0)),
            ThemeModel(name: "galaxy gray", colors: getColors(at: 1)), //pro feature
            //        SettingModel(name: "Theme", icon: FAType.FACircleO), //pro feature
            ThemeModel(name: "bitchin blue", colors: getColors(at: 2)),
            ThemeModel(name: "rip rosegolden", colors: getColors(at: 3)),
            ThemeModel(name: "godly golden", colors: getColors(at: 4)),
            ThemeModel(name: "poppin purple", colors: getColors(at: 5)),]
        self.view = maxv
        infoLabel.textColor = UIColor.darkGray
        infoLabel.text = "SEMESTERS"
        infoLabel.backgroundColor = .clear
        space0.backgroundColor = .clear
        gpaLabel.text = "TOTAL GPA"
        gpaLabel.backgroundColor = .clear
        gpaLabel.textColor = UIColor.darkGray
        gpaBoxLabel.text = "0.00"
        gpaBoxLabel.textColor = UIColor.darkGray
        gpaBoxLabel.layer.cornerRadius = 12
        gpaBoxLabel.layer.masksToBounds = true
        sideMenuButton.layer.cornerRadius = 12
        sideMenuButton.layer.masksToBounds = true

        view.backgroundColor = .white
        view.addSubview(stack)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(_:)))
        longPressGestureClasses = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGestureClasses(_:)))
        self.semester_cv.addGestureRecognizer(longPressGesture)
        self.class_cv.addGestureRecognizer(longPressGestureClasses)
        
        label_stack_cons = [
            gpaLabel.heightAnchor.constraint(equalTo: labelStack.heightAnchor, multiplier: 0.5),
            infoLabel.heightAnchor.constraint(equalTo: labelStack.heightAnchor, multiplier: 0.5),
        ]
        
        top_stack_cons = [
            sideMenuButton.widthAnchor.constraint(equalTo: topStack.widthAnchor, multiplier: 0.1),
            labelStack.widthAnchor.constraint(equalTo: topStack.widthAnchor, multiplier: 0.5),
            gpaBoxLabel.widthAnchor.constraint(equalTo: topStack.widthAnchor, multiplier: 0.4),
            
        ]

        stack_cons = [
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            topStack.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.2),
            space0.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.05),
            flipView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.75)
        ]
        
        flipView.firstView.addSubview(semester_cv)
        flipView.secondView.addSubview(class_cv)
        

        

        cv_cons = [
            semester_cv.leftAnchor.constraint(equalTo: flipView.firstView.leftAnchor),
            semester_cv.rightAnchor.constraint(equalTo: flipView.firstView.rightAnchor),
            semester_cv.topAnchor.constraint(equalTo: flipView.firstView.topAnchor),
            semester_cv.bottomAnchor.constraint(equalTo: flipView.firstView.bottomAnchor),
            
            class_cv.leftAnchor.constraint(equalTo: flipView.secondView.leftAnchor),
            class_cv.rightAnchor.constraint(equalTo: flipView.secondView.rightAnchor),
            class_cv.topAnchor.constraint(equalTo: flipView.secondView.topAnchor),
            class_cv.bottomAnchor.constraint(equalTo: flipView.secondView.bottomAnchor),
        ]
        
        sideMenuButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.animateSettings)))
        self.view.addSubview(fade)
        fade.addSubview(done_button)
    

        fade.alpha = 0
        fade.addTarget(self, action: #selector(self.animateSettings), for: .touchUpInside)
        
        
        self.view.addSubview(settings)
        sw = settings.widthAnchor.constraint(equalToConstant: 150)
        sl = settings.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -200)
        NSLayoutConstraint.activate([
            done_button.leftAnchor.constraint(equalTo: fade.leftAnchor, constant: 50),
            done_button.centerYAnchor.constraint(equalTo: fade.centerYAnchor),
            done_button.widthAnchor.constraint(equalToConstant: 100),
            done_button.heightAnchor.constraint(equalToConstant: 100),
            
            settings.topAnchor.constraint(equalTo: view.topAnchor),
            settings.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sl,
            sw,
            fade.leftAnchor.constraint(equalTo: settings.rightAnchor),
            fade.topAnchor.constraint(equalTo: view.topAnchor),
            fade.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            fade.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        
        NSLayoutConstraint.activate(label_stack_cons)
        NSLayoutConstraint.activate(top_stack_cons)
        NSLayoutConstraint.activate(stack_cons)
        NSLayoutConstraint.activate(cv_cons)

        semester_cv.delegate = self
        semester_cv.dataSource = self
   


    }

    @objc func rotateIcon(yes:Bool) {
        var angle:CGFloat = 0
        if yes {
            angle = .pi
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.done_button.transform = CGAffineTransform(rotationAngle: angle)
        }, completion: nil)
    }

    @objc func animateSettings() {
        var position:CGFloat = -200
        
        if sl.constant == -200 {
            position = 0
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.sl.constant = position
            self.view.layoutIfNeeded()
            if position == 0 {
                self.fade.alpha = 1
            } else {
                self.fade.alpha = 0
            }
        }) { (true) in
            //completion
        }
    }
    var sw:NSLayoutConstraint!
    var sl:NSLayoutConstraint!
    
    func addSemester(title:String) {
        NSLayoutConstraint.deactivate(new_semester_cons)
        new_semester_view.removeFromSuperview()
        let new_semester = semester(name: title, gpa: "0.00", classes: [])
        model.semesters.append(new_semester)
        infoLabel.animate(toText: "\(String(describing: self.model.semesters.count)) SEMESTERS")
        semester_cv.reloadData()
        semester_cv.alpha = 1
    }
 
    func addClass(title: String, grade: String, hour: Int) {
        NSLayoutConstraint.deactivate(new_class_cons)
        new_class_view.removeFromSuperview()
        let new_class = semester_class(name: title, grade: grade, hours: hour, gpa: "0.00")
        if model.class_is_being_edited {
            model.semesters[model.selected_semester_index].classes[model.class_being_edited] = new_class
            model.class_is_being_edited = false
        } else {
            model.semesters[model.selected_semester_index].classes.append(new_class)
        }
        
        gpaBoxLabel.animate(toText: viewModel.calculate_semester_gpa())
        model.semesters[model.selected_semester_index].gpa = viewModel.calculate_semester_gpa()
        class_cv.reloadData()
        class_cv.alpha = 1
    }
    
    

    
    var new_semester_view:NewSemesterView = {
        let p = NewSemesterView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor.clear
        return p
    }()
    
    var iap_popup_view:IAPPopup = {
        let p = IAPPopup()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor.clear
        return p
    }()
    
    var new_class_view:NewClassView = {
        let p = NewClassView()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.backgroundColor = UIColor.clear
        return p
    }()
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == semester_cv {
            let temp = model.semesters.remove(at: sourceIndexPath.item)
            model.semesters.insert(temp, at: destinationIndexPath.item)

        } else {
            let temp = model.semesters[model.selected_semester_index].classes.remove(at: sourceIndexPath.item)
            model.semesters[model.selected_semester_index].classes.insert(temp, at: destinationIndexPath.item)

        }
    }
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
            return true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == semester_cv {
            cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } else {
            cell.transform = CGAffineTransform(scaleX: 1, y: 0.1)
        }

        cell.alpha = 0
        
        UIView.animate(withDuration: 0.65, delay: 0, usingSpringWithDamping: 25, initialSpringVelocity: 25, options: .curveEaseIn, animations: {
            cell.alpha = 1.0
            //cell.layer.transform = CATransform3DIdentity
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    var iap_popup_cons:[NSLayoutConstraint]!
    var new_semester_cons:[NSLayoutConstraint]!
    var new_class_cons:[NSLayoutConstraint]!
    //VMMV view logic or model logic or something
    @objc func add_semester() {
        if model.semesters.count >= 1 && GPModel.sharedInstance.userIsFreemium {
            //pop up to purchase pro edition
            //pro edition is $1.99. Almost nothing compared to the price of tuition but will make sure you get the most out of your tuition!
            show_iap_popup()
        } else {
            //user has purchased pro edition
            new_semester_cons = new_semester_view.getConstraintsOfView(to: flipView.firstView)
            new_semester_view.delegate = self
            
            self.flipView.firstView.addSubview(new_semester_view)
            NSLayoutConstraint.activate(new_semester_cons)
            new_semester_view.cv.reloadData()
            new_semester_view.load()
            semester_cv.alpha = 0
            //popup view asking for user input
            //pickerview with two columns.
            //SEMESTER - YEAR
            //-------------------
            //FALL        18
            //SPRING      20
            //...
            //NEXT button at the bottom.
            //flips around to class_cv, says: there are no classes in this semester box. tap the plus to add one.
            
            print("add semester")
        }

    }
    
    func show_iap_popup() {
        iap_popup_cons = iap_popup_view.getConstraintsOfView(to: flipView.firstView)
        iap_popup_view.delegate = self
        
        self.flipView.firstView.addSubview(iap_popup_view)
        NSLayoutConstraint.activate(iap_popup_cons)
        iap_popup_view.cv.reloadData()
//        iap_popup_view.load()
        semester_cv.alpha = 0
    }
    
    func restoreiap() {

        print("purchases restored")
    }
    
    
    func performInAppPurchase(yes:Bool) {
        semester_cv.alpha = 1
        let loading = NVActivityIndicatorView(frame: CGRect(x: view.frame.width/2 - 25, y: view.frame.height/2 - 25, width: 50, height: 50), type: .ballPulseSync, color: .white)
        view.addSubview(loading)
        loading.startAnimating()
            //charge user $1.99 - Ask user for touch id purchase $1.99 !!!!!!!DOPENESS!!!!!!!!!
            PurchaseManager.instance.purchaseDopeEdition { success in
                //dismiss spinner
                 loading.stopAnimating()
                if success {
                    //dopness achieved
                   
                    NSLayoutConstraint.deactivate(self.iap_popup_cons)
                    self.iap_popup_view.removeFromSuperview()
            
                } else {
                    
                    //tell user dopeness could not be achieved at this time #failed
                }
                
            }
    
    }
    
 
    
    func restoreInAppPurchase() {

    }
    
    @objc func cancel_removal() {
        is_editing = false
        semester_cv.reloadData()
        class_cv.reloadData()
    }
    
    @objc func remove_semester() {
        print("remove semester")
        is_editing = true
  
        semester_cv.reloadData()
        
    }
    
    func showAlpha() {
        semester_cv.alpha = 1
        class_cv.alpha = 1
    }
    
    func remove_selected_semester() {
        is_editing = false
        model.semesters.remove(at: index_semester_remove)
        gpaBoxLabel.animate(toText: viewModel.calculate_all_semester_gpa())
        infoLabel.animate(toText: "\(String(describing: self.model.semesters.count)) SEMESTERS")
        semester_cv.reloadData()
    }
    
    @objc func remove_class() {
        print("remove class")
        is_editing = true
        
        class_cv.reloadData()
    }
    
    func remove_selected_class() {
        is_editing = false
        model.semesters[model.selected_semester_index].classes.remove(at: index_class_remove)
        gpaBoxLabel.animate(toText: viewModel.calculate_semester_gpa())
        model.semesters[model.selected_semester_index].gpa = viewModel.calculate_semester_gpa()
        class_cv.reloadData()
       
    }
    
    @objc func add_class() {

        new_class_cons = new_class_view.getConstraintsOfView(to: flipView.secondView)
        new_class_view.delegate = self
        flipView.secondView.addSubview(new_class_view)
        NSLayoutConstraint.activate(new_class_cons)
        new_class_view.cv.reloadData()
        new_class_view.load()
        class_cv.alpha = 0
        //popup view asking for user input
        //textfield asking for class name
            //CLASS NAME
        //pickeview with twocolumns 
            //GRADE - CREDIT HOUR
            //---------------------
            //A+          4
            //B+          3
        //ADD button at the bottom
        //view fades new class cell pops in
        //GPA for semester updates. this is when I perform the logic of all classes adding up. do this for all semesters too.
        print("add class")
    }
    

    
    
    //cv datasource and delegate
    
    //dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == semester_cv {
            return model.semesters.count
        } else {
            return model.semesters[model.selected_semester_index].classes.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    var index_semester_remove:Int!
    var index_class_remove:Int!
    //delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == semester_cv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "semester_cell", for: indexPath) as! semester_cell
            cell.awakeFromNib()
            cell.name.text = model.semesters[indexPath.item].name
            cell.gpa.text = model.semesters[indexPath.item].gpa
            cell.gpa.font = UIFont.init(customFont: .MavenProBold, withSize: 35)
            cell.gpa.textColor = .white
            if is_editing {
                cell.gpa.setFAIcon(icon: FAType.FATrash, iconSize: 35)
                cell.gpa.setFAColor(color: UIColor.white)
                cell.gpa.isUserInteractionEnabled = true
                cell.name.text = "DELETE \(cell.name.text!)"
//                cell.gpa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(remove_selected_semester)))
            }

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "class_cell", for: indexPath) as! class_cell
            cell.awakeFromNib()
            let current_class = model.semesters[model.selected_semester_index].classes[indexPath.item]
            cell.name.text = current_class.name
            cell.grade.text = current_class.grade
            model.semesters[model.selected_semester_index].classes[indexPath.item].location = indexPath.item
            cell.hours.text = String(describing: current_class.hours!)
            cell.gpa.text = current_class.gpa
            
            cell.name.font = UIFont.init(customFont: .MavenProBold, withSize: 20)
            cell.name.textColor = .white
            if is_editing {
                cell.name.setFAIcon(icon: FAType.FATrash, iconSize: 25)
                cell.name.setFAColor(color: UIColor.white)
                cell.name.isUserInteractionEnabled = true
                
     
                cell.grade.text = ""
                cell.hours.text = "DELETE"
                cell.gpa.text = ""
                //                cell.gpa.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(remove_selected_semester)))
            }

            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == semester_cv {
            if is_editing {
                index_semester_remove = indexPath.item
                remove_selected_semester()
            } else {
                model.selected_semester_index = indexPath.item
                
                infoLabel.animate(toText: model.semesters[model.selected_semester_index].name)
                gpaBoxLabel.animate(toText: viewModel.calculate_semester_gpa())
                gpaLabel.animate(toText: "SEMESTER GPA")
                self.class_cv.alpha = 0
                flipView.switchViews {
                    UIView.animate(withDuration: 0.15, animations: {
                        self.class_cv.alpha = 1
                    })
                    if self.class_cv.delegate == nil {
                        self.class_cv.delegate = self
                        self.class_cv.dataSource = self
                    } else {
                        self.class_cv.reloadData()
                    }
                }
            }

        } else {
            if is_editing {
                index_class_remove = indexPath.item
                remove_selected_class()
            } else {
                //edit a class cell
                model.class_is_being_edited = true
                model.class_being_edited = indexPath.item
                model.class_object_to_edit = model.semesters[model.selected_semester_index].classes[indexPath.item]
                add_class()
            }

        }
    }

    
    //flow
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == semester_cv {
            let box_size = collectionView.frame.width/2 - 20
            return CGSize(width: box_size, height: box_size)
        } else {
            let box_size = collectionView.frame.width - 20
            return CGSize(width: box_size, height: box_size/3.5)
        }
    }
    var footer_minus_ref:UIButton!
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! CVHeader
            header.awakeFromNib()
            header.backBtn.addTarget(self, action: #selector(self.SwitchView), for: .touchUpInside)
            if collectionView == class_cv {
                return header
            }
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! CVFooter
            if collectionView == class_cv {
                footer.plus_button.addTarget(self, action: #selector(self.add_class), for: .touchUpInside)
                footer.minus_button.addTarget(self, action: #selector(self.remove_class), for: .touchUpInside)
            } else if collectionView == semester_cv {
                footer.plus_button.addTarget(self, action: #selector(self.add_semester), for: .touchUpInside)
                footer.minus_button.addTarget(self, action: #selector(self.remove_semester), for: .touchUpInside)

            }
            if is_editing {
                footer.cancel_button.addTarget(self, action: #selector(self.cancel_removal), for: .touchUpInside)
                footer.is_editing = true
            }
            footer.awakeFromNib()
            return footer
        default:
            break
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == class_cv {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    @objc func SwitchView() {
        infoLabel.animate(toText: "\(String(describing: self.model.semesters.count)) SEMESTERS")
        gpaBoxLabel.animate(toText: String(describing: viewModel.calculate_all_semester_gpa()))
        gpaLabel.animate(toText: "TOTAL GPA")
        self.semester_cv.alpha = 0
        flipView.switchViews {
            UIView.animate(withDuration: 0.15, animations: {
                self.semester_cv.alpha = 1
            }, completion: { finished in
                
            })
            self.semester_cv.reloadData()
            
        }
    }
    
    


    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        if collectionView == semester_cv {
//            return 10
//        } else {
//            return 20
//        }
//        return 10
//    }


}



