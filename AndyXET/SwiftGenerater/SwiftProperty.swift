//
//  SwiftProperty.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/29.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

enum DataType {
    case string
    case bool
    case float
    case double, long, longlong
    case int
    case character
    case generic
    
    func toString() -> String {
        var typeStr: String
        switch self {
        case .string:
            typeStr = "String"
        case .bool:
            typeStr = "Bool"
        case .float:
            typeStr = "Float"
        case .double, .long, .longlong:
            typeStr = "Double"
        case .int:
            typeStr = "Int"
        case .character:
            typeStr = "Character"
        case .generic:
            typeStr = "AnyObject"
        }
        return typeStr
    }
    
    static func get(from: String) -> DataType {
        var type: DataType
        switch from {
        case "String":
            type = .string
        case "Bool":
            type = .bool
        case "Float":
            type = .float
        case "Double":
            type = .double
        case "Int":
            type = .int
        case "Character":
            type = .character
        case "AnyObject":
            type = .generic
        default:
            type = .generic
        }
        return type
    }
}

class Property {
    var jsonName: String
    var type: String
    
    var isCustomClass: Bool
    var isArray: Bool
    
    var elementsType = ""
    var elementsAreOfCustomType = false
    
    var sampleValue: AnyObject?
    
    func toString() -> String {
        var str = "let \(jsonName): \(type)"
        
        let dataType = DataType.get(from: type)
        switch dataType {
        case .bool:
            str += " = false"
        case .float:
            str += " = 0.0"
        case .double, .long, .longlong:
            str += " = 0.0"
        case .int:
            str += " = 0"
        default:
            str += "? = nil"
        }
        return str
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
