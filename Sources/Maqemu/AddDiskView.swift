// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI
import SwiftUIExtensions

struct AddDiskView: View {
    @EnvironmentObject var sheetController: SheetController
    @EnvironmentObject var keyController: KeyController
    
    @Binding var disks: [String]
    
    @State var name: String = "Unitled"
    @State var size: Double = 1000.0
    @State var type: Int = 0
    
    let types = ["Raw", "QCow2"]
    
    var body: some View {
        return Form {
            VStack {
                Text("Create New Disk").font(.headline)
                
                Spacer()
                
                HStack {
                    Text("name")
                    TextField("name", text: $name)
                }
                
                HStack {
                    Text("size")
                    TextField("name", value: $size, formatter: NumberFormatter())
                    Stepper(onIncrement: { self.size += 100 }, onDecrement: { self.size -= 100 }) {
                        Text("Mb")
                    }
                }
                
                HStack {
                    Picker(selection: $type, label: Text("Type")) {
                        ForEach(types) { type in
                            Text(type)
                        }
                    }
                }
                
                HStack {
                    Button(action: handleCancel) {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    Button(action: handleAdd) {
                        Text("Create Disk")
                    }.buttonStyle(BorderedButtonStyle())
                    
                }
            }
        }
        .padding()
        .onAppear(perform: handleAppear)
    }
    
    func handleAppear() {
        keyController.upTriggers[36] = {
            self.handleAdd()
            return true
        }
        keyController.upTriggers[53] = {
            self.handleCancel()
            return true
        }
    }
    
    func handleCancel() {
        sheetController.dismiss()
    }
    
    func handleAdd() {
        sheetController.dismiss()
        DispatchQueue.main.async { self.addDisk() }
    }
    
    func addDisk() {
        let selectedType = types[type]
        let selectedSize = Int(size)
        disks.append("\(name) \(selectedSize).\(selectedType)")
    }
    
}