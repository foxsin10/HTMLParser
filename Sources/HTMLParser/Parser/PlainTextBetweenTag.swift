//
//  PlainTagParser.swift
//
//
//  Created by yzj on 2022/11/12.
//

import Foundation

import Parsing

public struct PlainTextBetweenTag: Parser {
    @usableFromInline
    let tag: TagRepresentable

    @inlinable
    public init(tag: String) {
        self.tag = TagRepresentable(rawValue: tag)
    }

    @inlinable
    public init(tag: TagRepresentable) {
        self.tag = tag
    }

    public var body: some Parser<Substring.UTF8View, Tags> {
        Parse {
            "<\(tag.rawValue)>".utf8
            PrefixUpTo("</\(tag.rawValue)>".utf8)
            "</\(tag.rawValue)>".utf8
        }
        .map { result -> Tags in
            switch self.tag {
            case .title: return .title(attribute: "", content: String(result) ?? "")
            case .style: return .style(attribute: "", content: String(result) ?? "")
            default: return .unkown(tag: tag.rawValue, content: String(result) ?? "")
            }
        }
    }
}
