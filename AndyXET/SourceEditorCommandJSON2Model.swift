//
//  SourceEditorCommandJSON2Model.swift
//  AndyXET
//
//  Created by 李扬 on 2020/7/28.
//  Copyright © 2020 李扬. All rights reserved.
//

import AppKit
import XcodeKit

class SourceEditorCommandJSON2Model: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(nil)
            return
        }

        runOnUIThread {
            let string = NSPasteboard.general.string(forType: .string)
            runOnBackground {
                let contentBuilder = SwiftContentBuilder(string)
                
                // 光标处 插入代码
                let lines = invocation.buffer.lines
                lines.insert(contentBuilder.toString(), at: selection.end.line)
                
                completionHandler(nil)
            }
        }
    }
}

