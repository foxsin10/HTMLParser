//
//  HeadTagsParser.swift
//  
//
//  Created by yzj on 2023/4/13.
//

import Foundation

import Parsing

public struct HeadTagsParser: Parser {
    public init() {}
    
    public var body: some Parser<Substring.UTF8View, [Tags]> {
        Parse {
           Skip {
               OneOf {
                   PrefixUpTo("<meta".utf8)
                   PrefixUpTo("<link".utf8)
                   PrefixUpTo("<title".utf8)
                   PrefixUpTo("<script".utf8)
                   PrefixUpTo("<style".utf8)
               }
           }

           Many {
               TagParser()

               Skip {
                   // next tag
                   PrefixUpTo("<".utf8)
               }
           }

           Skip {
               Rest()
           }
       }
    }
}

public struct TagParser: Parser {
    public var body: some Parser<Substring.UTF8View, Tags> {
        OneOf {
            AngleBracktsContent(tag: .meta)
            AngleBracktsContent(tag: .link)
            // title
            OneOf {
                PlainTextBetweenTag(tag: .title)
                AngleBracktsWithAttribute(tag: .title)
            }


            // script
            ScriptTagParser()

            // style
            OneOf {
                PlainTextBetweenTag(tag: .style)
                AngleBracktsWithAttribute(tag: .style)
            }
        }
    }
}
