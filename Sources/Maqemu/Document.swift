// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Cocoa
import Runner
import SwiftUI
import SwiftUIExtensions

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
    }
    
    func setupContent() {
        let contentView = ContentView()
            .environmentObject(qemuDocument)
            .environmentObject(sheetController)
            .environmentObject(keyController)
            .environmentObject(self)

        window?.contentView = NSHostingView(rootView: contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

//    override func keyUp(with event: NSEvent) {
//        keypressManager.keyUp(with: event)
//    }
//
//    override func keyDown(with event: NSEvent) {
//        keypressManager.keyDown(with: event)
//    }

    func run(consoleCallback: @escaping Runner.PipeCallback) throws {
        if let qemuURL = Bundle.main.url(forResource: "qemu", withExtension: "") {
            let exeURL = qemuURL.appendingPathComponent("qemu-system-ppc")
            let qemu = Runner(for: exeURL, cwd: qemuURL)

            process = try qemu.async(arguments: qemuDocument.arguments, stdoutMode: .callback(block: consoleCallback), stderrMode: .callback(block: consoleCallback))
        }
    }
}


class Document: NSDocument, ObservableObject {
    @Published var settings = QemuSettings()
    
    var arguments: [String] { return settings.arguments(name: displayName, relativeTo: fileURL) }


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
    
    
}

