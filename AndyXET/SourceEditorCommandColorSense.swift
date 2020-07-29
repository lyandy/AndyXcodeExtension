//
//  SourceEditorCommandColorSense.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/28.
//  Copyright © 2020 李扬. All rights reserved.
//

import AppKit
import XcodeKit

class SourceEditorCommandColorSense: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {

        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(nil)
            return
        }
        
        let linesArr = invocation.buffer.lines
        let lineNumber = selection.start.line
        guard lineNumber < linesArr.count, let lineStr = linesArr[lineNumber] as? String else {
            completionHandler(nil)
            return
        }
        
        guard let hexStr = findHexStr(string: lineStr) else {
            completionHandler(nil)
            return
        }
        
        let newLine = process(lineStr: lineStr, hexStr: hexStr)
        linesArr.replaceObject(at: lineNumber, with: newLine)
        
        completionHandler(nil)
    }
    
    func findHexStr(string: String) -> String? {
        let pattern = "\"(#|0x)?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})\""
        guard let range = Regex.check(string: string, pattern: pattern) else {
            return nil
        }
        
        return (string as NSString).substring(with: range)
    }
    
    func process(lineStr: String, hexStr: String) -> String {
        let tmpLineStr = lineStr.replacingOccurrences(of: "\n", with: "")
        let tmpHexStr = hexStr.replacingOccurrences(of: "\"", with: "")
        
        if let removedmark = findMarkAndRemove(string: tmpLineStr) {
            return removedmark
        }
        
        let argb = Converter.argb(hexStr: tmpHexStr)
        let literal = "#ColorLiteral(red:\(Double(argb.r) / 255.0), green:\(Double(argb.g) / 255.0), blue:\(Double(argb.b) / 255.0), alpha:\(Double(argb.a) / 255.0)"
        return tmpLineStr.appending(" // color: \(literal)")
    }
    
    func findMarkAndRemove(string: String) -> String? {
        let pattern = " \\/\\/ color: .*"
        guard let range = Regex.check(string: string, pattern: pattern) else {
            return nil
        }
        
        return (string as NSString).substring(to: range.location)
    }
    
}
