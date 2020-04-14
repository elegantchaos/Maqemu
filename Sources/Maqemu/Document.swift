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

struct VMSettings: Codable {
    var disks: [String] = []
    var devices: [String] = []
    var options: [String:String] = [:]
    var extras: [String] = []
}

class Document: NSDocument {
    var settings = VMSettings()
    
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
                settings = try decoder.decode(VMSettings.self, from: data)
            }
        }
    }
    
    var arguments: [String] {
        var arguments = [
            "-L", "pc-bios",
        ]

        if let name = displayName {
            arguments.append("-name")
            arguments.append(name)
        }
        
        let optionKeys = [
            "machine": "-M",
            "memory": "-m",
            "keyboard layout": "-k",
            "boot order": "-boot"
        ]
        
        for (key,value) in settings.options {
            arguments.append(optionKeys[key]!)
            arguments.append(value)
        }
        
        for device in settings.devices {
            arguments.append("-device")
            arguments.append(device)
        }
        
        arguments.append(contentsOf: settings.extras)
        let disks = settings.disks
        let count = disks.count
        var index = 0
        for letter in "abcdefghijklmnopqrstuvwxyz" {
            if index == count {
                break
            }

            let disk = settings.disks[index]
            let path = fileURL!.appendingPathComponent(disk).path
            arguments.append("-hd\(letter)")
            arguments.append(path)
            index += 1
        }
        
        return arguments
    }
    
    func run() throws {
        if let qemuURL = Bundle.main.url(forResource: "qemu", withExtension: "") {
            let exeURL = qemuURL.appendingPathComponent("qemu-system-ppc")
            let qemu = Runner(for: exeURL, cwd: qemuURL)
            
            Swift.print(exeURL)
            Swift.print(arguments)
            
            let result = try qemu.sync(arguments: arguments)
            Swift.print(result.status)
            Swift.print(result.stdout)
            Swift.print(result.stderr)
            Swift.print("done")
        }
    }
}

