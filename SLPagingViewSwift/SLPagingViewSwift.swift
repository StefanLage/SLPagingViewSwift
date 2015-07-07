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

typealias SLPagingViewMoving = ((subviews: [UIView])-> ())
typealias SLPagingViewMovingRedefine = ((scrollView: UIScrollView, subviews: NSArray)-> ())
typealias SLPagingViewDidChanged = ((currentPage: Int)-> ())

class SLPagingViewSwift: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Public properties
    var views = [Int : UIView]()
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
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    private var navigationBarView: UIView   = UIView()
    private var navItems: [UIView]          = []
    private var needToShowPageControl: Bool = false
    private var isUserInteraction: Bool     = false
    private var indexSelected: Int          = 0
    
    // MARK: - Constructors
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
    }
    
    // MARK: - Constructors with items & views
    convenience init(items: [UIView], views: [UIView]) {
        self.init(items: items, views: views, showPageControl:false, navBarBackground:UIColor.whiteColor())
    }
    
    convenience init(items: [UIView], views: [UIView], showPageControl: Bool){
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
    init(items: [UIView], views: [UIView], showPageControl: Bool, navBarBackground: UIColor) {
        super.init(nibName: nil, bundle: nil)
        needToShowPageControl             = showPageControl
        navigationBarView.backgroundColor = navBarBackground
        isUserInteraction                 = true
        for (i, v) in enumerate(items) {
            let vSize: CGSize = (v as? UILabel)?._slpGetSize() ?? v.frame.size
            let originX       = (self.SCREENSIZE.width/2.0 - vSize.width/2.0) + CGFloat(i * 100)
            v.frame           = CGRectMake(originX, 8, vSize.width, vSize.height)
            v.tag             = i
            var tap           = UITapGestureRecognizer(target: self, action: "tapOnHeader:")
            v.addGestureRecognizer(tap)
            v.userInteractionEnabled = true
            self.navigationBarView.addSubview(v)
            self.navItems.append(v)
        }
        
        for (i, view) in enumerate(views) {
            view.tag = i
            self.views[i] = view
        }
    }
    
    // MARK: - Constructors with controllers
    convenience init(controllers: [UIViewController]){
        self.init(controllers: controllers, showPageControl: true, navBarBackground: UIColor.whiteColor())
    }
    
    convenience init(controllers: [UIViewController], showPageControl: Bool){
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
    convenience init(controllers: [UIViewController], showPageControl: Bool, navBarBackground: UIColor){
        var views = [UIView]()
        var items = [UILabel]()
        for ctr in controllers {
            let item  = UILabel()
            item.text = ctr.title
            views.append(ctr.view)
            items.append(item)
        }
        self.init(items: items, views: views, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }
    
    // MARK: - Constructors with items & controllers
    convenience init(items: [UIView], controllers: [UIViewController]){
        self.init(items: items, controllers: controllers, showPageControl: true, navBarBackground: UIColor.whiteColor())
    }
    convenience init(items: [UIView], controllers: [UIViewController], showPageControl: Bool){
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
    convenience init(items: [UIView], controllers: [UIViewController], showPageControl: Bool, navBarBackground: UIColor){
        var views = [UIView]()
        for ctr in controllers {
            views.append(ctr.view)
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
    func setCurrentIndex(index: Int, animated: Bool){
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
        if self.views.count > 0 {
            let width                   = SCREENSIZE.width * CGFloat(self.views.count)
            let height                  = self.view.frame.height
            self.scrollView.contentSize = CGSize(width: width, height: height)
            var i: Int                  = 0
            for (key, v) in self.views {
                let rect: CGRect = CGRectMake(self.SCREENSIZE.width * CGFloat(i), 0, self.SCREENSIZE.width, self.SCREENSIZE.height)
                v.frame          = rect
                self.scrollView.addSubview(v)
                i++
            }
        }
    }
    
    private func sendNewIndex(scrollView: UIScrollView){
        var xOffset      = Float(scrollView.contentOffset.x)
        var currentIndex = (Int(roundf(xOffset)) % (self.navigationBarView.subviews.count * Int(self.SCREENSIZE.width))) / Int(self.SCREENSIZE.width)
        if self.needToShowPageControl && self.pageControl.currentPage != currentIndex {
            self.pageControl.currentPage = currentIndex
            self.didChangedPage?(currentPage: currentIndex)
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
        if let key = recognizer.view?.tag, view = self.views[key] where self.isUserInteraction {
            self.scrollView.scrollRectToVisible(view.frame, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let distance = CGFloat(100 + self.navigationSideItemsStyle.rawValue)
        for (i, v) in enumerate(self.navItems) {
            let vSize    = v.frame.size
            let originX  = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: xOffset)
            v.frame      = CGRectMake(originX, 8, vSize.width, vSize.height)
        }
        self.pagingViewMovingRedefine?(scrollView: scrollView, subviews: self.navItems)
        self.pagingViewMoving?(subviews: self.navItems)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }
    
}

extension UILabel {
    func _slpGetSize() -> CGSize? {
        return (text as NSString?)?.sizeWithAttributes([NSFontAttributeName: font])
    }
}