//
//  UIImageExtension.swift
//  Viewables
//
//  Created by John Matthew Weston in May 2015.
//  Refactored and reduced to working code for OSX (NSImage) + iOS (UIImage), August/September 2015.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//


import Foundation
import UIKit

#if os(iOS)
  
extension UIImage {
    
    func savePNG(  path:String) -> Bool {
        let cgImage:CGImageRef = self.CGImage!
        let uiImage = UIImage(CGImage: cgImage, scale: self.scale,orientation: self.imageOrientation)
        let imagePNGRepresentation = UIImagePNGRepresentation(uiImage)
        return imagePNGRepresentation!.writeToFile(path, atomically: true)
    }
    
    func saveJPG( path:String) -> Bool {
        let cgImage:CGImageRef = self.CGImage!;
        let uiImage = UIImage(CGImage: cgImage, scale: self.scale,orientation: self.imageOrientation)
        let imageJPGRepresentation = UIImageJPEGRepresentation(uiImage, 1.0)
        return imageJPGRepresentation!.writeToFile(path, atomically: true)
    }
}
    
#else
    
extension NSImage {
    var imagePNGRepresentation: NSData {
    return NSBitmapImageRep(data: TIFFRepresentation!)!.representationUsingType(.NSPNGFileType, properties: [:])!
    }
    func savePNG(path:String) -> Bool {
    return imagePNGRepresentation.writeToFile(path, atomically: true)
    }
}
#endif

