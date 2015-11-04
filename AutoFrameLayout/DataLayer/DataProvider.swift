//
//  DataProvider.swift
//
//  Created by John Matthew Weston in February 2015.
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation

class DataProvider : IDataProvider {
    
    
    var json: JSON!
    var count: Int!
    var hydrated: Bool!
    
    var ElementCount:Int {
        return count
    }
    
    var Hydrated:Bool {
        return hydrated;
    }
    
    func ElementAtIndex(index: Int) -> String {
        if( index < count )
        {
            let result = (json["SimpleStore"][index]["Instance"])
            let formattedResult = result.string
            log( "instance \(result)")
            return formattedResult!
        
        }
        else
        {
            return ""
        }
    }
    
    init() {

        Populate()
    }
    
    func Populate() -> Bool
    {
        count = 0

        if let file = NSBundle(forClass:AppDelegate.self).pathForResource("SimpleStore", ofType: "json") {
            let data = NSData(contentsOfFile: file)!
            
            json = JSON(data:data)
            
            for (_, _): (String, JSON) in json {
                log( "index \(index) " )
            }
            
            //traverse the data set and log to sanity check
            for (index, subJson): (String, JSON) in json["SimpleStore"] {
                let instance = subJson["Instance"].string;
                let description = subJson["Description"].string;
                log( "index \(index) Instance \(instance) | Description \(description)" )
                count!++
            }
            //test: instance zero
            log( "instance \(json["SimpleStore"][0]["Instance"]) ")
            
        }
        hydrated = true
        return hydrated
    }
    

}