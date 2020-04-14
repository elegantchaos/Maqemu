// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

struct QemuSettings: Codable {
    var disks: [String] = []
    var devices: [String] = []
    var options: [String:String] = [:]
    var extras: [String] = []
    
    func arguments(name: String, relativeTo fileURL: URL?) -> [String] {
        var arguments = [
            "-L", "pc-bios",
            "-name", name
        ]

        let optionKeys = [
            "machine": "-M",
            "memory": "-m",
            "language": "-k",
            "boot order": "-boot"
        ]
        
        for (key,value) in options {
            arguments.append(optionKeys[key]!)
            arguments.append(value)
        }
        
        for device in devices {
            arguments.append("-device")
            arguments.append(device)
        }
        
        arguments.append(contentsOf: extras)
        let count = disks.count
        var index = 0
        for letter in "abcdefghijklmnopqrstuvwxyz" {
            if index == count {
                break
            }

            let disk = disks[index]
            let path = fileURL!.appendingPathComponent(disk).path
            arguments.append("-hd\(letter)")
            arguments.append(path)
            index += 1
        }
        
        return arguments
    }
    
}
