//
//  ContentTagParser.swift
//
//
//  Created by yzj on 2022/11/12.
//

import Foundation

import Parsing

public struct AngleBracktsContent: Parser {
    @usableFromInline
    let tag: TagRepresentable

    public init(tag: String) {
        self.tag = TagRepresentable(rawValue: tag)
    }

    public init(tag: TagRepresentable) {
        self.tag = tag
    }

    public var body: some Parser<Substring.UTF8View, Tags> {
        Parse {
            "<\(tag.rawValue)".utf8
            PrefixUpTo(">".utf8)
            ">".utf8
        }
        .map { capture -> Tags in
            var temp = capture
            let possibleSuffix = " /".utf8.map { UInt8($0) }
            let suffix = temp.suffix(2).map { UInt8($0) }

            if possibleSuffix == suffix {
                temp.removeLast(2)
            }

            let result = String(temp) ?? ""

            switch tag {
            case .meta: return .meta(result)
            case .link: return .link(result)

            default: return .unkown(tag: tag.rawValue, content: result)
            }
        }
    }
}

public struct AngleBracktsWithAttribute: Parser {
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
            "<\(tag.rawValue)".utf8
            PrefixUpTo(">".utf8)
            ">".utf8

            Optionally {
                PrefixUpTo("</\(tag.rawValue)>".utf8)
                "</\(tag.rawValue)>".utf8
            }
        }
        .map { capture -> Tags in
            let content = String(capture.1 ?? ""[...].utf8) ?? ""

            switch tag {
            case .script:
                if capture.0.isEmpty {
                    return .script(attribute: "", content: content)
                } else {
                    return .script(attribute: String(capture.0) ?? "", content: content)
                }

            case .style:
                if capture.0.isEmpty {
                    return .style(attribute: "", content: content)
                } else {
                    return .style(attribute: String(capture.0) ?? "", content: content)
                }

            case .title:
                if capture.0.isEmpty {
                    return .title(attribute: "", content: content)
                } else {
                    return .title(attribute: String(capture.0) ?? "", content: content)
                }

            default:
                let attribute = String(capture.0) ?? ""
                return .unkown(tag: tag.rawValue, content: attribute + "<|>" + content)
            }
        }
    }
}
