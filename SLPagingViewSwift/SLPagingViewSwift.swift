//
//  PagingView.swift
//  TestSwift
//
//  Created by Stefan Lage on 09/01/15.
//  Copyright (c) 2015 Stefan Lage. All rights reserved.
//

import UIKit

public enum SLNavigationSideItemsStyle: Int {
    case slNavigationSideItemsStyleOnEdge = 60
    case slNavigationSideItemsStyleOnBounds = 40
    case slNavigationSideItemsStyleClose = 30
    case slNavigationSideItemsStyleNormal = 20
    case slNavigationSideItemsStyleFar = 10
    case slNavigationSideItemsStyleDefault = 0
    case slNavigationSideItemsStyleCloseToEachOne = -40
}

public typealias SLPagingViewMoving = ((_ subviews: [UIView])-> ())
public typealias SLPagingViewMovingRedefine = ((_ scrollView: UIScrollView, _ subviews: NSArray)-> ())
public typealias SLPagingViewDidChanged = ((_ currentPage: Int)-> ())

open class NavBarHeader: UIView {
    
    open var regularView:UIView
    open var selectedView:UIView
    
    init( regularView:UIView, selectedView:UIView) {
        
        self.regularView = regularView
        self.selectedView = selectedView
        super.init(frame: CGRect.zero)//(x: 0, y: 0, width: 0, height: 0))
        
        self.addSubview(self.selectedView)
        self.addSubview(self.regularView)
        
        //self.selectedView.backgroundColor = UIColor.red
        //self.regularView.backgroundColor = UIColor.brown
        //
        //self.backgroundColor = UIColor.cyan
        
        self.frame.size = self.recomandedSize()
        
        //        setSelected(perc: 0)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setSelected(perc:CGFloat) -> Void {
        
        self.regularView.alpha = 1 - perc
        self.selectedView.alpha = perc
    }
    func recomandedSize() -> CGSize {
        let size = CGSize(width: max(self.regularView.frame.size.width,self.selectedView.frame.size.width),
                          height:max(self.regularView.frame.size.height,self.selectedView.frame.size.height))
        
        return size;
    }
    //    open override func layoutIfNeeded() {
    //        self.frame.size = self.recomandedSize()
    //        self.frame.origin = CGPoint(x:0, y:0)
    //    }
    override open func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.regularView.frame.origin = CGPoint(x: (self.frame.size.width - self.regularView.frame.size.width)/2,
                                                y: (self.frame.size.height - self.regularView.frame.size.height)/2)
        
        self.selectedView.frame.origin = CGPoint(x: (self.frame.size.width - selectedView.frame.size.width)/2,
                                                 y: (self.frame.size.height - selectedView.frame.size.height)/2)
    }
}
open class SLPagingViewSwift: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Public properties
    var viewControllers = [Int : UIViewController]()
    open var currentPageControlColor: UIColor?
    open var tintPageControlColor: UIColor?
    open var pagingViewMoving: SLPagingViewMoving?
    open var pagingViewMovingRedefine: SLPagingViewMovingRedefine?
    open var didChangedPage: SLPagingViewDidChanged?
    open var navigationSideItemsStyle: SLNavigationSideItemsStyle = .slNavigationSideItemsStyleDefault
    
    // MARK: - Private properties
    fileprivate var SCREENSIZE: CGSize {
        return UIScreen.main.bounds.size
    }
    fileprivate var scrollView: UIScrollView!
    fileprivate var pageControl: UIPageControl!
    fileprivate var navigationBarView: UIView   = UIView()
    fileprivate var navItems: [NavBarHeader]          = []
    fileprivate var needToShowPageControl: Bool = false
    fileprivate var isUserInteraction: Bool     = false
    fileprivate var indexSelected: Int          = 1
    fileprivate var nextIndex:Int               = -1
    
    // MARK: - Constructors
    public required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Here you can init your properties
    }
    
    // MARK: - Constructors with items & views
    public convenience init(barItems: [UIView], barItemsSelected: [UIView], viewControllers: [UIViewController]) {
        self.init(barItems: barItems, barItemsSelected: barItemsSelected, views: viewControllers, showPageControl:false, navBarBackground:UIColor.white)
    }
    
    public convenience init(barItems: [UIView], barItemsSelected: [UIView], viewControllers: [UIViewController], showPageControl: Bool){
        self.init(barItems: barItems, barItemsSelected: barItemsSelected, views: viewControllers, showPageControl:showPageControl, navBarBackground:UIColor.white)
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
    
    public init(barItems: [UIView], barItemsSelected: [UIView], views: [UIViewController], showPageControl: Bool, navBarBackground: UIColor) {
        super.init(nibName: nil, bundle: nil)
        
        needToShowPageControl             = showPageControl
        navigationBarView.backgroundColor = navBarBackground
        UINavigationBar.appearance().barTintColor = navBarBackground
        isUserInteraction                 = true
        
        for (i, vRegular) in barItems.enumerated() {
            let vSelected = barItemsSelected[i]
            let navBarHeader = NavBarHeader(regularView: vRegular, selectedView: vSelected)
            
            let vSize: CGSize = (navBarHeader as? UILabel)?._slpGetSize() ?? navBarHeader.frame.size
            let originX       = (self.SCREENSIZE.width/2.0 - vSize.width/2.0) + CGFloat(i * 100)
            navBarHeader.frame           = CGRect(x: originX, y: 8, width: vSize.width, height: vSize.height)
            //            for v in navBarHeader.subviews {
            //
            //                for layer in v.layer.sublayers! {
            //                    layer.bounds    = CGRect(x: CGFloat(v.frame.origin.x), y: CGFloat(v.frame.origin.y), width: navBarHeader.frame.size.width, height: navBarHeader.frame.size.height)
            //                }
            //            }
            navBarHeader.tag             = i
            let tap           = UITapGestureRecognizer(target: self, action: #selector(SLPagingViewSwift.tapOnHeader(_:)))
            navBarHeader.addGestureRecognizer(tap)
            navBarHeader.isUserInteractionEnabled = true
            self.navigationBarView.addSubview(navBarHeader)
            self.navItems.append(navBarHeader)
        }
        
        for (i, view) in views.enumerated() {
            view.view.tag = i
            self.viewControllers[i] = view
        }
    }
    
    // MARK: - Constructors with controllers
    public convenience init(controllers: [UIViewController]){
        self.init(viewControllers: controllers, showPageControl: true, navBarBackground: UIColor.white)
    }
    
    public convenience init(controllers: [UIViewController], showPageControl: Bool){
        self.init(viewControllers: controllers, showPageControl: true, navBarBackground: UIColor.white)
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
    public convenience init(viewControllers: [UIViewController], showPageControl: Bool, navBarBackground: UIColor){
        var views = [UIView]()
        var items = [UILabel]()
        var itemsSel = [UILabel]()
        for ctr in viewControllers {
            let item  = UILabel()
            let itemSel  = UILabel()
            item.text = ctr.title
            itemSel.text = ctr.title
            views.append(ctr.view)
            items.append(item)
            itemsSel.append(itemSel)
        }
        self.init(barItems: items, barItemsSelected: itemsSel, views: viewControllers, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }
    
    // MARK: - Constructors with items & controllers
    public convenience init(barItems: [UIView], barItemsSelected: [UIView], controllers: [UIViewController]){
        self.init(barItems: barItems, barItemsSelected:barItemsSelected, controllers: controllers, showPageControl: true, navBarBackground: UIColor.white)
    }
    public convenience init(barItems: [UIView], barItemsSelected: [UIView], controllers: [UIViewController], showPageControl: Bool){
        self.init(barItems: barItems, barItemsSelected: barItemsSelected, controllers: controllers, showPageControl: showPageControl, navBarBackground: UIColor.white)
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
    public convenience init(barItems: [UIView], barItemsSelected: [UIView], controllers: [UIViewController], showPageControl: Bool, navBarBackground: UIColor){
        var views = [UIView]()
        for ctr in controllers {
            views.append(ctr.view)
        }
        self.init(barItems: barItems, barItemsSelected: barItemsSelected, views: controllers, showPageControl:showPageControl, navBarBackground:navBarBackground)
    }
    
    // MARK: - Life cycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupPagingProcess()
        self.navigationBarView.frame = CGRect(x: 0, y: 0, width: self.SCREENSIZE.width, height: 44)//////////////////
        self.setCurrentIndex(self.indexSelected, animated: false)
        self.view.backgroundColor = UIColor.white
    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.navigationBarView.frame = CGRect(x: 0, y: 0, width: self.SCREENSIZE.width, height: 44)
    }
    
    // MARK: - Public methods
    
    /*
     *  Update the state of the UserInteraction on the navigation bar
     *
     *  @param activate state you want to set to UserInteraction
     */
    open func updateUserInteractionOnNavigation(_ active: Bool){
        self.isUserInteraction = active
    }
    
    /*
     *  Set the current index page and scroll to its position
     *
     *  @param index of the wanted page
     *  @param animated animate the moving
     */
    open func setCurrentIndex(_ index: Int, animated: Bool){
        // Be sure we got an existing index
        if(index < 0 || index > self.navigationBarView.subviews.count-1){
            let exc = NSException(name: NSExceptionName(rawValue: "Index out of range"), reason: "The index is out of range of subviews's countsd!", userInfo: nil)
            exc.raise()
        }
        self.indexSelected = index
        // Get the right position and update it
        let xOffset = CGFloat(index) * self.SCREENSIZE.width
        self.scrollView.setContentOffset(CGPoint(x: xOffset, y: self.scrollView.contentOffset.y), animated: animated)
        
        for (i , item) in navItems.enumerated()
        {
            let perc:CGFloat =  (i == index) ? 1 : 0
            item.setSelected(perc: perc)
        }
        showViewController(at: self.indexSelected)
    }
    
    // MARK: - Internal methods
    fileprivate func setupPagingProcess() {
        let frame: CGRect                              = CGRect(x: 0, y: 0, width: SCREENSIZE.width, height: self.view.frame.height)
        
        self.scrollView                                = UIScrollView(frame: frame)
        self.scrollView.backgroundColor                = UIColor.clear
        self.scrollView.isPagingEnabled                  = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator   = false
        self.scrollView.delegate                       = self
        self.scrollView.bounces                        = true
        self.scrollView.contentInset                   = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
        
        self.view.addSubview(self.scrollView)
        
        // Adds all views
        self.setViewSizeAndLocation()
        
        if(self.needToShowPageControl){
            // Make the page control
            self.pageControl               = UIPageControl(frame: CGRect(x: 0, y: 35, width: 0, height: 0))
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
    
    fileprivate func setViewSizeAndLocation() {
        if self.viewControllers.count > 0 {
            let width                   = SCREENSIZE.width * CGFloat(self.viewControllers.count)
            let height                  = self.view.frame.height
            self.scrollView.contentSize = CGSize(width: width, height: height)
            var i: Int                  = 0
            while let v = viewControllers[i] {
                v.view.frame          = CGRect(x: self.SCREENSIZE.width * CGFloat(i), y: 0, width: self.SCREENSIZE.width, height: self.SCREENSIZE.height)
                i += 1
            }
        }
    }
    func showViewController(at index:Int) -> Void {
        
        if let prevVC = self.viewControllers[self.indexSelected] , prevVC.parent == self {
            
            prevVC.willMove(toParentViewController: nil)
        }
        if let nextVC = self.viewControllers[index] , nextVC.parent == nil {
            nextVC.willMove(toParentViewController: self)
            self.addChildViewController(nextVC)
            self.scrollView.addSubview(nextVC.view)
            nextVC.didMove(toParentViewController: self)
        }
        
    }
    func hideViewController(at index:Int) -> Void {
        
        if let prevVC = self.viewControllers[index] , prevVC.parent == self {
            
            prevVC.willMove(toParentViewController: nil)
            prevVC.view.removeFromSuperview()
            prevVC.removeFromParentViewController()
            prevVC.didMove(toParentViewController: nil)
            
        }
        
    }
    
    fileprivate func sendNewIndex(_ scrollView: UIScrollView){
        let xOffset      = Float(scrollView.contentOffset.x)
        let currentIndex = (Int(roundf(xOffset)) % (self.navigationBarView.subviews.count * Int(self.SCREENSIZE.width))) / Int(self.SCREENSIZE.width)
        if self.needToShowPageControl && self.pageControl.currentPage != currentIndex {
            self.pageControl.currentPage = currentIndex
            self.didChangedPage?(currentIndex)
        }
        if currentIndex != self.indexSelected {
            let prevIndex = self.indexSelected
            self.indexSelected = currentIndex
            hideViewController(at: prevIndex)
        }
        else{//scroll was canceled
            
            for (i,vc) in self.viewControllers {
                if let parent = vc.view.superview , parent == self, i != self.indexSelected
                {
                    hideViewController(at: i)
                    break
                }
            }
        }
        
        
    }
    
    open func getOriginX(_ vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat{
        var result = self.SCREENSIZE.width / 2.0 - vSize.width/2.0
        result += (idx * distance)
        result -= xOffset / (self.SCREENSIZE.width / distance)
        return result
    }
    open func getOriginY(_ vSize: CGSize, idx: CGFloat, distance: CGFloat, xOffset: CGFloat) -> CGFloat{
        var result = self.navigationBarView.frame.size.height / 2.0 - vSize.height/2.0
        //        result += (idx * distance)
        //        result -= xOffset / (self.SCREENSIZE.width / distance)
        return result
    }
    
    // Scroll to the view tapped
    func tapOnHeader(_ recognizer: UITapGestureRecognizer){
        if let key = recognizer.view?.tag, let view = self.viewControllers[key], self.isUserInteraction {
            self.scrollView.scrollRectToVisible(view.view.frame, animated: true)
            showViewController(at: key)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        let distance = CGFloat(100 + self.navigationSideItemsStyle.rawValue)
        for (i, v) in self.navItems.enumerated() {
            let vSize    = v.frame.size
            let originX  = self.getOriginX(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: xOffset)
            let originY  = self.getOriginY(vSize, idx: CGFloat(i), distance: CGFloat(distance), xOffset: xOffset)
            v.frame      = CGRect(x: originX, y: originY, width: vSize.width, height: vSize.height)
        }
        self.pagingViewMovingRedefine?(scrollView, self.navItems as NSArray)
        self.pagingViewMoving?(self.navItems)
        
        let candidateNextIndex = self.calcNextIndex(scrollView: scrollView)
        if nextIndex != candidateNextIndex{
            nextIndex = candidateNextIndex
            showViewController(at: nextIndex)
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }
    
    open func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.sendNewIndex(scrollView)
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        nextIndex = self.calcNextIndex(scrollView: scrollView)
        
        showViewController(at: nextIndex)
    }
    func calcNextIndex(scrollView:UIScrollView) -> Int {
        var direction = 0
        let yVelocity: CGFloat = scrollView.panGestureRecognizer.velocity(in: scrollView).x
        if yVelocity < 0 {      direction = 1  } else
            if yVelocity > 0 {      direction = -1 }
        
        let xOffset     = Int(roundf(Float(scrollView.contentOffset.x)))
        let W:Int       = Int(self.SCREENSIZE.width)
        
        let nextIndex = xOffset / W + direction
        return nextIndex
    }
    
}

extension UILabel {
    func _slpGetSize() -> CGSize? {
        return (text as NSString?)?.size(attributes: [NSFontAttributeName: font])
    }
}
