//
//  SwiftProperty.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/29.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

class Property {
    var jsonName: String
    var type: String
    
    var isCustomClass: Bool
    var isArray: Bool
    
    var elementsType = ""
    var elementsAreOfCustomType = false
    
    var sampleValue: AnyObject?
    
    func toString() -> String {
        return "let \(jsonName): \(type)?"
    }
    
    init(jsonName: String, type: String, isArray: Bool, isCustomClass: Bool) {
        self.jsonName = jsonName
        self.type = type
        self.isArray = isArray
        self.isCustomClass = isCustomClass
        self.sampleValue = nil
    }
    
    convenience init(jsonName: String, type: String) {
        self.init(jsonName: jsonName, type: type, isArray: false, isCustomClass: false)
    }
}
