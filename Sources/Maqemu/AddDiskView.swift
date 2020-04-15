// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct AddDiskView: View {
    @EnvironmentObject var sheetController: SheetController
    @Binding var disks: [String]
    @State var name: String = "Unitled"
    
    var body: some View {
        return VStack {
            HStack {
                Text("name")
                TextField("name", text: $name)
            }
            
            Button(action: handleAdd) {
                Text("Create Disk")
            }
        }.padding()
    }
    
    func handleAdd() {
        disks.append(name)
        sheetController.dismiss()
    }
    
}
