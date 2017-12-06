 //
//  AppDelegate.swift
//  college-gpa-calculator
//
//  Created by Max Nelson on 8/7/17.
//  Copyright © 2017 Max Nelson. All rights reserved.
//

import UIKit
import CoreData
import Font_Awesome_Swift
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let model = GPModel.sharedInstance
    let viewModel = ViewModel()
    var nav:UINavigationController!
    var main_controller:MainController!
    
    func BarButton(withIcon: FAType, withSelector: Selector) -> UIBarButtonItem {
        let b = UIButton(type: .custom)
        b.setFATitleColor(color: .darkGray) 
        b.setFAIcon(icon: withIcon, iconSize: 30, forState: UIControlState.normal)
        b.contentHorizontalAlignment = .left
        b.frame = CGRect(x: 0, y: 0, width: 30, height: 0)
        b.addTarget(main_controller, action: withSelector, for: .touchUpInside)
        return UIBarButtonItem(customView: b)
    }
//    var maxv:MaxView!
//    func addBG() {
//        maxv = MaxView(frame: UIScreen.main.bounds)
//        maxv.removeFromSuperview()
//        window?.insertSubview(maxv, at: 0)
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        main_controller = MainController()
//        nav = UINavigationController(rootViewController: main_controller)
//            main_controller.navigationItem.leftBarButtonItem = BarButton(withIcon: FAType.FABars, withSelector: #selector(main_controller.animateSettings))
        model.get_semesters_coredata(completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                           self.main_controller.gpaBoxLabel.animate(toText: self.viewModel.calculate_all_semester_gpa())
            })
            
        })

        
//        main_nav = UINavigationController(rootViewController: main_controller)
//        main_nav.tabBarItem.title = "GPA"
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = main_controller
        
//        maxv = MaxView(frame: UIScreen.main.bounds)
//        window?.insertSubview(maxv, at: 0)
//
        PurchaseManager.instance.fetchProducts()
//        for family: String in UIFont.familyNames
//        {
//            print("--\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("---- \(names)")
//            }
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        model.save_semesters_coredata()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "college_gpa_calculator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

