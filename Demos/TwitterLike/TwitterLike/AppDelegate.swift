//
//  AppDelegate.swift
//  TwitterLike
//
//  Created by Stefan Lage on 10/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate, UITableViewDataSource {

    var window: UIWindow?
    var nav: UINavigationController!
    var controller: SLPagingViewSwift!
    var dataSource: [String]!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        self.dataSource = ["Hello world!", "Shaqtin' a fool!", "YEAHHH!",
            "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
            "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
            "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
            "Hello world!", "Shaqtin' a fool!", "YEAHHH!"]
        
        var navTitleLabel1 = UILabel()
        navTitleLabel1.text = "Home"
        navTitleLabel1.font = UIFont(name: "Helvetica", size: 20)
        navTitleLabel1.textColor = UIColor.whiteColor()
        var navTitleLabel2 = UILabel()
        navTitleLabel2.text = "Discover"
        navTitleLabel2.font = UIFont(name: "Helvetica", size: 20)
        navTitleLabel2.textColor = UIColor.whiteColor()
        var navTitleLabel3 = UILabel()
        navTitleLabel3.text = "Activity"
        navTitleLabel3.font = UIFont(name: "Helvetica", size: 20)
        navTitleLabel3.textColor = UIColor.whiteColor()
        
        controller = SLPagingViewSwift(items: [navTitleLabel1, navTitleLabel2, navTitleLabel3], views: [self.tableView(), self.tableView(), self.tableView()], showPageControl: true, navBarBackground: UIColor(red: 0.33, green: 0.68, blue: 0.91, alpha: 1.0))
        
        controller.currentPageControlColor = UIColor.whiteColor()
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
                    i++
                }
            }
        })
        
        controller.didChangedPage = ({ currentIndex in
            println(currentIndex)
        })
        
        
        self.nav = UINavigationController(rootViewController: self.controller)
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

    func tableView() -> UITableView {
        var frame = CGRectMake(0, 0, 320, 568)
        frame.size.height -= 44
        var tableView = UITableView(frame: frame, style: .Plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.scrollsToTop = false
        return tableView
    }
    
    // MARK: - UITableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cellIdentifier = "cellIdentifier"
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.numberOfLines = 0
        }
        cell!.imageView?.image = UIImage(named: "avatar_\(indexPath.row % 3).png")
        cell!.textLabel!.text = self.dataSource[indexPath.row]
        
        return cell!
    }
    
}

