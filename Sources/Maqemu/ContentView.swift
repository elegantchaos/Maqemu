// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var document: Document
    @State var console: String = ""
//    @State var cds: [String] = []
//    @State var disks: [String] = []
    
    var optionKeys: [String] {
        document.settings.options.keys.map({ String($0) })
    }
    
    var body: some View {
        let settings = document.settings
        let options = settings.options
        
        return VStack(alignment: .leading) {
            ScrollView {
                Form {
                    Section(header: Text("Drives").font(.headline)) {
                        DiskList(disks: $document.settings.disks)
                    }

                    Section(header: Text("CDs").font(.headline)) {
                        DiskList(disks: $document.settings.cds)
                    }

                    Section(header: Text("Devices").font(.headline).padding(.top)) {
                        Group {
                            ForEach(document.settings.devices, id: \.self) { device in
                                HStack {
                                    Text(device)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Options").font(.headline).padding(.top)) {
                        ForEach(self.optionKeys, id: \.self) { key in
                            HStack {
                                Text(key)
                                Text(options[key]!)
                            }
                        }
                    }
                    
                    Section(header: Text("Extra Parameters").font(.headline).padding(.top)) {
                        ForEach(settings.extras, id: \.self) { extra in
                            Text(extra)
                        }
                    }
                }
            }.padding()
                
            
            Group {
                HStack(alignment: .bottom) {
                    TextField("Console", text: $console).font(.caption).lineLimit(5)
                    Button(action: self.run) {
                        Text("Run")
                    }
                }
            }.padding()
        }
            .frame(minWidth: 640, minHeight: 480)
            .onAppear() {
                self.console = self.initialConsole
//                self.disks = settings.disks
//                self.cds = settings.cds
            }
            .onDisappear() {
//                settings.disks = self.disks
//                settings.cds = self.cds
            }
    }
    
    var initialConsole: String {
        let args = document.arguments.joined(separator: " ")
        return "> qemu.system.ppc \(args)"
    }
    
    func run() {
        do {
            console = ""
            let appendConsole = { (string: String) in self.console.append(string) }
            try document.run(consoleCallback: appendConsole)
        } catch {
            print("failed to run")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Document())
    }
}

extension String: Identifiable {
    public var id: String { return self }
}

struct DiskList: View {
    @Binding var disks: [String]
    
    var body: some View {
//        List(disks) { disk in
        Group {
            ForEach(disks, id: \.self) { disk in
                HStack {
                    Text("#\(self.disks.firstIndex(of: disk)!)")
                    Text(disk)
                    Spacer()
                    Button(action: { self.removeDisk(disk) }) {
                        Image("Minus").resizable().frame(width: 16, height: 16)
                    }
                }
            }

            Button(action: addDisk) {
                Image("Plus").resizable().frame(width: 16, height: 16)
            }
        }.buttonStyle(PlainButtonStyle())
    }
    
    func addDisk() {
//        let new = disks + ["New Disk"]
//        disks = new
        disks.append("New Disk")
    }
    
    func removeDisk(_ disk: String) {
        if let index = disks.firstIndex(of: disk) {
            var modified = disks
            modified.remove(at: index)
            disks = modified
        }
    }
}
