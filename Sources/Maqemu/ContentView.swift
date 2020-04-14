// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct ContentView: View {
    let document: Document
    @State var console: String = ""
    
    var optionKeys: [String] {
        document.settings.options.keys.map({ String($0) })
    }
    
    var body: some View {
        let settings = document.settings
        let disks = settings.disks
        let options = settings.options
        
        return VStack(alignment: .leading) {
            ScrollView {
                Form {
                    Section(header: Text("Drives").font(.headline)) {
                        Group {
                            ForEach(document.settings.disks, id: \.self) { disk in
                                HStack {
                                    Text("#\(disks.firstIndex(of: disk)!)")
                                    Text(disk)
                                }
                            }
                        }
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
            }
                .padding()
            
            Group {
                HStack(alignment: .bottom) {
                    TextField("Console", text: $console).font(.caption)
                    Button(action: self.run) {
                        Text("Run")
                    }
                }.padding()
            }
        }
            .frame(minWidth: 640, minHeight: 480)
            .onAppear() {
                self.console = self.initialConsole
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
        ContentView(document: Document())
    }
}
