// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: Document
    @EnvironmentObject var sheetController: SheetController
    @State var console: String = ""
    
    var optionKeys: [String] {
        document.settings.options.keys.map({ String($0) })
    }
    
    var body: some View {
        let settings = document.settings
        let options = settings.options
        
        return VStack(alignment: .leading) {
            ScrollView {
                Form {
                    DisksView(label: "Drives", disks: $document.settings.disks)
                    DisksView(label: "CDs", disks: $document.settings.cds)

                    Section(header: Text("Devices").font(.headline).padding(.top)) {
                        Group {
                            ForEach(document.settings.devices, id: \.self) { device in
                                HStack {
                                    Text(device)
                                }
                            }
                        }.padding(.leading)
                    }
                    
                    Section(header: Text("Options").font(.headline).padding(.top)) {
                        ForEach(self.optionKeys, id: \.self) { key in
                            HStack {
                                Text(key)
                                Text(options[key]!)
                            }
                        }.padding(.leading)
                    }
                    
                    Section(header: Text("Extra Parameters").font(.headline).padding(.top)) {
                        ForEach(settings.extras, id: \.self) { extra in
                            Text(extra)
                        }.padding(.leading)
                    }
                }
            }.padding()
                
            
            Group {
                HStack(alignment: .bottom) {
                    TextField("Console", text: $console).font(.caption)
                    Button(action: handleRun) {
                        Text("Run")
                    }
                }
            }.padding()
        }
            .frame(minWidth: 640, minHeight: 480)
            .onAppear(perform: handleAppear)
            .onDisappear(perform: handleDisappear)
            .sheet(isPresented: $sheetController.isPresented) { self.document.sheetController.viewMaker!() }
    }
    
    var initialConsole: String {
        let args = document.arguments.joined(separator: " ")
        return "> qemu.system.ppc \(args)"
    }

    func handleAppear() {
        self.console = self.initialConsole
    }
    
    func handleDisappear() {
        
    }
    
    func handleRun() {
        do {
            console = ""
            let appendConsole = { (string: String) in self.console.append(string) }
            try document.run(consoleCallback: appendConsole)
        } catch {
            console = "Failed to run QEMU.\n\n"
            console.append(String(describing: error))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView().environmentObject(Document(sample: true))
    }
}

extension String: Identifiable {
    public var id: String { return self }
}
