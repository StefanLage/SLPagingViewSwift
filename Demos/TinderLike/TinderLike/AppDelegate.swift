//
//  AppDelegate.swift
//  TinderLike
//
//  Created by Stefan Lage on 10/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nav: UINavigationController?
    var controller: SLPagingViewSwift?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        var orange = UIColor(red: 255/255, green: 69.0/255, blue: 0.0/255, alpha: 1.0)
        var gray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
        
        var ctr1 = UIViewController()
        ctr1.title = "Ctr1"
        ctr1.view.backgroundColor = orange
        var ctr2 = UIViewController()
        ctr2.title = "Ctr2"
        ctr2.view.backgroundColor = UIColor.yellowColor()
        var ctr3 = UIViewController()
        ctr3.title = "Ctr3"
        ctr3.view.backgroundColor = gray
        
        var img1 = UIImage(named: "gear")
        img1 = img1?.imageWithRenderingMode(.AlwaysTemplate)
        var img2 = UIImage(named: "profile")
        img2 = img2?.imageWithRenderingMode(.AlwaysTemplate)
        var img3 = UIImage(named: "chat")
        img3 = img3?.imageWithRenderingMode(.AlwaysTemplate)
        
        
        var items = [UIImageView(image: img1), UIImageView(image: img2), UIImageView(image: img3)]
        var controllers = [ctr1, ctr2, ctr3]
        controller = SLPagingViewSwift(items: items, controllers: controllers, showPageControl: false)
        
        controller?.pagingViewMoving = ({ subviews in
            for v in subviews {
                var lbl = v as UIImageView
                var c = gray
                
                if(lbl.frame.origin.x > 45 && lbl.frame.origin.x < 145) {
                    c = self.gradient(Double(lbl.frame.origin.x), topX: Double(46), bottomX: Double(144), initC: orange, goal: gray)
                }
                else if (lbl.frame.origin.x > 145 && lbl.frame.origin.x < 245) {
                    c = self.gradient(Double(lbl.frame.origin.x), topX: Double(146), bottomX: Double(244), initC: gray, goal: orange)
                }
                else if(lbl.frame.origin.x == 145){
                    c = orange
                }
                lbl.tintColor = c
            }
        })
        
        self.nav = UINavigationController(rootViewController: self.controller!)
        self.window?.rootViewController = self.nav
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func viewWithBackground(color: UIColor) -> UIView{
        var v = UIView()
        v.backgroundColor = color
        return v
    }
    
    func gradient(percent: Double, topX: Double, bottomX: Double, initC: UIColor, goal: UIColor) -> UIColor{
        var t = (percent - bottomX) / (topX - bottomX)
        
        let cgInit = CGColorGetComponents(initC.CGColor)
        let cgGoal = CGColorGetComponents(goal.CGColor)
        
        
        var r = cgInit[0] + CGFloat(t) * (cgGoal[0] - cgInit[0])
        var g = cgInit[1] + CGFloat(t) * (cgGoal[1] - cgInit[1])
        var b = cgInit[2] + CGFloat(t) * (cgGoal[2] - cgInit[2])
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}

