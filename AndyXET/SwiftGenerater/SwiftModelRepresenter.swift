//
//  SwiftModelRepresenter.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/29.
//  Copyright © 2020 李扬. All rights reserved.
//

import Foundation

struct SwiftModelRepresenter {
    var className: String
    var properties: [Property]
    
    init(_ className: String, _ properties: [Property]) {
        self.className = className
        self.properties = properties
    }
    
    func toString() -> String {
        return ""
    }
}
