//
//  Attribute.swift
//  
//
//  Created by yzj on 2022/11/12.
//

import Foundation

public enum Attribte: Hashable {
    case name(String)
    case content(String)
    case property(String)
    case id(String)
    case rel(String)
    case href(String)
    case unparsed(String)

    public init(rawValue: String) {
        let components = rawValue.components(separatedBy: "=")

        if components.count != 2 {
            self = .unparsed(rawValue)
        }

        let key = components.first ?? ""
        let value = components.last ?? ""

        switch key {
        case "id": self = .id(value)
        case "name": self = .name(value)
        case "property": self = .property(value)
        case "content": self = .content(value)
        case "rel": self = .rel(value)
        case "href": self = .href(value)

        default: self = .unparsed(rawValue)
        }
    }

    public init(key: String, value: String) {
        switch key {
        case "id": self = .id(value)
        case "name": self = .name(value)
        case "property": self = .property(value)
        case "content": self = .content(value)
        case "rel": self = .rel(value)
        case "href": self = .href(value)

        default: self = .unparsed("\(key)<*>\(value)")
        }
    }
}
