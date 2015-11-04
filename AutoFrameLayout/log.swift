//
//  log.swift
//  ScrollableAdaptiveImageViewer
//
//  Created by John Matthew Weston in July 2015
//  Source Code - Copyright © 2015 John Matthew Weston but published as open source under MIT License.
//

import Foundation



func log(logMessage: String, functionName: String = __FUNCTION__) {
    print("\(functionName): \(logMessage)")
}