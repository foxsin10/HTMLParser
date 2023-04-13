//
//  Attribute.swift
//
//
//  Created by yzj on 2022/11/12.
//

import Foundation

import Parsing

// MARK: Tags, Attribte

public enum Tags: Hashable {
    case meta(String)
    case link(String)
    case title(attribute: String, content: String)
    case base(String)
    case style(attribute: String, content: String)
    case script(attribute: String, content: String)

    case unkown(tag: String, content: String)

    public var content: String {
        switch self {
        case let .meta(content): return content
        case let .link(content): return content
        case let .title(attribute, content): return "\(attribute) *|* \(content)"
        case let .base(content): return content
        case let .style(attribute, content): return "\(attribute) *|* \(content)"
        case let .script(attribute, content): return "\(attribute) *|* \(content)"
        case let .unkown(tag, content): return "\(tag) *|* \(content)"
        }
    }

    public var containMediaInfo: Bool {
        switch self {
        case .meta, .link, .title: return true
        default: return false
        }
    }

    public var isUnkown: Bool {
        if case .unkown = self {
            return true
        }

        return false
    }

    public var isMeta: Bool {
        if case .meta = self {
            return true
        }

        return false
    }

    public var isLink: Bool {
        if case .link = self {
            return true
        }

        return false
    }

    public var isTitle: Bool {
        if case .title = self {
            return true
        }

        return false
    }

    public var isStyle: Bool {
        if case .style = self {
            return true
        }

        return false
    }

    public var isScript: Bool {
        if case .script = self {
            return true
        }

        return false
    }
}

public struct ScriptTagParser: Parser {
    public init() {}

    public func parse(_ input: inout Substring.UTF8View) throws -> Tags {
        var result = try Parse {
            "<script".utf8
            PrefixUpTo("</script>".utf8)
            "</script>".utf8
        }
        .parse(&input)

        _ = result.popLast()
        return .unkown(tag: "script", content: String(result) ?? "")
    }
}
