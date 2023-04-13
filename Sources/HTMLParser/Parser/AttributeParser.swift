//
//  AttributeParser.swift
//
//
//  Created by yzj on 2022/11/12.
//

import Foundation

import Parsing

@_spi(TagAttributeParsing)
public struct AttributeParser: Parser {
    public init() {}

    public var body: some Parser<Substring.UTF8View, [Attribte]> {
        Parse {
            Many {
                OneOf {
                    " name=".utf8
                        .map { "name"[...].utf8 }
                    " content=".utf8
                        .map { "content"[...].utf8 }
                    " id=".utf8
                        .map { "id"[...].utf8 }
                    " property=".utf8
                        .map { "property"[...].utf8 }
                    " rel=".utf8
                        .map { "rel"[...].utf8 }
                    " href=".utf8
                        .map { "href"[...].utf8 }

                    PrefixUpTo("=".utf8)
                        .map { $0 }
                }

                Rest()
            }
        }
        .map { pairs in
            pairs.map { pair in
                Attribte(
                    key: String(pair.0) ?? "",
                    value: String(pair.1) ?? ""
                )
            }
        }
    }
}
