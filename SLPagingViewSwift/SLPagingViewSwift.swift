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
typealias SLPagingViewMovingRedefine = ((scrollView: UIScrollView, subviews: NSArray)-> ())
typealias SLPagingViewDidChanged = ((currentPage: NSInteger)-> ())

class SLPagingViewSwift: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Public properties
    var viewControllers: NSDictionary = NSDictionary()
    var currentPageControlColor: UIColor?
    var tintPageControlColor: UIColor?
    var pagingViewMoving: SLPagingViewMoving?
    var pagingViewMovingRedefine: SLPagingViewMovingRedefine?
    var didChangedPage: SLPagingViewDidChanged?
    var navigationSideItemsStyle: SLNavigationSideItemsStyle = .SLNavigationSideItemsStyleDefault
    
    // MARK: - Private properties
    private var SCREENSIZE: CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    private var scrollView: UIScrollView    = UIScrollView()
    private var pageControl: UIPageControl  = UIPageControl()
    private var navigationBarView: UIView   = UIView()
    private var navItems: NSMutableArray    = NSMutableArray()
    private var needToShowPageControl: Bool = false
    private var isUserInteraction: Bool     = false
    private var indexSelected: NSInteger    = 0
    
    // MARK: - Constructors
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
    }
    
    // MARK: - Constructors with items & views
    convenience init(items: NSArray, views: NSArray) {
        self.init(items: items, views: views, showPageControl:false, navBarBackground:UIColor.whiteColor())
    }
    
    convenience init(items: NSArray, views: NSArray, showPageControl: Bool){
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:UIColor.whiteColor())
    }
    
    /*
    *  SLPagingViewController's constructor
    *
    *  @param items should contain all subviews of the navigation bar
    *  @param navBarBackground navigation bar's background color
    *  @param views all subviews corresponding to each page
    *  @param showPageControl inform if we need to display the page control in the navigation bar
    *
    *  @return Instance of SLPagingViewController
    */
    init(items: NSArray, views: NSArray, showPageControl: Bool, navBarBackground: UIColor){
        super.init()
        needToShowPageControl             = showPageControl
        navigationBarView.backgroundColor = navBarBackground
        isUserInteraction                 = true
        var i: Int                        = 0
        for item in items{
            if item.isKindOfClass(UIView.classForCoder()){
                var v             = item as UIView
                var vSize: CGSize = v.isKindOfClass(UILabel.classForCoder()) ? self.getLabelSize(v as UILabel) : v.frame.size
                var originX       = (self.SCREENSIZE.width/2.0 - vSize.width/2.0) + CGFloat(i * 100)
                v.frame           = CGRectMake(originX, 8, vSize.width, vSize.height)
                v.tag             = i
                var tap           = UITapGestureRecognizer(target: self, action: "tapOnHeader:")
                v.addGestureRecognizer(tap)
                v.userInteractionEnabled = true
                self.navigationBarView.addSubview(v)
                self.navItems.addObject(v)
                i++
            }
        }
        
        if (views.count > 0){
            var controllerKeys = NSMutableArray()
            i = 0
            for controller in views{
                if controller.isKindOfClass(UIView.classForCoder()){
                    var ctr = controller as UIView
                    ctr.tag = i
                    controllerKeys.addObject(NSNumber(integer: i))
                }
                else if controller.isKindOfClass(UIViewController.classForCoder()){
                    var ctr      = controller as UIViewController
                    ctr.view.tag = i
                    controllerKeys.addObject(NSNumber(integer: i))
                }
                i++
            }
            
            if controllerKeys.count == views.count {
               self.viewControllers = NSDictionary(objects: views, forKeys: controllerKeys)
            }
            else{
                var exc = NSException(name: "View Controllers error", reason: "Some objects in viewControllers are not kind of UIViewController!", userInfo: nil)
                exc.raise()
            }
        }
    }
    
    // MARK: - Constructors with controllers
    convenience init(controllers: NSArray){
        self.init(controllers: controllers, showPageControl: true, navBarBackground: UIColor.whiteColor())
    }
    
    convenience init(controllers: NSArray, showPageControl: Bool){
        self.init(controllers: controllers, showPageControl: true, navBarBackground: UIColor.whiteColor())
    }
    
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
    convenience init(controllers: NSArray, showPageControl: Bool, navBarBackground: UIColor){
        var views = NSMutableArray()
        var items = NSMutableArray()
        for ctr in controllers {
            if ctr.isKindOfClass(UIViewController.classForCoder()) {
                views.addObject(ctr)
                var item  = UILabel()
                item.text = ctr.title
                items.addObject(item)
            }
        }
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }
    
    // MARK: - Constructors with items & controllers
    convenience init(items: NSArray, controllers: NSArray){
        self.init(items: items, controllers: controllers, showPageControl: true, navBarBackground: UIColor.whiteColor())
    }
    convenience init(items: NSArray, controllers: NSArray, showPageControl: Bool){
        self.init(items: items, controllers: controllers, showPageControl: showPageControl, navBarBackground: UIColor.whiteColor())
    }
    
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
    convenience init(items: NSArray, controllers: NSArray, showPageControl: Bool, navBarBackground: UIColor){
        var views = NSMutableArray()
        for ctr in controllers {
            if ctr.isKindOfClass(UIViewController.classForCoder()) {
                views.addObject(ctr.valueForKey("view")!)
            }
        }
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupPagingProcess()
        self.setCurrentIndex(self.indexSelected, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBarView.frame = CGRectMake(0, 0, self.SCREENSIZE.width, 44)
    }
    
    // MARK: - Public methods
    
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
        if(index < 0 || index > self.navigationBarView.subviews.count-1){
            var exc = NSException(name: "Index out of range", reason: "The index is out of range of subviews's countsd!", userInfo: nil)
            exc.raise()
        }
        self.indexSelected = index
        // Get the right position and update it
        var xOffset = CGFloat(index) * self.SCREENSIZE.width
        self.scrollView.setContentOffset(CGPointMake(xOffset, self.scrollView.contentOffset.y), animated: animated)
    }
    
    // MARK: - Internal methods
    private func setupPagingProcess() {
        var frame: CGRect                              = CGRectMake(0, 0, SCREENSIZE.width, self.view.frame.height)

        self.scrollView                                = UIScrollView(frame: frame)
        self.scrollView.backgroundColor                = UIColor.clearColor()
        self.scrollView.pagingEnabled                  = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator   = false
        self.scrollView.delegate                       = self
        self.scrollView.bounces                        = false
        self.scrollView.contentInset                   = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        
        self.view.addSubview(self.scrollView)
        
        // Adds all views
        self.addViews()
        
        if(self.needToShowPageControl){
            // Make the page control
            self.pageControl               = UIPageControl(frame: CGRectMake(0, 35, 0, 0))
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
        
        self.navigationController?.navigationBar.addSubview(self.navigationBarView)
        
    }
    
    // Loads all views
    private func addViews() {
        if self.viewControllers.count > 0 {
            let width                   = SCREENSIZE.width * CGFloat(self.viewControllers.count)
            let height                  = self.view.frame.height
            self.scrollView.contentSize = CGSize(width: width, height: height)
            
            /**
            var i: Int                  = 0
            self.viewControllers.enumerateKeysAndObjectsUsingBlock({ key, obj, stop in
            var rect: CGRect = CGRectMake(self.SCREENSIZE.width * CGFloat(i), 0, self.SCREENSIZE.width, self.SCREENSIZE.height)
            var v            = obj as UIView
            v.frame          = rect
            self.scrollView.addSubview(v)
            i++
            })
            **/
            
            for j in 0...self.viewControllers.count-1 {
                var view = self.viewControllers.objectForKey(NSNumber(integer: j)) as UIView
                var rect: CGRect = CGRectMake(self.SCREENSIZE.width * CGFloat(j), 0, self.SCREENSIZE.width, self.SCREENSIZE.height)
                var v            = view as UIView
                v.frame          = rect
                self.scrollView.addSubview(v)
            }
        }
    }
    
    private func getLabelSize(lbl: UILabel) -> CGSize{
        var txt = lbl.text!
        return txt.sizeWithAttributes([NSFontAttributeName: lbl.font])
    }
    
    private func sendNewIndex(scrollView: UIScrollView){
        var xOffset      = Float(scrollView.contentOffset.x)
        var currentIndex = (Int(roundf(xOffset)) % (self.navigationBarView.subviews.count * Int(self.SCREENSIZE.width))) / Int(self.SCREENSIZE.width)
        if(self.pageControl.currentPage != currentIndex) {
            self.pageControl.currentPage = currentIndex
            if self.didChangedPage != nil {
                self.didChangedPage!(currentPage: currentIndex)
            }
        }
    }
    
    func getOriginX(vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat{
        var result = self.SCREENSIZE.width / 2.0 - vSize.width/2.0
        result += (idx * distance)
        result -= xOffset / (self.SCREENSIZE.width / distance)
        return result
    }
    
    // Scroll to the view tapped
    func tapOnHeader(recognizer: UITapGestureRecognizer){
        if(self.isUserInteraction){
            var key  = recognizer.view?.tag
            var view = self.viewControllers.objectForKey(NSNumber(integer: key!)) as UIView
            self.scrollView.scrollRectToVisible(view.frame, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var xOffset = scrollView.contentOffset.x
        var i       = 0
        for obj in self.navItems {
            var v:UIView = obj as UIView
            var distance = 100 + self.navigationSideItemsStyle.rawValue
            var vSize    = v.frame.size
            var originX  = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: CGFloat(xOffset))
            v.frame      = CGRectMake(originX, 8, vSize.width, vSize.height)
            i++
        }
        if (self.pagingViewMovingRedefine != nil) {
            self.pagingViewMovingRedefine!(scrollView: scrollView, subviews: self.navItems)
        }
        if (self.pagingViewMoving != nil) {
            self.pagingViewMoving!(subviews: self.navItems)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }
    
}