// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Cocoa
import Files
import Runner
import SwiftUI
import SwiftUIExtensions

extension String {
    fileprivate static var settingsFilename = "settings.json"
}




class Document: NSDocument, ObservableObject {
    @Published var settings = QemuSettings()
    var existingWrapper: FileWrapper?
    var rootWrapper: FileWrapper { existingWrapper ?? makeWrapper() }
    var process: Runner.RunningProcess? = nil

    var arguments: [String] { return settings.arguments(name: displayName, relativeTo: fileURL) }
    
    enum DiskType: String, CaseIterable {
        case raw = "Raw"
        case qcow2 = "QCow2"
    }
    
    override init() {
        super.init()
    }
    
    init(sample: Bool) {
        super.init()
        settings.disks.append("Disk 1")
        settings.cds.append("CD 1")
    }
    
    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        let windowController = DocumentWindowController()
        self.addWindowController(windowController)
        windowController.setupContent()
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        let wrapper = rootWrapper
        let encoder = JSONEncoder()
        let data = try encoder.encode(settings)
        if let oldSettings = wrapper.fileWrappers?[.settingsFilename] {
            wrapper.removeFileWrapper(oldSettings)
        }
        wrapper.addRegularFile(withContents: data, preferredFilename: .settingsFilename)
        return wrapper
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        switch typeName {
        case "com.elegantchaos.maqemu":
            try read(wrapper: fileWrapper)
            
        default:
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
    
    func makeWrapper() -> FileWrapper {
        let wrapper = FileWrapper(directoryWithFileWrappers: [:])
        self.existingWrapper = wrapper
        return wrapper
    }
    
    func read(wrapper: FileWrapper) throws {
        existingWrapper = wrapper
        if let json = wrapper.fileWrappers?[.settingsFilename] {
            if let data = json.regularFileContents {
                let decoder = JSONDecoder()
                settings = try decoder.decode(QemuSettings.self, from: data)
            }
        }
    }
    
    func run(consoleCallback: @escaping Runner.PipeCallback) throws {
        if let qemuURL = Bundle.main.url(forResource: "qemu", withExtension: "") {
            let exeURL = qemuURL.appendingPathComponent("qemu-system-ppc")
            let qemu = Runner(for: exeURL, cwd: qemuURL)
            
            process = try qemu.async(arguments: arguments, stdoutMode: .callback(consoleCallback), stderrMode: .callback(consoleCallback))
        }
    }
    
    func addDisk(name: String, size: Int, type: Document.DiskType) {
        let url = FileManager.default.newDocumentURL(name: name, withPathExtension: type.rawValue)
        do {
            try "test".write(to: url, atomically: true, encoding: .utf8)
            let diskWrapper = try FileWrapper(url: url)
            rootWrapper.addFileWrapper(diskWrapper)
            settings.disks.append(url.lastPathComponent)
        } catch {
            // TODO: handle error
        }
    }
    
}

