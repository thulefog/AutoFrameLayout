//
//  ResponsiveCollectionViewCell.swift
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import UIKit

class OffSetLabel: UILabel {
    
    private var offset: CGFloat = 10.0
    
    override func drawTextInRect(rect: CGRect) {
        let newRect = CGRectOffset(rect, offset, 0)
        super.drawTextInRect(newRect)
    }
}

class ResponsiveCollectionViewCell: UICollectionViewCell {
    
    enum AddCellType {
        case Vertical
        case Horizontal
    }

    var titleLabel: OffSetLabel = OffSetLabel.newAutoLayoutView()
    var imageView: UIImageView = UIImageView.newAutoLayoutView()
    let imageSize: CGFloat = 42.0
    
    private let verticalInsets: CGFloat = 2.0
    private var didSetupConstraints = false
    private var titleLayoutConstraint : NSLayoutConstraint? = nil
    private var imageLayoutConstraint : NSLayoutConstraint? = nil
    
    private var cellType: AddCellType = .Vertical
    private let containerBackgroundColor: UIColor = UIColor.clearColor()
    private let titleBackgroundColorVertical: UIColor = UIColor.clearColor()
    private let titleBackgroundColorHorizontal: UIColor = UIColor.grayColor()
    private let highlightColor: UIColor = UIColor.darkGrayColor()
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: NSObject Methods
    // --------------------------------------------------------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UIView Methods
    // --------------------------------------------------------------------------------
    
    override func updateConstraints() {
        if !didSetupConstraints {
            
            if (cellType == .Vertical) {
                imageView.autoPinEdgeToSuperviewEdge(.Top, withInset: verticalInsets)
                imageView.autoSetDimension(.Height, toSize: imageSize)
                imageView.autoSetDimension(.Width, toSize: imageSize)
                imageView.autoAlignAxisToSuperviewAxis(.Vertical)
                
                titleLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: imageView)
                titleLabel.autoPinEdgeToSuperviewEdge(.Left)
                titleLabel.autoPinEdgeToSuperviewEdge(.Right)
                titleLabel.autoPinEdgeToSuperviewEdge(.Bottom, withInset: 8)
                
            } else {
                
                imageView.autoSetDimension(.Height, toSize: imageSize)
                imageView.autoSetDimension(.Width, toSize: imageSize)
                imageView.autoAlignAxisToSuperviewAxis(.Horizontal)
                
                titleLabel.autoPinEdge(.Left, toEdge: .Right, ofView: imageView)
                titleLabel.autoAlignAxisToSuperviewAxis(.Horizontal)
                titleLabel.autoSetDimension(.Height, toSize: imageSize)
            }
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewCell Methods
    // --------------------------------------------------------------------------------
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                contentView.backgroundColor = (cellType == .Vertical) ? highlightColor : UIColor.clearColor()
                titleLabel.backgroundColor = (cellType == .Vertical) ? titleBackgroundColorVertical : highlightColor
                titleLabel.textColor = UIColor.whiteColor()
            } else {
                contentView.backgroundColor = containerBackgroundColor
                titleLabel.backgroundColor = (cellType == .Vertical) ? titleBackgroundColorVertical : titleBackgroundColorHorizontal
                titleLabel.textColor = UIColor.blackColor()
            }
            
        }
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Private Methods
    // --------------------------------------------------------------------------------
    
    private func setupViews() {
        titleLabel.lineBreakMode = .ByTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.blackColor()
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.backgroundColor = UIColor.blackColor() 
        imageView.tintColor = UIColor.whiteColor()
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = containerBackgroundColor
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Internal Methods
    // --------------------------------------------------------------------------------
    
    func updateCell(type: AddCellType, horizontalInsets: CGFloat) {
        cellType = type
        if (cellType == .Vertical) {
            titleLabel.offset = 0
            titleLabel.textAlignment = .Center
            titleLabel.backgroundColor = titleBackgroundColorVertical
        } else {
            
            // The horizontalInsets change on rotation so update the constraint as needed
            imageLayoutConstraint?.autoRemove()
            imageLayoutConstraint = imageView.autoPinEdgeToSuperviewEdge(.Left, withInset: horizontalInsets)
            
            titleLayoutConstraint?.autoRemove()
            titleLayoutConstraint = titleLabel.autoPinEdgeToSuperviewEdge(.Right, withInset: horizontalInsets)
            
            titleLabel.offset = 10.0
            titleLabel.textAlignment = .Left
            titleLabel.backgroundColor = titleBackgroundColorHorizontal
        }
        
        titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
    }
}

