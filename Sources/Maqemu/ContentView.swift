//
//  ContentView.swift
//  Maqemu
//
//  Created by Sam Deane on 09/04/2020.
//  Copyright © 2020 Elegant Chaos. All rights reserved.
//

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
        print("run me baby")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: Document())
    }
}
