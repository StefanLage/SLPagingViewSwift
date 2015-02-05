//
//  PagingViewController.swift
//  TwitterLike
//
//  Created by Retso Huang on 2/5/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

class PagingViewController: SLPagingViewSwift {

  override func viewDidLoad() {
    super.viewDidLoad()
    let brownViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BrownViewController") as UIViewController
    let purpleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PurpleViewController") as UIViewController
    self.addViewControllers([brownViewController, purpleViewController])
    self.pagingViewMovingRedefine  = {
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
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

}
