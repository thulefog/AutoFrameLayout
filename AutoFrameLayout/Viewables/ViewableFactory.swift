//
//  ViewableFactory.swift
//  Viewables
//
//  Created by John Matthew Weston in April 2015.
//  Refactored and reduced to working code for OSX (NSImage) + iOS (UIImage), August/September 2015.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation
import UIKit

//TODO: formalize contract with ViewableFactory below, this is just a seed of a protocol
protocol IViewable
{
    var Width: Int { get }
    var Height: Bool { get }
}



public class ViewableFactory
{
    public  init()
    {
        //not much
    }
    
    public func CreateViewableFromAsset( asset: String ) -> UIImageView
    {
        let image = UIImage(named: asset)
        let imageView = UIImageView(image: image)
        return imageView
    }
    
    public func CreateViewableFromUrl( urlLocation: String ) -> UIImageView
    {
        //e.g. "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png"
 
        let imageAsync = UIImageView()
        imageAsync.downloadImage( urlLocation )
        return imageAsync
    }
    
    public func CreateViewableFromRawFile( rawFilePath: String,  width: Int, height: Int ) -> UIImageView
    {
        NSLog( "Reading RAW data file \(rawFilePath)")
        
        let fileData = NSData( contentsOfFile: rawFilePath )
        let rawData = RawImageFrame()
        
        NSLog( "Creating viewable representation of file...")
        
        var uiImage = UIImage( )
        
        uiImage = rawData.getUIImageForRawByteData( Int(width) , height: Int(height), data: fileData! )!
        let imageView = UIImageView( image: uiImage )

        return imageView
    }
    
}
