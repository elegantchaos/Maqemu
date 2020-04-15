// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 14/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import Foundation

class QemuSettings: Codable, ObservableObject {
    @Published var disks: [String] = []
    @Published var cds: [String] = []
    @Published var devices: [String] = []
    @Published var options: [String:String] = [:]
    @Published var extras: [String] = []
    
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


import Foundation
import SwiftUI
extension Published:Encodable where Value:Decodable {
    public func encode(to encoder: Encoder) throws {
        let mirror = Mirror(reflecting: self)
        if let valueChild = mirror.children.first(where: { (child) -> Bool in
            child.label == "value"
        }) {
            if let value = valueChild.value as? Encodable {
                do {
                    try value.encode(to: encoder)
                    return
                } catch let error {
                    assertionFailure("Failed encoding: \(self) - \(error)")
                }
            }
            else {
                assertionFailure("Decodable Value not decodable. Odd \(self)")
            }
        }
        else {
            assertionFailure("Mirror Mirror on the wall - why no value y'all : \(self)")
        }
    }
}
extension Published:Decodable where Value:Decodable {
    public init(from decoder: Decoder) throws {
        self = Published(initialValue:try Value(from:decoder))
    }
}
