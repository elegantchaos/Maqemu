// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct ContentView: View {
    let document: Document
    
    var optionKeys: [String] {
        document.settings.options.keys.map({ String($0) })
    }
    
    var body: some View {
        let settings = document.settings
        let disks = settings.disks
        let options = settings.options
        
        return ScrollView {
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
                
                Section(header: Text("Options").font(.headline)) {
                    ForEach(self.optionKeys, id: \.self) { key in
                        HStack {
                            Text(key)
                            Text(options[key]!)
                        }
                    }
                }
                
                Section(header: Text("Extra Parameters").font(.headline)) {
                    ForEach(settings.extras, id: \.self) { extra in
                        Text(extra)
                    }
                }
                
                Section() {
                    Button(action: self.run) {
                        Text("Run")
                    }
                }
            }.padding()
        }
    }
    
    func run() {
        do {
            try document.run()
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
