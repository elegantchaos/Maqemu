// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 15/04/2020.
//  All code (c) 2020 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

// see: https://blog.hobbyistsoftware.com/2020/01/adding-codeable-to-published/

import Foundation
import SwiftUI

extension Published: Encodable where Value: Decodable {
    public func encode(to encoder: Encoder) throws {
        let mirror = Mirror(reflecting: self)
        if let valueChild = mirror.children.first(where: { $0.label == "value" }) {
            if let value = valueChild.value as? Encodable {
                try value.encode(to: encoder)
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

extension Published: Decodable where Value: Decodable {
    public init(from decoder: Decoder) throws {
        self = Published(initialValue:try Value(from:decoder))
    }
}
