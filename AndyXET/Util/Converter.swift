//
//  Converter.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/28.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

struct ARGB {
    let a: UInt64
    let r: UInt64
    let g: UInt64
    let b: UInt64
}

struct Converter {
    static func argb(hexStr: String) -> ARGB {
        var tmpHexStr = hexStr.replacingOccurrences(of: "#", with: "")
        tmpHexStr = tmpHexStr.replacingOccurrences(of: "0x", with: "")
        let value = tmpHexStr.withCString{strtoull($0, nil, 16)}
        var a = (value >> 24) & 0xFF
        let r = (value >> 16) & 0xFF
        let g = (value >> 8) & 0xFF
        let b = (value >> 0) & 0xFF
        if value > 0, a == 0 {
            a = 0xFF;
        }
        return ARGB(a:a, r: r, g: g, b: b)
    }
}
