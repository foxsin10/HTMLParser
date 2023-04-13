//
//  TagRepresentable.swift
//  
//
//  Created by yzj on 2022/11/12.
//

import Foundation

public struct TagRepresentable: RawRepresentable, Hashable {
    public var rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static var meta: Self { .init(rawValue: "meta") }
    public static var link: Self { .init(rawValue: "link") }
    public static var title: Self { .init(rawValue: "title") }
    public static var style: Self { .init(rawValue: "style") }
    public static var script: Self { .init(rawValue: "script") }
}
