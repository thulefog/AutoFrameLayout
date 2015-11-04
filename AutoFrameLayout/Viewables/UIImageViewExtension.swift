//
//  UIImageViewExtension.swift
//  Viewables
//
//  Created by John Matthew Weston in May 2015.
//  Refactored and reduced to working code for OSX (NSImage) + iOS (UIImage), August/September 2015.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation
import UIKit

extension UIImageView
{
    func getDataFromUrl(url:String, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) in
            completion(data: NSData(data: data!))
            }.resume()
    }
    
    func downloadImage(url:String){
        //_urlLocation = url
        log( "asynchronous download dispatched from URL \(url)")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode = UIViewContentMode.ScaleAspectFill
                self.image = UIImage(data: data!)
                log( "asynchronous download completed for \(url)")
            }
        }
    }
}