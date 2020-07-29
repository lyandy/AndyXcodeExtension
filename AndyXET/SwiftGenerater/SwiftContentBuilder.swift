//
//  SwiftContentBuilder.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/29.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

class SwiftContentBuilder {
    
    private lazy var representers: [SwiftModelRepresenter] = []
    
    init(_ json: String?) {
        let str = stringByRemovingControlCharacters(mm_safes(json))
        if let data = str.data(using: .utf8) {
            do {
                let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
                var jsonDict: NSDictionary
                if jsonData is NSDictionary {
                    jsonDict = jsonData as! NSDictionary
                } else {
                    jsonDict = unionDictionaryFromArrayElements(jsonData as! NSArray)
                }
                self.build("RootClass", jsonObject: jsonDict)
            } catch let err as NSError {
                print(err)
            } catch {
                fatalError()
            }
        }
    }
    
    private func build(_ className: String, jsonObject: NSDictionary) {
        var properties = [Property]()
        
        let jsonProperties = (jsonObject.allKeys as! [String]).sorted()
               
        for jsonPropertyName in jsonProperties {
            let value : AnyObject = jsonObject[jsonPropertyName]! as AnyObject
            let property = propertyForValue(value, jsonKeyName: jsonPropertyName)

            if let _ = properties.map({$0.jsonName}).firstIndex(of: property.jsonName) {
                continue
            }

            if property.isCustomClass {
                build(property.type, jsonObject: value as! NSDictionary)
            } else if property.isArray {
                let array = value as! NSArray
                if array.firstObject is NSDictionary {
                    let type = property.elementsType
                    let allProperties = unionDictionaryFromArrayElements(array);
                    build(type, jsonObject: allProperties)
                }
            }
            properties.append(property)
        }

        if let _ = representers.map({$0.className}).firstIndex(of: className) {
            return
        }
        let modelRepresenter = SwiftModelRepresenter(className, properties)
        representers.append(modelRepresenter)
    }

    private func propertyForValue(_ value: AnyObject, jsonKeyName: String) -> Property {
        var type = propertyTypeName(value)
        
        var property: Property
        
        if value is NSDictionary {
            type = typeNameForPropertyName(jsonKeyName)
            property = Property(jsonName: jsonKeyName, type: type, isArray:false, isCustomClass: true)
        } else if value is NSArray {
            let array = value as! NSArray
                
            if array.firstObject is NSDictionary {
                let leafClassName = typeNameForPropertyName(jsonKeyName)

                type = "[\(leafClassName)]"
                    
                property = Property(jsonName: jsonKeyName, type: type, isArray: true, isCustomClass: false)
                property.elementsType = leafClassName
                    
                property.elementsAreOfCustomType = true
            } else {
                property = Property(jsonName: jsonKeyName, type: type, isArray: true, isCustomClass: false)
                property.elementsType = typeNameForArrayElements(value as! NSArray)
            }
            
        } else {
            property = Property(jsonName: jsonKeyName, type: type)
        }
        property.sampleValue = value
        return property
    }

    func toString() -> String {
        var result: String = "// RootClass.Swift \n"
        result += "// Model file generated using AndyXET->JSON2Swift: \n\n\n"
        result += "import Foundation\n"
        result += "import KakaJSON\n"
        
        for rep in representers {
            result += "\n\n"
            result += "struct \(rep.className): Convertible {\n"
            for property in rep.properties {
                result += "    \(property.toString())\n"
            }
            result += "}\n"
        }
        
        return result
    }
}
