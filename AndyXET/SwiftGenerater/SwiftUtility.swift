//
//  SwiftUtility.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/29.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

func typeNameForPropertyName(_ propertyName : String) -> String{
    let swiftClassName = underscoresToCamelCaseForString(propertyName, startFromFirstChar: true).toSingular()
    return swiftClassName
}

func underscoresToCamelCaseForString(_ input: String, startFromFirstChar: Bool) -> String
{
    var str = input.replacingOccurrences(of: " ", with: "")
    
    str = str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    var output = ""
    var makeNextCharUpperCase = startFromFirstChar
    for char in input {
        if char == "_" {
            makeNextCharUpperCase = true
        }else if makeNextCharUpperCase{
            let upperChar = String(char).uppercased()
            output += upperChar
            makeNextCharUpperCase = false
        }else{
            makeNextCharUpperCase = false
            output += String(char)
        }
    }
    
    return output
}

func propertyTypeName(_ value : AnyObject) -> String
{
    var name = ""
    if value is NSArray {
        name = typeNameForArrayOfElements(value as! NSArray)
    } else if value is NSNumber {
        name = typeForNumber(value as! NSNumber)
    } else if value is NSString {
        let booleans : [String] = ["True", "true", "TRUE", "False", "false", "FALSE"]
        if let _ = booleans.firstIndex(of: (value as! String)) {
            name = DataType.bool.toString()
        }else{
            name = DataType.string.toString()
        }
    } else if value is NSNull {
        name = DataType.generic.toString()
    }
    return name
}

func typeNameForArrayElements(_ elements: NSArray) -> String{
    var typeName : String = ""
    let genericType = DataType.generic.toString()
    if elements.count == 0 {
        typeName = genericType
    }
    
    for element in elements {
        let currElementTypeName = propertyTypeName(element as AnyObject)
        
        if typeName.count == 0 {
            typeName = currElementTypeName
        } else {
            if typeName != currElementTypeName {
                typeName = genericType
                break
            }
        }
    }
    return typeName
}


func typeNameForArrayOfElements(_ elements: NSArray) -> String{
    var typeName : String = ""
    let genericType = "[\(DataType.generic.toString())]"
    if elements.count == 0 {
        typeName = genericType
    }
    for element in elements {
        let currElementTypeName = propertyTypeName(element as AnyObject)
        
        let arrayTypeName = "[\(currElementTypeName)]"
        
        if typeName.count == 0 {
            typeName = arrayTypeName
        } else {
            if typeName != arrayTypeName {
                typeName = genericType
                break
            }
        }
    }
    
    return typeName
}

func typeForNumber(_ number : NSNumber) -> String
{
    let numberType = CFNumberGetType(number as CFNumber)
    
    var typeName : String = ""
    switch numberType {
    case .charType:
        if (number.int32Value == 0 || number.int32Value == 1){
            typeName = DataType.bool.toString()
        }else{
            typeName = DataType.character.toString()
        }
    case .shortType, .intType:
        typeName = DataType.int.toString()
    case .floatType, .float32Type, .float64Type:
        typeName = DataType.float.toString()
    case .doubleType, .longType, .longLongType:
        typeName = DataType.double.toString()
    default:
        typeName = DataType.int.toString()
    }
    
    return typeName
}

func unionDictionaryFromArrayElements(_ array: NSArray) -> NSDictionary
{
    let dictionary = NSMutableDictionary()
    for item in array {
        if let dic = item as? NSDictionary {
            for key in dic.allKeys as! [String] {
                dictionary[key] = dic[key]
            }
        }
    }
    return dictionary
}


func stringByRemovingControlCharacters(_ string: String) -> String
{
    let controlChars = CharacterSet.controlCharacters
    var range = string.rangeOfCharacter(from: controlChars)
    var cleanString = string;
    while range != nil && !range!.isEmpty {
        cleanString = cleanString.replacingCharacters(in: range!, with: "")
        range = cleanString.rangeOfCharacter(from: controlChars)
    }
    return cleanString
}

func runOnBackground(_ task: @escaping () -> Void)
{
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
        task();
    }
}

func runOnUiThread(_ task: @escaping () -> Void)
{
    DispatchQueue.main.async(execute: { () -> Void in
        task();
    })
}
