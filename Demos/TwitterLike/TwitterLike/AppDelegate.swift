//
//  AppDelegate.swift
//  TwitterLike
//
//  Created by Stefan Lage on 10/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var nav: UINavigationController!
    var controller: SLPagingViewSwift!
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let navTitleLabel1 = UILabel()
        navTitleLabel1.text = "Home"
        navTitleLabel1.font = UIFont(name: "Helvetica", size: 20)
        navTitleLabel1.textColor = UIColor.white
        let navTitleLabel2 = UILabel()
        navTitleLabel2.text = "Discover"
        navTitleLabel2.font = UIFont(name: "Helvetica", size: 20)
        navTitleLabel2.textColor = UIColor.white
        let navTitleLabel3 = UILabel()
        navTitleLabel3.text = "Activity"
        navTitleLabel3.font = UIFont(name: "Helvetica", size: 20)
        navTitleLabel3.textColor = UIColor.white
        
        let barItems = [navTitleLabel1, navTitleLabel2, navTitleLabel3]
        let vcs = [TableViewController(style: .plain), TableViewController(style: .plain), TableViewController(style: .plain)]
        
        controller = SLPagingViewSwift(barItems: barItems, views: vcs, showPageControl: true, navBarBackground:UIColor(red: 0.33, green: 0.68, blue: 0.91, alpha: 1.0))
        
        controller.currentPageControlColor = UIColor.white
        controller.tintPageControlColor = UIColor(white: 0.799, alpha: 1.0)
        controller.pagingViewMovingRedefine = ({ scrollView, subviews in
            var i = 0
            let xOffset = scrollView.contentOffset.x
            if let lbls = subviews as? [UILabel] {
                for lbl in lbls {
                    var alpha : CGFloat = 0

                    if(lbl.frame.origin.x > 45 && lbl.frame.origin.x < 145) {
                        alpha = 1.0 - (xOffset - (CGFloat(i)*320.0)) / 320.0
                    }
                    else if (lbl.frame.origin.x > 145 && lbl.frame.origin.x < 245) {
                        alpha = (xOffset - (CGFloat(i)*320.0)) / 320.0 + 1.0
                    }
                    else if(lbl.frame.origin.x == 145){
                        alpha = 1.0
                    }
                    lbl.alpha = alpha
                    i += 1
                }
            }
        })
        
        controller.didChangedPage = ({ currentIndex in
            NSLog("\(currentIndex)")
        })
        
        
        self.nav = UINavigationController(rootViewController: self.controller)
        self.window?.rootViewController = self.nav
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

        
}















