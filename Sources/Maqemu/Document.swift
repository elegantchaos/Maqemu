// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Cocoa
import Runner
import SwiftUI
import SwiftUIExtensions

extension String {
    fileprivate static var settingsFilename = "settings.json"
}

class DocumentWindowController: NSWindowController, ObservableObject {
    var process: Runner.RunningProcess? = nil
    let keyController = KeyController()
    let sheetController = SheetController()

    var qemuDocument: Document { return document as! Document }
    
    init() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        super.init(window: window)

        sheetController.environmentSetter = { view in AnyView(self.applyEnvironment(to: view)) }
    }
    
    func applyEnvironment<T>(to view: T) -> some View where T: View {
        return view
            .environmentObject(qemuDocument)
            .environmentObject(sheetController)
            .environmentObject(keyController)
            .environmentObject(self)
    }
    
    func setupContent() {
        let contentView = applyEnvironment(to: ContentView())
        window?.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    func run(consoleCallback: @escaping Runner.PipeCallback) throws {
        if let qemuURL = Bundle.main.url(forResource: "qemu", withExtension: "") {
            let exeURL = qemuURL.appendingPathComponent("qemu-system-ppc")
            let qemu = Runner(for: exeURL, cwd: qemuURL)

            process = try qemu.async(arguments: qemuDocument.arguments, stdoutMode: .callback(consoleCallback), stderrMode: .callback(consoleCallback))
        }
    }
    
    func addDisk(name: String, size: Int, type: Document.DiskType) {
        
        qemuDocument.settings.disks.append("\(name) \(size).\(type)")
    }
}


class Document: NSDocument, ObservableObject {
    @Published var settings = QemuSettings()
    var wrapper: FileWrapper?
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
        let wrapper = self.wrapper ?? makeWrapper()
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
                try read(vm: fileWrapper)
            
            default:
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }

    func makeWrapper() -> FileWrapper {
        let wrapper = FileWrapper(directoryWithFileWrappers: [:])
        self.wrapper = wrapper
        return wrapper
    }
    
    func read(vm: FileWrapper) throws {
        wrapper = vm
        if let json = vm.fileWrappers?[.settingsFilename] {
            if let data = json.regularFileContents {
                let decoder = JSONDecoder()
                settings = try decoder.decode(QemuSettings.self, from: data)
            }
        }
    }
    
    
}

