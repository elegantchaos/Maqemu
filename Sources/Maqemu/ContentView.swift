// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct ContentView: View {
    let document: Document
    
    var body: some View {
        
        VStack {
            Form {
                Section(header: Text("Drives")) {
                    ForEach(document.settings.disks, id: \.self) { disk in
                        Text(disk)
                    }
                }
                
                Section(header: Text("Extra Parameters")) {
                    ForEach(document.settings.extras, id: \.self) { extra in
                        Text(extra)
                    }
                }
                
                Section() {
                    Button(action: self.run) {
                        Text("Run")
                    }
                }
            }
        }
        .frame(minWidth: 512.0, minHeight: 512.0)

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
