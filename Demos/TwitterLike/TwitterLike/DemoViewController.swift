//
//  DemoTableViewController.swift
//  TwitterLike
//
//  Created by Retso Huang on 2/5/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
  
  // MARK: - Constants
  private let dataSource = ["Hello world!", "Shaqtin' a fool!", "YEAHHH!",
    "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
    "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
    "Hello world!", "Shaqtin' a fool!", "YEAHHH!",
    "Hello world!", "Shaqtin' a fool!", "YEAHHH!"]
  
  private var demoTableView: UITableView {
    let demoTableView = UITableView(frame: self.view.frame, style: .Plain)
    demoTableView.dataSource = self
    demoTableView.scrollsToTop = false
    return demoTableView
  }

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - User Control Events
  @IBAction func pushProgrammatically() {
    let font = UIFont(name: "Helvetica", size: 20)
    
    var navTitleLabel1 = UILabel()
    navTitleLabel1.text = "Home"
    navTitleLabel1.font = font
    navTitleLabel1.textColor = UIColor.whiteColor()
    var navTitleLabel2 = UILabel()
    navTitleLabel2.text = "Discover"
    navTitleLabel2.font = font
    navTitleLabel2.textColor = UIColor.whiteColor()
    var navTitleLabel3 = UILabel()
    navTitleLabel3.text = "Activity"
    navTitleLabel3.font = font
    navTitleLabel3.textColor = UIColor.whiteColor()
    
    let pagingController = SLPagingViewSwift(items: [navTitleLabel1, navTitleLabel2, navTitleLabel3], viewsOrControllers: [self.demoTableView, self.demoTableView, self.demoTableView], showPageControl: true, navBarBackground: UIColor(red: 0.33, green: 0.68, blue: 0.91, alpha: 1.0))

    pagingController.currentPageControlColor = UIColor.whiteColor()
    pagingController.tintPageControlColor = UIColor(white: 0.799, alpha: 1.0)
    pagingController.pagingViewMovingRedefine = {
      (scrollView: UIScrollView, subviews: [UIView]) -> Void in
      var i = 0
      var xOffset = scrollView.contentOffset.x
      for view in subviews {
        if let titleLabel = view as? UILabel {
          var alpha = CGFloat(0)
          
          if(titleLabel.frame.origin.x > 45 && titleLabel.frame.origin.x < 145) {
            alpha = 1.0 - (xOffset - (CGFloat(i)*320.0)) / 320.0
          }
          else if (titleLabel.frame.origin.x > 145 && titleLabel.frame.origin.x < 245) {
            alpha = (xOffset - (CGFloat(i)*320.0)) / 320.0 + 1.0
          }
          else if(titleLabel.frame.origin.x == 145){
            alpha = 1.0
          }
          titleLabel.alpha = CGFloat(alpha)
          i++
        }
      }
    }
    
    pagingController.didChangedPage = ({ currentIndex in
      println(currentIndex)
    })
    
    self.navigationController?.pushViewController(pagingController, animated: true)
    
  }

}

// MARK: - UITableViewDataSource
extension DemoViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
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
    cell!.imageView?.image = UIImage(named: "avatar_\(indexPath.row % 3)")
    cell!.textLabel!.text = self.dataSource[indexPath.row]
    
    return cell!
  }
}
