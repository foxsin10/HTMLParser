//
//  Meta.swift
//
//
//  Created by yzj on 2022/11/12.
//

import Foundation

import Parsing

public struct Meta: Parser {
    public init() {}

    @inlinable
    public var body: some Parser<Substring.UTF8View, Tags> {
        AngleBracktsContent(tag: .meta)
    }
}
