// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 17/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import AppKit
import Runner
import SwiftUIExtensions
import SwiftUI

class DocumentWindowController: NSWindowController, ObservableObject {
    let keyController = KeyController()
    let sheetController = SheetController()

    var qemuDocument: Document { return document as! Document }
    
    init() {
        let rect = NSRect(origin: .zero, size: NSSize(width: 480, height: 300))
        let mask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView]
        let window = NSWindow(contentRect: rect, styleMask: mask, backing: .buffered, defer: false)
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
   
}
