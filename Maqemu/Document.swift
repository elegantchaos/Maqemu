//
//  Document.swift
//  Maqemu
//
//  Created by Sam Deane on 09/04/2020.
//  Copyright © 2020 Elegant Chaos. All rights reserved.
//

import Cocoa
import SwiftUI

class Document: NSDocument {

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view.
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: contentView)
        let windowController = NSWindowController(window: window)
        self.addWindowController(windowController)
    }

    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        guard let data = "".data(using: .utf8) else {
                    throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
        
        let runner = FileWrapper(regularFileWithContents: data)
        return FileWrapper(directoryWithFileWrappers: ["run.sh": runner])
    }
    
//    override func data(ofType typeName: String) throws -> Data {
//        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
//        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
//    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        switch typeName {
            case "com.elegantchaos.maqemu":
                break
            
            default:
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }


}
