//
//  Util.swift
//
//
//  Created by yzj on 2022/11/12.
//

import Foundation

import Parsing

public func parseHeadTags(of html: String, includeScript: Bool = false) throws -> [Tags] {
    let input = html.utf8

    let parser = HeadTagsParser()

    if includeScript {
        return try parser.parse(input)
    }

    return try parser.parse(input).lazy.filter(\.containMediaInfo)
}

public func checkMetaTagCount(for html: String, includeAll include: Bool = false) -> Int {
    let headContent = html.components(separatedBy: "</head>")
        .first?
        .components(separatedBy: "<head>")
        .last ?? ""
    let tags = include
        ? ["<meta", "<link", "<title", "<script", "<style"]
        : ["<meta", "<link", "<title"]

    return tags.reduce(into: 0) { totalCount, tag in
        let count = headContent.indicesOf(tag)
        totalCount += count.count
    }
}

extension String {
    func indicesOf(_ string: String) -> [Int] {
        // Converting to an array of utf8 characters makes indicing and comparing a lot easier
        let search = utf8.map { $0 }
        let word = string.utf8.map { $0 }

        var indices = [Int]()

        // m - the beginning of the current match in the search string
        // i - the position of the current character in the string we're trying to match
        var m = 0, i = 0
        while m + i < search.count {
            if word[i] == search[m + i] {
                if i == word.count - 1 {
                    indices.append(m)
                    m += i + 1
                    i = 0
                } else {
                    i += 1
                }
            } else {
                m += 1
                i = 0
            }
        }

        return indices
    }
}
