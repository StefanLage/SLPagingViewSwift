//
//  PagingView.swift
//  TestSwift
//
//  Created by Stefan Lage on 09/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

enum SLNavigationSideItemsStyle: Int {
    case SLNavigationSideItemsStyleOnBounds = 40
    case SLNavigationSideItemsStyleClose = 30
    case SLNavigationSideItemsStyleNormal = 20
    case SLNavigationSideItemsStyleFar = 10
    case SLNavigationSideItemsStyleDefault = 0
    case SLNavigationSideItemsStyleCloseToEachOne = -40
}

typealias SLPagingViewMoving = ((subviews: NSArray)-> ())
typealias SLPagingViewMovingRedefine = (scrollView: UIScrollView, subviews: [UIView]) -> Void
typealias SLPagingViewDidChanged = ((currentPage: NSInteger)-> ())

public class SLPagingViewSwift: UIViewController, UIScrollViewDelegate {
    
  // MARK: - Public properties
  weak var embedNavigationController: UINavigationController?
  var viewsOrContrllers = [Int: UIResponder]()
  var currentPageControlColor: UIColor?
  var tintPageControlColor: UIColor? {
    didSet {
      setupPagingProcess()
    }
  }
  var pagingViewMoving: SLPagingViewMoving?
  var pagingViewMovingRedefine: SLPagingViewMovingRedefine? {
    didSet {
      if let pagingViewMovingAnimation = self.pagingViewMovingRedefine {
        pagingViewMovingAnimation(scrollView: scrollView, subviews: self.navigationItems)
      }
    }
  }
  var didChangedPage: SLPagingViewDidChanged?
  var navigationSideItemsStyle: SLNavigationSideItemsStyle = .SLNavigationSideItemsStyleDefault
  public var needToShowPageControl: Bool = false {
    didSet {
      setupPagingProcess()
    }
  }
  
  // MARK: - Private properties
  private var scrollView: UIScrollView    = UIScrollView()
  private var pageControl: UIPageControl  = UIPageControl()
  private var navigationBarView: UIView   = UIView()
  private var navigationItems = [UIView]()
  private var isUserInteraction: Bool     = false
  private var indexSelected: NSInteger    = 0
  
  // MARK: - Constructors
  required public init(coder decoder: NSCoder) {
    super.init(coder: decoder)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    // Here you can init your properties
  }
  
  // MARK: - Constructors with controllers

  /*
  *  SLPagingViewController's constructor
  *
  *  Use controller's title as a navigation item
  *
  *  @param controllers view controllers containing sall subviews corresponding to each page
  *  @param navBarBackground navigation bar's background color
  *  @param showPageControl inform if we need to display the page control in the navigation bar
  *
  *  @return Instance of SLPagingViewController
  */
  convenience init(controllers: [UIViewController], showPageControl: Bool = true, navBarBackground: UIColor = UIColor.whiteColor()) {
    self.init(items: SLPagingViewSwift.navigationTitleLabels(controllers), viewsOrControllers: controllers, showPageControl:showPageControl, navBarBackground:navBarBackground)
  }
  
  // MARK: - Constructors with items & controllers
  
  /*
  *  SLPagingViewController's constructor
  *
  *  @param items should contain all subviews of the navigation bar
  *  @param navBarBackground navigation bar's background color
  *  @param controllers view controllers containing sall subviews corresponding to each page
  *  @param showPageControl inform if we need to display the page control in the navigation bar
  *
  *  @return Instance of SLPagingViewController
  */
  convenience init(items: [UIView], controllers: [UIViewController], showPageControl: Bool = true, navBarBackground: UIColor = UIColor.whiteColor()) {
    self.init(items: items, viewsOrControllers: controllers, showPageControl:showPageControl, navBarBackground:navBarBackground)
  }
  
  // MARK: - Constructors with items & views
  
  /*
  *  SLPagingViewController's constructor
  *
  *  @param items should contain all subviews of the navigation bar
  *  @param navBarBackground navigation bar's background color
  *  @param viewsOrControllers all view or view controller corresponding to each page
  *  @param showPageControl inform if we need to display the page control in the navigation bar
  *
  *  @return Instance of SLPagingViewController
  */
  init(items: [UIView], viewsOrControllers: [UIResponder], showPageControl: Bool = false, navBarBackground: UIColor = UIColor.whiteColor()) {
    super.init()
    needToShowPageControl = showPageControl
    navigationBarView.backgroundColor = navBarBackground
    isUserInteraction = true
    self.setup(items, viewsOrControllers: viewsOrControllers)
  }
  
  // MARK: - Public methods
  
  /**
  Add UIViewController(s) in to scrool View and automatically add navigation title as same as call init(controllers:showPageControl:navBarBackground:).
  
  :param: viewControllers view controllers containing sall subviews corresponding to each page
  */
  public func addViewControllers(viewControllers: [UIViewController]) {
    self.setup(SLPagingViewSwift.navigationTitleLabels(viewControllers), viewsOrControllers: viewControllers)
    self.setupPagingProcess()
    self.setCurrentIndex(self.indexSelected, animated: false)
  }
  
  /*
  *  Update the state of the UserInteraction on the navigation bar
  *
  *  @param activate state you want to set to UserInteraction
  */
  func updateUserInteractionOnNavigation(active: Bool){
    self.isUserInteraction = active
  }
  
  /*
  *  Set the current index page and scroll to its position
  *
  *  @param index of the wanted page
  *  @param animated animate the moving
  */
  func setCurrentIndex(index: NSInteger, animated: Bool){
    // Be sure we got an existing index
    if(index < 0 || index > self.navigationBarView.subviews.count - 1){
      var exc = NSException(name: "Index out of range", reason: "The index is out of range of subviews's countsd!", userInfo: nil)
      exc.raise()
    }
    self.indexSelected = index
    // Get the right position and update it
    var xOffset = CGFloat(index) * self.view.frame.width
    self.scrollView.setContentOffset(CGPointMake(xOffset, self.scrollView.contentOffset.y), animated: animated)
  }
  
  // MARK: - Life cycle
  override public func viewDidLoad() {
    super.viewDidLoad()
    if self.viewsOrContrllers.count > 0 {
      self.setupPagingProcess()
      self.setCurrentIndex(self.indexSelected, animated: false)
    }
  }
  
  public override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.childViewControllers
    for viewOrViewController in self.viewsOrContrllers.values {
      if let viewController  = viewOrViewController as? UIViewController {
        viewController.willMoveToParentViewController(self)
      }
    }
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    for viewOrViewController in self.viewsOrContrllers.values {
      if let viewController  = viewOrViewController as? UIViewController {
        viewController.didMoveToParentViewController(self)
      }
    }
    if let navigationController = self.embedNavigationController {
      navigationController.navigationBar.addSubview(self.navigationBarView)
    } else if let navigationController = self.navigationController {
      navigationController.navigationBar.addSubview(self.navigationBarView)
    }
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationBarView.removeFromSuperview()
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // MARK: - Internal methods
  private func setup(items: [UIView], viewsOrControllers: [UIResponder]) {
    var i = 0
    for item in items {
      var vSize: CGSize = item.isKindOfClass(UILabel.classForCoder()) ? self.getLabelSize(item as UILabel) : item.frame.size
      var originX       = (self.view.frame.width/2.0 - vSize.width/2.0) + CGFloat(i * 100)
      item.frame           = CGRectMake(originX, 8, vSize.width, vSize.height)
      item.tag             = i
      var tap           = UITapGestureRecognizer(target: self, action: "tapOnHeader:")
      item.addGestureRecognizer(tap)
      item.userInteractionEnabled = true
      self.navigationBarView.addSubview(item)
      self.navigationItems.append(item)
      i++
    }
    
    var index = 0
    for viewOrController in viewsOrControllers {
      if let view = viewOrController as? UIView {
        view.tag = index
        viewsOrContrllers[index] = view
      }
      if let viewController = viewOrController as? UIViewController {
        self.addChildViewController(viewController)
        viewController.view.tag = index
        viewsOrContrllers[index] = viewController
      }
      index++
    }
  }
  private class func navigationTitleLabels(viewControllers: [UIViewController]) -> [UILabel] {
    var titleLabels = [UILabel]()
    for viewController in viewControllers {
      var titleLabel  = UILabel()
      titleLabel.text = viewController.title
      titleLabels.append(titleLabel)
    }
    return titleLabels
  }
  private func setupPagingProcess() {
    self.scrollView                                = UIScrollView(frame: self.view.frame)
    self.scrollView.backgroundColor                = UIColor.clearColor()
    self.scrollView.pagingEnabled                  = true
    self.scrollView.showsHorizontalScrollIndicator = false
    self.scrollView.showsVerticalScrollIndicator   = false
    self.scrollView.delegate                       = self
    self.scrollView.bounces                        = false
    self.view.addSubview(self.scrollView)

    // Adds all views
    self.addViews()

    self.pageControl.removeFromSuperview()
    
    if(self.needToShowPageControl){
      // Make the page control
      self.pageControl               = UIPageControl(frame: CGRectMake(0, 35, self.view.frame.size.width, 0))
      self.pageControl.numberOfPages = self.navigationBarView.subviews.count
      self.pageControl.currentPage   = 0
      if self.currentPageControlColor != nil {
          self.pageControl.currentPageIndicatorTintColor = self.currentPageControlColor
      }
      if self.tintPageControlColor != nil {
          self.pageControl.pageIndicatorTintColor = self.tintPageControlColor
      }
      self.navigationBarView.addSubview(self.pageControl)
    }
    
  }
  
  // Loads all views
  private func addViews() {
    var index = 0
    for (key, viewOrViewController) in viewsOrContrllers {
      let width = self.view.frame.width * CGFloat(viewsOrContrllers.count)
      let height = self.view.frame.height
      self.scrollView.contentSize = CGSize(width: width, height: height)
      let viewFrame = CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
      if let view = viewOrViewController as? UIView {
        view.frame = viewFrame
        scrollView.addSubview(view)
      }
      if let viewController = viewOrViewController as? UIViewController {
        viewController.view.frame = viewFrame
        scrollView.addSubview(viewController.view)
      }
      index++
    }
  }
  
  private func getLabelSize(lbl: UILabel) -> CGSize{
      var txt = lbl.text!
      return txt.sizeWithAttributes([NSFontAttributeName: lbl.font])
  }
  
  private func sendNewIndex(scrollView: UIScrollView){
      var xOffset      = Float(scrollView.contentOffset.x)
      var currentIndex = (Int(roundf(xOffset)) % (self.navigationBarView.subviews.count * Int(self.view.frame.width))) / Int(self.view.frame.size.width)
      if(self.pageControl.currentPage != currentIndex) {
          self.pageControl.currentPage = currentIndex
          if self.didChangedPage != nil {
              self.didChangedPage!(currentPage: currentIndex)
          }
      }
  }
  
  func getOriginX(vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat{
      var result = self.view.frame.size.width / 2.0 - vSize.width/2.0
      result += (idx * distance)
      result -= xOffset / (self.view.frame.size.width / distance)
      return result
  }
  
  // Scroll to the view tapped
  func tapOnHeader(recognizer: UITapGestureRecognizer){
      if(self.isUserInteraction){
        if let key = recognizer.view?.tag {
          var viewToScroll: UIView!
          if let view = viewsOrContrllers[key] as? UIView {
            viewToScroll = view
          } else if let viewController = viewsOrContrllers[key] as? UIViewController {
            viewToScroll = viewController.view
          }
          self.scrollView.scrollRectToVisible(viewToScroll.frame, animated: true)
        }
      }
  }
    
}

// MARK: - UIScrollViewDelegate
extension SLPagingViewSwift: UIScrollViewDelegate {
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    var xOffset = scrollView.contentOffset.x
    var i       = 0
    for obj in self.navigationItems {
      var v:UIView = obj as UIView
      var distance = 100 + self.navigationSideItemsStyle.rawValue
      var vSize    = v.frame.size
      var originX  = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: CGFloat(xOffset))
      v.frame      = CGRectMake(originX, 8, vSize.width, vSize.height)
      i++
    }
    if let pagingViewMovingAnimation = self.pagingViewMovingRedefine {
      pagingViewMovingAnimation(scrollView: scrollView, subviews: self.navigationItems)
    }
    if let pagingViewMoving = self.pagingViewMoving {
      pagingViewMoving(subviews: self.navigationItems)
    }
  }
  
  public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    self.sendNewIndex(scrollView)
  }
  
  public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
    self.sendNewIndex(scrollView)
  }
}