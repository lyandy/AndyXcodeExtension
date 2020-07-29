//
//  Regex.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/28.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

struct Regex {
    static func check(string: String, pattern: String) -> NSRange? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        return regex?.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count))?.range
    }
}
