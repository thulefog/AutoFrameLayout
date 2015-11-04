//
//  ScrollableImageViewController.swift
//
//  Created by John Matthew Weston in March 2015 with iterative improvements since.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation
import UIKit

class ScrollableImageViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    
    var imageView: UIImageView!
    var drawerView: UIVisualEffectView!
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    
    var viewableFactory: ViewableFactory!
    var assetName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIScreen.mainScreen().bounds used previously in UIScrollView dynamic creation
        let currentViewBounds = self.view.bounds
        
        scrollView = UIScrollView(frame: currentViewBounds )
        self.view = scrollView
        
        log( "view.bounds \(currentViewBounds)")
        log( "view.bounds.size \(currentViewBounds.size) ")
        
        //option #d - from URL but through ViewableFactory
        viewableFactory = ViewableFactory()

        log( "Test Pattern \(assetName) " )
        imageView = viewableFactory.CreateViewableFromAsset( assetName )
            
        // 2) calculate frame and other measures for it
        
        //NOTE: the imageView.frame.size is based on currentViewBounds which is the self.view.boundscurrentViewBounds
        imageView.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:currentViewBounds.size)
        imageView.frame.size = currentViewBounds.size
        imageView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        log( "imageView.frame.size \(imageView.frame.size) )")

        // 3) add subview with image view
        scrollView.addSubview(imageView)

        //Changed contentSize calculation FROM image!.size TO code below:
        scrollView.contentSize = currentViewBounds.size

        // 4
        SetupGestureRecognizers()
        
        // 5
        SetupButtonActions()
        
        // 6
        // figure out the starting point scaling for scroll view and other screen factors
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale;
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        // 6
        centerScrollViewContents()
        
    }
    
    func SetupButtonActions()
    {
    /*
        button = UIButton.buttonWithType( UIButtonType.System ) as! UIButton
        button.frame = CGRectMake(64, 64, 64, 64)
        button.backgroundColor = UIColor.grayColor()
        button.setTitle(">>", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
    
        scrollView.addSubview(button)
     */
    }
    
    func SetupGestureRecognizers()
    {
        // set up gesture recognizers
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewSingleTappedOneFinger:")
        singleTapRecognizer.numberOfTapsRequired = 1
        singleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(singleTapRecognizer)
        
        let singleTapTwoFingerRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewSingleTappedTwoFinger:")
        singleTapTwoFingerRecognizer.numberOfTapsRequired = 1
        singleTapTwoFingerRecognizer.numberOfTouchesRequired = 2
        scrollView.addGestureRecognizer(singleTapTwoFingerRecognizer)
        
        let singleTapThreeFingerRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewSingleTappedThreeFinger:")
        singleTapThreeFingerRecognizer.numberOfTapsRequired = 1
        singleTapThreeFingerRecognizer.numberOfTouchesRequired = 3
        scrollView.addGestureRecognizer(singleTapThreeFingerRecognizer)
        
        let pinchRecognizer = UIPinchGestureRecognizer( target: self, action: "scrollViewPinched:")
        scrollView.addGestureRecognizer(pinchRecognizer)
        
        let panRecognizer = UIPanGestureRecognizer(target:self, action:"scrollViewPanned:")
        scrollView.addGestureRecognizer(panRecognizer)
        
        /*
        * - interference with Pan gesture
        *
        var swipeRecognizer = UISwipeGestureRecognizer( target: self, action:"scrollViewSwiped")
        swipeRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        swipeRecognizer.numberOfTouchesRequired = 2
        scrollView.addGestureRecognizer(swipeRecognizer)
        */
    }
    override func viewDidLayoutSubviews() {
        scrollView.maximumZoomScale = 5.0
        scrollView.contentSize = imageView.frame.size

        log( "scrollView.bounds \(scrollView.bounds)")
        log( "scrollView.bounds.size \(scrollView.bounds.size) ")
        log( "imageView.frame.size \(imageView.frame.size) ")
        log( "scrollView.zoomScale \(scrollView.zoomScale)")

        scrollView.setZoomScale(max(scrollView.zoomScale, scrollView.zoomScale), animated: true )
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
      
        log( "boundsSize: \(boundsSize) ")
        log( "contentsFrame: \(contentsFrame) BEFORE checks against boundSize")
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
     
        log( "contentsFrame: \(contentsFrame) AFTER reconciled against boundSize")

        imageView.frame = contentsFrame
    }

    
    func buttonAction(sender:UIButton!)
    {
        print("Button tapped")
        
        //from FilmBox proto, Detail view, rewritten in swift with code added
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let drawerView:UIVisualEffectView = UIVisualEffectView (effect: blur)
        drawerView.frame = CGRectMake(0,0,scrollView.frame.size.width, scrollView.frame.size.height) //scrollView.frame W+H will blur whole thing
        scrollView.addSubview(drawerView)

    }
    
    func scrollViewSingleTappedOneFinger( recognizer: UITapGestureRecognizer )
    {
        log( "numberOfTapsRequired \(recognizer.numberOfTapsRequired) recognizer.numberOfTouches() \(recognizer.numberOfTouches())" )
        
        // 1
        let pointInView = recognizer.locationInView(imageView)

        //zoom to 150%
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        log( "scrollView.zoomScale \(scrollView.zoomScale) newZoomScale \(newZoomScale)")
        
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        
        log( "rectToZoomTo \(rectToZoomTo)")
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }

    func scrollViewSingleTappedTwoFinger( recognizer: UITapGestureRecognizer )
    {
        log( "numberOfTapsRequired \(recognizer.numberOfTapsRequired) recognizer.numberOfTouches() \(recognizer.numberOfTouches())" )
        
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        //zoom to 150%
        let newZoomScale = scrollView.zoomScale / 1.5
        
        log( "scrollView.zoomScale \(scrollView.zoomScale) newZoomScale \(newZoomScale)")

        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        log( "rectToZoomTo \(rectToZoomTo)")
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func scrollViewSingleTappedThreeFinger( recognizer: UITapGestureRecognizer )
    {
        log( "numberOfTapsRequired \(recognizer.numberOfTapsRequired) recognizer.numberOfTouches() \(recognizer.numberOfTouches())" )
        
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    func scrollViewPinched( recognizer: UIPinchGestureRecognizer )
    {
        let scale = recognizer.scale
        let velocity = recognizer.velocity
        log( "Pinch - scale = \(scale), velocity = \(velocity)")
        
        self.view.transform = CGAffineTransformScale(self.view.transform, recognizer.scale, recognizer.scale)
        recognizer.scale = 1
    }
    
    func scrollViewPanned( recognizer: UIPanGestureRecognizer )
    {
        let translation = recognizer.translationInView(self.view)
        
        log( " recognizer.view.center \(recognizer.view!.center)")
        log( " translation \(translation)" )
        
        recognizer.view!.center = CGPoint(x:recognizer.view!.center.x + translation.x, y:recognizer.view!.center.y + translation.y)
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    /*
    func scrollViewSwiped( recognizer: UISwipeGestureRecognizer )
    {
        let direction = recognizer.direction
        
        log( " direction \(direction)" )

        if( direction == UISwipeGestureRecognizerDirection.Left)
        {
            self.dismissViewControllerAnimated(true, completion: {});
        }
    }*/
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



