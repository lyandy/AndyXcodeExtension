//
//  StringExtension.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/29.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

extension String {
    func toSingular() -> String
    {
        var singular = self
        let length = self.count
        if length > 3 {
            let range = self.index(self.endIndex, offsetBy: -3)..<self.endIndex
            
            let lastThreeChars = self[range]
            if lastThreeChars == "ies" {
                singular = self.replacingOccurrences(of: lastThreeChars, with: "y", options: [], range: range)
                return singular
            }
        }
        if length > 2 {
            let range = self.index(self.endIndex, offsetBy: -1)..<self.endIndex
            
            let lastChar = self[range]
            if lastChar == "s" {
                singular = self.replacingOccurrences(of: lastChar, with: "", options: [], range: range)
                return singular
            }
        }
        return singular
    }
    
    func lowercaseFirstChar() -> String {
        if self.count > 0 {
            let range = self.startIndex..<self.index(self.startIndex, offsetBy: 1)
            
            let firstLowerChar = self[range].lowercased()
            
            return self.replacingCharacters(in: range, with: firstLowerChar)
        } else {
            return self
        }
        
    }
    
    func uppercaseFirstChar() -> String{
        if self.count > 0 {
            let range = startIndex..<self.index(startIndex, offsetBy: 1)
            
            let firstUpperChar = self[range].uppercased()
            
            return self.replacingCharacters(in: range, with: firstUpperChar)
        } else {
            return self
        }
    }
}
