// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct ContentView: View {
    let document: Document
    
    var body: some View {
        
        VStack {
            Spacer()
            Text(String(describing: document.settings))
            Button(action: self.run) {
                Text("Run")
            }
            Spacer()
        }
        .frame(width: 512.0, height: 512.0)

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
