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
    var controller: SLPagingViewSwift!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let orange = UIColor(red: 255/255, green: 69.0/255, blue: 0.0/255, alpha: 1.0)
        let orange = UIColor(red: 0/255, green: 0.0/255, blue: 255.0/255, alpha: 1.0)
        let gray = UIColor(red: 0.84, green: 0.84, blue: 0.84, alpha: 1.0)
        
        let ctr0 = VC0()
        ctr0.title = "Ctr0"
        ctr0.view.backgroundColor = UIColor.brown
        let ctr1 = VC1()
        ctr1.title = "Ctr1"
        ctr1.view.backgroundColor = orange
        let ctr2 = VC2()
        ctr2.title = "Ctr2"
        ctr2.view.backgroundColor = UIColor.yellow
        let ctr3 = VC3()
        ctr3.title = "Ctr3"
        ctr3.view.backgroundColor = gray
        
        var img0 = UIImage(named: "nav_back_left")
        img0 = img0?.withRenderingMode(.alwaysTemplate)
        var img1 = UIImage(named: "nav_back_left")
        img1 = img1?.withRenderingMode(.alwaysTemplate)
        var img2 = UIImage(named: "nav_back_left")
        img2 = img2?.withRenderingMode(.alwaysTemplate)
        var img3 = UIImage(named: "nav_back_left")
        img3 = img3?.withRenderingMode(.alwaysTemplate)
        
        var imgSelected0 = UIImage(named: "chat")
        imgSelected0 = imgSelected0?.withRenderingMode(.alwaysTemplate)
        var imgSelected1 = UIImage(named: "gear")
        imgSelected1 = imgSelected1?.withRenderingMode(.alwaysTemplate)
        var imgSelected2 = UIImage(named: "profile")
        imgSelected2 = imgSelected2?.withRenderingMode(.alwaysTemplate)
        var imgSelected3 = UIImage(named: "chat")
        imgSelected3 = imgSelected3?.withRenderingMode(.alwaysTemplate)
        
        
        let barItemsSelected = [UIImageView(image: imgSelected0), UIImageView(image: imgSelected1), UIImageView(image: imgSelected2), UIImageView(image: imgSelected3)]
        let barItems = [UIImageView(image: img0), UIImageView(image: img1), UIImageView(image: img2), UIImageView(image: img3)]
//        for v in barItems
//        {
//            AppDelegate.addLayer(view: v)
//        }
        
        let controllers = [ctr0, ctr1, ctr2, ctr3]
        controller = SLPagingViewSwift(barItems: barItems, barItemsSelected: barItemsSelected, controllers: controllers, showPageControl: false)
        controller.navigationSideItemsStyle = .slNavigationSideItemsStyleOnBounds
        controller.pagingViewMovingRedefine = (  { scrollView, subviews in
          
        })
        controller.pagingViewMoving = ({ subviews in
            
            if let navBarItems = subviews as? [NavBarHeader] {
                for navBarItem in navBarItems {
                    
                    let originX = CGFloat(navBarItem.frame.origin.x)

                    let distance = CGFloat( self.controller.navigationSideItemsStyle.rawValue)
                    
                    let vSize    = navBarItem.frame.size
                    let margin  = self.controller.getOriginX(vSize, idx: CGFloat(navBarItem.tag), distance: CGFloat(distance), xOffset: 0)-100
                    
                    
                    let screenCenter = CGFloat(UIScreen.main.bounds.width/2)
                    let scale = CGFloat(screenCenter-margin)
                    let xOnScale = CGFloat(abs(originX - screenCenter))
                    let alpha = xOnScale/scale
                    
                    if navBarItem.tag == 0
                    {
                        print("originX: \(originX) alpha: \(alpha) xOnScale: \(xOnScale) scale:\(scale) margin: \(margin)" )
                    }
                    
//                    let alpha = CGFloat(abs(originX - 145))/(145-45)
                    navBarItem.regularView.alpha = alpha
                    navBarItem.selectedView.alpha = 1.0 - alpha
                }
            }
        })
        
        self.nav = UINavigationController(rootViewController: self.controller)
        self.window?.rootViewController = self.nav
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        return true
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

    func viewWithBackground(_ color: UIColor) -> UIView{
        let v = UIView()
        v.backgroundColor = color
        return v
    }
    
    func gradient(_ percent: Double, topX: Double, bottomX: Double, initC: UIColor, goal: UIColor) -> UIColor{
        let t = (percent - bottomX) / (topX - bottomX)
        
        let cgInit = initC.cgColor.components!
        let cgGoal = goal.cgColor.components!
        
        
        let r = cgInit[0] + CGFloat(t) * (cgGoal[0] - cgInit[0])
        let g = cgInit[1] + CGFloat(t) * (cgGoal[1] - cgInit[1])
        let b = cgInit[2] + CGFloat(t) * (cgGoal[2] - cgInit[2])
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
}

