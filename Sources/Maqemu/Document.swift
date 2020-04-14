//
//  Document.swift
//  Maqemu
//
//  Created by Sam Deane on 09/04/2020.
//  Copyright © 2020 Elegant Chaos. All rights reserved.
//

import Cocoa
import Runner
import SwiftUI

class Document: NSDocument {
    var settings = QemuSettings()
    var process: Runner.RunningProcess? = nil
    var console: String = ""
    
    override init() {
        super.init()
        
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(document: self)

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
        let encoder = JSONEncoder()
        let data = try encoder.encode(settings)
        let json = FileWrapper(regularFileWithContents: data)
        return FileWrapper(directoryWithFileWrappers: ["settings.json": json])
    }
    
//    override func data(ofType typeName: String) throws -> Data {
//        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
//        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
//    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        switch typeName {
            case "com.elegantchaos.maqemu":
                try read(vm: fileWrapper)
            
            default:
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }

    func read(vm: FileWrapper) throws {
        if let json = vm.fileWrappers?["settings.json"] {
            if let data = json.regularFileContents {
                let decoder = JSONDecoder()
                settings = try decoder.decode(QemuSettings.self, from: data)
            }
        }
    }
    
    
    var arguments: [String] { return settings.arguments(name: displayName, relativeTo: fileURL) }
    
    func run(consoleCallback: @escaping Runner.PipeCallback) throws {
        if let qemuURL = Bundle.main.url(forResource: "qemu", withExtension: "") {
            let exeURL = qemuURL.appendingPathComponent("qemu-system-ppc")
            let qemu = Runner(for: exeURL, cwd: qemuURL)

            process = try qemu.async(arguments: arguments, stdoutMode: .callback(block: consoleCallback), stderrMode: .callback(block: consoleCallback))
        }
    }
}

