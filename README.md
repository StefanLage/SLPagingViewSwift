# SLPagingViewSwift

A navigation bar system allowing to do a Tinder like or Twitter like. SLPagingViewSwift is a Swift port of the Objective-C of [SLPagingView](https://github.com/StefanLage/SLPagingView)

<div style="width:100%; height:450px;">
<img src="https://raw.githubusercontent.com/StefanLage/SLPagingView/master/Demos/TinderLike/tinder.gif" align="left" height="440" width="250" style="margin-left:20px;">
<img src="https://raw.githubusercontent.com/StefanLage/SLPagingView/master/Demos/TwitterLike/twitter.gif" algin="right" height="440" width="250" style="margin-left:50px;">
</div>

## Requirements

* iOS 7.0+
* ARC
* Swift 2.0

## Installation

### CocoaPods

[CocosPods](http://cocosPods.org) is the recommended method to install SLPagingView.

Add the following line to your Podfile:

```ruby
pod 'SLPagingViewSwift'
```

And run
```ruby
pod install
```

### Manual

Import SLPagingView folder into your project.


## How to use

Easy to implement:

```swift

	// Make views for the navigation bar
    var img1 = UIImage(named: "gear")
	img1 = img1?.imageWithRenderingMode(.AlwaysTemplate)
	var img2 = UIImage(named: "profile")
	img2 = img2?.imageWithRenderingMode(.AlwaysTemplate)
	var img3 = UIImage(named: "chat")
	img3 = img3?.imageWithRenderingMode(.AlwaysTemplate)

    var items = [UIImageView(image: img1), UIImageView(image: img2), UIImageView(image: img3)]
	var controllers = [ctr1, ctr2, ctr3]
	controller = SLPagingViewSwift(items: items, controllers: controllers, showPageControl: false)

````

Then you can make your own behaviors:

```swift

	// Tinder Like
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

````

##Other example

Twitter like behaviors

```swift

	// Twitter Like
	controller?.pagingViewMovingRedefine = ({ scrollView, subviews in
		var i = 0
		var xOffset = scrollView.contentOffset.x
		for v in subviews {
			var lbl = v as UILabel
			var alpha = CGFloat(0)

			if(lbl.frame.origin.x > 45 && lbl.frame.origin.x < 145) {
				alpha = 1.0 - (xOffset - (CGFloat(i)*320.0)) / 320.0
			}
			else if (lbl.frame.origin.x > 145 && lbl.frame.origin.x < 245) {
				alpha = (xOffset - (CGFloat(i)*320.0)) / 320.0 + 1.0
			}
			else if(lbl.frame.origin.x == 145){
				alpha = 1.0
			}
			lbl.alpha = CGFloat(alpha)
			i++
		}
	})
````

##API

###Set current page

If you want to changed the default page control index (or whatever) you can do it calling:

```swift

	func setCurrentIndex(index: Int, animated: Bool)
````

###Navigation items style

<img src="https://raw.githubusercontent.com/StefanLage/SLPagingView/master/Demos/TinderLike/navigation_style.gif" height="440" width="250" style="margin-left:50px;">

You can easily customized the navigation items setting up:


```swift

	var navigationSideItemsStyle: SLNavigationSideItemsStyle
````


By using one of these values:


```swift

	enum SLNavigationSideItemsStyle: Int {
    	case SLNavigationSideItemsStyleOnBounds = 40
	    case SLNavigationSideItemsStyleClose = 30
    	case SLNavigationSideItemsStyleNormal = 20
	    case SLNavigationSideItemsStyleFar = 10
    	case SLNavigationSideItemsStyleDefault = 0
	    case SLNavigationSideItemsStyleCloseToEachOne = -40
	}
````


##License
Available under MIT license, please read LICENSE for more informations.
