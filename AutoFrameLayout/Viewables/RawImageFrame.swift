//
//  RawImageFrame.swift
//  Viewables
//
//  Created by John Matthew Weston in May 2015.
//  Refactored and reduced to working code for OSX (NSImage) + iOS (UIImage), August/September 2015.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation

#if os(iOS)
    import UIKit
    import CoreGraphics
#else
    import Cocoa
    import AppKit
#endif



public class RawImageFrame
{
    struct PixelData {
        var a:UInt8 = 255
        var r:UInt8
        var g:UInt8
        var b:UInt8
    }
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
    
    //Class is no longer : NSObject derived, this caused issues: 
    // --> public override convenience init() { self.init() }

    public  init()
    {
        //not much
    }

#if os(iOS)
    public func getUIImageForRawByteData( width: Int, height: Int, data: NSData) -> UIImage?
    {
        let pixelData = data.bytes
        let bitsPerPixel:Int = 8
        let bytesPerPixel:Int = 1
        let scanWidth = bytesPerPixel * width
        //for grayscale, value=1 but for RGB this would be 3, i.e Int(3) below...
        var numberOfColorChannels = Int(1)
        
        //NB: there is room for optimization here, could avoid this pixel grid traversal and copy
        let ptr = UnsafePointer<UInt8>(data.bytes)
        let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data.length)
        
        var destinationBuffer = [UInt8](count: Int(width) * Int(height) * numberOfColorChannels, repeatedValue: 128)
        
        var targetPixels = UnsafeMutablePointer<UInt8>(destinationBuffer)
        var sourcePixels = ptr
        
        for (var index = 0; index < width * height; index++) {
            var value:UInt8 = UInt8(sourcePixels.memory)
            destinationBuffer[index] = value
            print(String(format:"%X ", value), terminator: "")
            sourcePixels++
        }
        
        let provider = CGDataProviderCreateWithData( nil, destinationBuffer, Int(height * width * numberOfColorChannels ), nil)
        
        //there is interplay between - CGColorSpaceCreateDeviceRGB() and - numberOfColorChannels
        let colorSpaceRef =  CGColorSpaceCreateDeviceGray()
        var bitmapInfo:CGBitmapInfo = .ByteOrderDefault;
        
        let imageRef = CGImageCreate(
            Int(width),
            Int(height),
            bitsPerPixel,
            bitsPerPixel * numberOfColorChannels,
            bytesPerPixel * Int(width)  * numberOfColorChannels,
            colorSpaceRef,
            bitmapInfo,
            provider,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault);
        
        /*
        * NOTE: this is the signature for this key GC class
        *
        func CGImageCreate(_ width: Int,
        _ height: Int,
        _ bitsPerComponent: Int,
        _ bitsPerPixel: Int,
        _ bytesPerRow: Int,
        _ colorspace: CGColorSpace!,
        _ bitmapInfo: CGBitmapInfo,
        _ provider: CGDataProvider!,
        _ decode: UnsafePointer<CGFloat>,
        _ shouldInterpolate: Bool,
        _ intent: CGColorRenderingIntent) -> CGImage!
        */

    //TOOD: remove when extension method working and tested for CG/UI to PNG/JPG conversion

    let image = UIImage(CGImage: imageRef!)
    
    let pngImageData = UIImagePNGRepresentation(image)
    
    let result1 = pngImageData!.writeToFile(NSString (string: "/Users/TheChief/Code/DataCache/raw.png") as String, atomically: true)
    
    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
    let result12 = jpgImageData!.writeToFile(NSString (string: "/Users/TheChief/Code/DataCache/raw.jpg") as String, atomically: true)

    return image
    }
#else
    
    public func getViewableImageForRawByteData( width: Int, height: Int, data: NSData) -> NSImage?
    {
        let pixelData = data.bytes
        let bitsPerPixel:Int = 8
        let bytesPerPixel:Int = 1
        let scanWidth = bytesPerPixel * width
        //for grayscale, value=1 but for RGB this would be 3, i.e Int(3) below...
        var numberOfColorChannels = Int(1)
        
        //NB: there is room for optimization here, could avoid this pixel grid traversal and copy
        let ptr = UnsafePointer<UInt8>(data.bytes)
        let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data.length)
        
        var destinationBuffer = [UInt8](count: Int(width) * Int(height) * numberOfColorChannels, repeatedValue: 128)
        
        var targetPixels = UnsafeMutablePointer<UInt8>(destinationBuffer)
        var sourcePixels = ptr
        
        for (var index = 0; index < width * height; index++) {
            var value:UInt8 = UInt8(sourcePixels.memory)
            destinationBuffer[index] = value
            print(String(format:"%X ", value))
            sourcePixels++
        }
        
        let provider = CGDataProviderCreateWithData( nil, destinationBuffer, Int(height * width * numberOfColorChannels ), nil)
        
        //there is interplay between - CGColorSpaceCreateDeviceRGB() and - numberOfColorChannels
        let colorSpaceRef =  CGColorSpaceCreateDeviceGray()
        var bitmapInfo:CGBitmapInfo = .ByteOrderDefault;
        
        let imageRef = CGImageCreate(
            Int(width),
            Int(height),
            bitsPerPixel,
            bitsPerPixel * numberOfColorChannels,
            bytesPerPixel * Int(width)  * numberOfColorChannels,
            colorSpaceRef,
            bitmapInfo,
            provider,
            nil,
            true,
            kCGRenderingIntentDefault);
        
        /*
        * NOTE: this is the signature for this key GC class
        *
        func CGImageCreate(_ width: Int,
        _ height: Int,
        _ bitsPerComponent: Int,
        _ bitsPerPixel: Int,
        _ bytesPerRow: Int,
        _ colorspace: CGColorSpace!,
        _ bitmapInfo: CGBitmapInfo,
        _ provider: CGDataProvider!,
        _ decode: UnsafePointer<CGFloat>,
        _ shouldInterpolate: Bool,
        _ intent: CGColorRenderingIntent) -> CGImage!
        */
        
        var dataSize = NSSize(width: Int(width), height: Int(height) )
        let image = NSImage( CGImage: imageRef, size: dataSize )
        //NOTE: moved diagnostic file write methods from inline here to NSImage extension methods
        
        return image
    }
#endif
    
    //MARK ----------------------------------------------------------------
    
    /*
    
    Usage:
    ------
    let length:UInt = 200
    let redPixel = PixelData(a: 255, r: 192, g: 0, b: 0)
    var pixelData = [PixelData](count: Int(length * length), repeatedValue: redPixel)
    // Update pixels
    
    var image = imageFromARGB32Bitmap(pixelData, length, length)
    
    iOS: image is a UIImage
    OSX: image is an NSImage
    
    */
    

#if os(iOS)
    func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->UIImage
    {
    let bitsPerComponent:UInt = 8
        let bitsPerPixel:UInt = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        var dataPointer = UnsafeMutablePointer<CGFloat>.alloc(1)
        
        //var dataPointer = UnsafePointer<CGFloat>.alloc(1)
        //dataPointer.destroy() then dataPointer.dealloc()
        
        let cgim = CGImageCreate(
            Int(width),
            Int(height),
            Int(bitsPerComponent),
            Int(bitsPerPixel),
            Int( width * UInt(sizeof(PixelData))),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            dataPointer, //UnsafePointer
            true,
            CGColorRenderingIntent.RenderingIntentDefault )
        
    return UIImage(CGImage: cgim!)
    }

    //NOTE: removed getUIImageForRGBAData() for now due to language change around bitwise operators in Swift in XCode 7.x toolchain and iOS9 changes.
 #else
    func imageFromARGB32Bitmap(pixels:[PixelData], width:UInt, height:UInt)->NSImage {
        let bitsPerComponent:UInt = 8
        let bitsPerPixel:UInt = 32
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(PixelData))
        )
        
        var dataPointer = UnsafeMutablePointer<CGFloat>.alloc(1)
        
        //var dataPointer = UnsafePointer<CGFloat>.alloc(1)
        //dataPointer.destroy() then dataPointer.dealloc()
        
        let cgim = CGImageCreate(
            Int(width),
            Int(height),
            Int(bitsPerComponent),
            Int(bitsPerPixel),
            Int( width * UInt(sizeof(PixelData))),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            dataPointer, //UnsafePointer
            true,
            kCGRenderingIntentDefault )
        
        var dataSize = NSSize(width: Int(width), height: Int(height) )
        let image = NSImage( CGImage: cgim, size: dataSize )
        return image
    }
    
    public func getUIImageForRGBAData( width: UInt, height: UInt, data: NSData) -> NSImage? {
        let pixelData = data.bytes
        let bytesPerPixel:UInt = 4
        let scanWidth = bytesPerPixel * width
        
        //let data = NSData(contentsOfFile: filename)
        let ptr = UnsafePointer<UInt8>(data.bytes)
        //let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data.length)
        let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data.length)
        
        let provider = CGDataProviderCreateWithData( nil, ptr/*pixelData*/, Int(height * scanWidth), nil)
        
        //Key characteristic of data is raw bytes OR RGB +/- A
        //...that determines CGColorSpaceCreateDeviceGray  --- CGColorSpaceCreateDeviceRGB
        let colorSpaceRef =  CGColorSpaceCreateDeviceRGB()
        var bitmapInfo:CGBitmapInfo = .ByteOrderDefault;
        bitmapInfo |= CGBitmapInfo(CGImageAlphaInfo.Last.rawValue)
        
        let renderingIntent = kCGRenderingIntentDefault;
        
        let imageRef = CGImageCreate(
            Int(width),
            Int(height),
            8,
            Int(bytesPerPixel * 8),
            Int(scanWidth),
            colorSpaceRef,
            bitmapInfo,
            provider,
            nil,
            false,
            renderingIntent);
        
        var dataSize = NSSize(width: Int(width), height: Int(height) )
        let image = NSImage( CGImage: imageRef, size: dataSize )
        return image
    }
#endif

}

