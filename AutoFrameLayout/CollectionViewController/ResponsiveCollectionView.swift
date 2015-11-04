//
//  ResponsiveCollectionView.swift
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation
import LocalAuthentication

class ResponsiveCollectionView: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var collectionView: UICollectionView?
    
    var dataProvider = DataProvider()
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Internal Methods
    // --------------------------------------------------------------------------------
    
    // This function will be called when the Dynamic Type user setting changes (from the system Settings app)
    func contentSizeCategoryChanged(notification: NSNotification) {
        collectionView?.reloadData()
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Private Methods
    // --------------------------------------------------------------------------------
    
    private func updateViews() {
        collectionView?.frame = getCollectionViewFrame()
        collectionView?.reloadData()
    }
    
    private func cellCount() -> Int {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return orientation.isPortrait ? 16 : 16

    }
    
    private func rowCellCount() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return orientation.isPortrait ? 8 : 7
    }
    
    private func isHorizontalCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.row >= (cellCount() - 2)
    }
    
    private func isHiddenCell(indexPath: NSIndexPath) -> Bool {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return (orientation.isPortrait && (indexPath.row == cellCount() - 4 || indexPath.row == cellCount() - 3))
    }
    
    private func getRow(indexPath: NSIndexPath) -> Int {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return (orientation.isPortrait && isHorizontalCell(indexPath)) ? indexPath.row - 2 : indexPath.row
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Private Size Methods
    // --------------------------------------------------------------------------------
    
    private func horizontalCellSize() -> CGSize {
        return CGSize(width: horizontalCellWidth(), height: 50.0)
    }
    
    private func horizontalCellWidth() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation.isPortrait {
            return getCollectionViewWidth() - (leftRightInset() * 2)
        } else {
            return (getCollectionViewWidth() - verticalCellWidth() - (leftRightInset() * 4)) / 2
        }
    }
    
    private func verticalCellSize() -> CGSize {
        return CGSize(width: verticalCellWidth(), height: 75.0)
    }
    
    private func verticalCellWidth() -> CGFloat {
        return (getCollectionViewWidth() - (leftRightInset() * (rowCellCount() + 1)))  / rowCellCount()
    }
    
    private func getCollectionViewWidth() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return self.view.frame.size.width
        } else {
            return orientation.isPortrait ? 414 : 736
        }
    }
    
    private func getCollectionViewHeight() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return self.view.frame.size.height
        } else {
            return orientation.isPortrait ? 736 : 414
        }
    }
    
    private func getCollectionViewFrame() -> CGRect {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return CGRectMake(0, 0, getCollectionViewWidth(), getCollectionViewHeight())
        } else {
            return CGRectMake(self.view.frame.size.width / 2 - getCollectionViewWidth() / 2, 0, getCollectionViewWidth(), getCollectionViewHeight())
        }
    }
    
    private func headerHeight() -> CGFloat {
        return 40.0
    }
    
    private func leftRightInset() -> CGFloat {
        return 4.0
    }
    
    private func bottomInset() -> CGFloat {
        return 4.0
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UIViewController Methods
    // --------------------------------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        updateViews()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    

    
    override func viewDidLoad() {
        
        authenticateWithTouchID();
        
        super.viewDidLoad()
        
        dataProvider.Populate()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftRightInset(), bottom: bottomInset(), right: leftRightInset())
        layout.minimumInteritemSpacing = leftRightInset()
        layout.minimumLineSpacing = bottomInset()
        
        collectionView = UICollectionView(frame: getCollectionViewFrame(), collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(ResponsiveCollectionViewCell.self, forCellWithReuseIdentifier: "CellVertical")
        collectionView!.registerClass(ResponsiveCollectionViewCell.self, forCellWithReuseIdentifier: "CellHorizontal")
        collectionView!.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
        collectionView!.backgroundColor = UIColor.lightGrayColor()
        self.view.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(collectionView!)
        self.edgesForExtendedLayout = .None
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewDataSource Methods
    // --------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = isHorizontalCell(indexPath) ? "CellHorizontal" : "CellVertical"
        if let cell: ResponsiveCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? ResponsiveCollectionViewCell {
            
            cell.hidden = isHiddenCell(indexPath)
            let insets = (verticalCellWidth() - cell.imageSize) / 2
            isHorizontalCell(indexPath) ? cell.updateCell(.Horizontal, horizontalInsets: insets) : cell.updateCell(.Vertical, horizontalInsets: insets)
            
            let row = getRow(indexPath)
            log( "loading up cell at index \(row)" )
           
            let query = dataProvider.ElementAtIndex(row)
            
            // 6.1.xx
            let assetName =  (String(format: "6.1.%02d", getRow(indexPath)+1))
            cell.imageView.image = UIImage(named: assetName )
            
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = cell.titleLabel.text
            
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            return cell
        }
        
        assert(false, "The dequeued cell was of an unknown type!")
        return UICollectionViewCell()
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {

            if let reusableview: UICollectionReusableView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as? UICollectionReusableView {
                if (reusableview.subviews.count > 0) {
                    if let view: UIView = reusableview.subviews[0] as? UIView {
                        view.removeFromSuperview()
                    }
                }
                
                let sectionLabel: UILabel = UILabel(frame: CGRectMake(0, 0, collectionView.frame.size.width, headerHeight()))
                sectionLabel.text = NSLocalizedString("USC SIPI Test Sequence", comment: "")

                sectionLabel.backgroundColor = UIColor.clearColor()
                sectionLabel.textAlignment = .Center
                sectionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                reusableview.addSubview(sectionLabel)
                return reusableview
            }
        }
        
        assert(false, "The view was of an unknown kind!")
        return UICollectionReusableView()
        
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewDelegate Methods
    // --------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        /* 
         * DEBUG
         *
        let alert = UIAlertController(title: "didSelectItemAtIndexPath:", message: "Indexpath = \(indexPath)", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(alertAction)
        self.presentViewController(alert, animated: true, completion: nil)
        */
        
        let row = getRow(indexPath)
        log( "loading up cell at index \(row)" )
        
        let scrollableImageView:ScrollableImageViewController = ScrollableImageViewController()

        let query = dataProvider.ElementAtIndex(row)
        
        //FIX: zero offset issue
        
        let assetName =  (String(format: "6.1.%02d.jpg", getRow(indexPath)))
        scrollableImageView.assetName = assetName
        
        self.presentViewController(scrollableImageView, animated: true, completion: nil)

    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewDelegateFlowLayout Methods
    // --------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return isHorizontalCell(indexPath) ? horizontalCellSize() : verticalCellSize()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.frame.size.width, height: headerHeight())
    }
}

