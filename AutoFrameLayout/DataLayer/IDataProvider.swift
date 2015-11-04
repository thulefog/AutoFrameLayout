//
//  IDataProvider.swift
//
//  Created by John Matthew Weston in April 2015
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation

protocol IDataProvider {
    
    var ElementCount: Int { get }
    
    var Hydrated: Bool { get }
    
    func Populate() -> Bool
    
    func ElementAtIndex( index: Int ) -> String
    
}
