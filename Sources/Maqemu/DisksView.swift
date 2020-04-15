// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

struct DisksView: View {
    let label: String
    
    @Binding var disks: [String]
    @EnvironmentObject var sheetController: SheetController
    
    var body: some View {
        let size: CGFloat = 12.0
        
        return Section(header: Text(label).font(.headline)) {
            Group {
                VStack(alignment: .leading) {
                    ForEach(disks, id: \.self) { disk in
                        HStack {
                            Button(action: { self.removeDisk(disk) }) {
                                Image("Minus").resizable().frame(width: size, height: size)
                            }
                            Text(disk)
                        }
                    }
                    
                    HStack {
                        Button(action: addDisk) {
                            Image("Plus").resizable().frame(width: size, height: size)
                            Text("add another disk").foregroundColor(.gray)
                        }
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.leading)
            .environment(\.defaultMinListRowHeight, 10)
        }
    }
    
    func addDisk() {
        sheetController.show() {
            return AnyView(
                AddDiskView(disks: self.$disks).environmentObject(self.sheetController)
            )
        }
//        let panel = NSOpenPanel()
//        panel.runModal()
//
//        disks.append("New Disk")
    }
    
    func removeDisk(_ disk: String) {
        if let index = disks.firstIndex(of: disk) {
            disks.remove(at: index)
        }
    }
}
