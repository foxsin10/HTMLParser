@testable
@_spi(TagAttributeParsing) import HTMLParser

import Parsing
import XCTest

final class HTMLParserTests: XCTestCase {
    func testMetaParsing() throws {
        let tagParser = TagParser()

        let parseds = try plainMetas.map {
            let input = $0.utf8
            return try tagParser.parse(input)
        }

        XCTAssertEqual(parseds.count, expectTags.count)

        for i in 0 ..< parseds.count {
            let parsed = parseds[i]
            let expectTag = expectTags[i]

            XCTAssertEqual(parsed, expectTag)
        }
    }

    func testScriptParsing() throws {
        let scripts = [
            "<script nonce=\"4hbcUHwvPMkinIZ8mRuACA\">if (window.ytcsi) { window.ytcsi.tick('rsef_dpj', null, ''); }</script>",
            "<script>if (window.ytcsi) { window.ytcsi.tick('rsef_dpj', null, ''); }</script>",
        ]

        for script in scripts {
            let parser = AngleBracktsWithAttribute(tag: .script)
            let content = try parser.parse(script.utf8)

            XCTAssertTrue(content.isScript)
        }
    }

    func testAttributeParsing() throws {
        struct AttributeKey: Parser {
            let keyword: String

            var body: some Parser<Substring.UTF8View, Substring.UTF8View> {
                " \(keyword)".utf8
                    .map { keyword[...].utf8 }
            }
        }

        let a = AttributeParser()

        let parser = Parse {
            OneOf {
                AttributeKey(keyword: "name")
                AttributeKey(keyword: "content")
                AttributeKey(keyword: "id")
                AttributeKey(keyword: "property")
                AttributeKey(keyword: "rel")
                AttributeKey(keyword: "herf")
                AttributeKey(keyword: "http-equiv")
            }
            "=".utf8
            Rest()
        }
//
        var text = " name=apple"[...].utf8
        let parsed = try parser.parse(&text)
        print(parsed, text)

//        for tag in expectTags.filter({ !$0.isTitle }) {
//            let content = try parser.parse(tag.content.utf8)
//            content.joined(separator: "<||>".utf8)
//            print("content:", content)
//        }
    }

    func testMetasParsing() throws {
        let tagParser = TagParser()
        let parser = Many {
            tagParser
        }

        var input = sampleMetas[...].utf8
        do {
            let count = checkMetaTagCount(for: sampleMetas)
            let content = try parser.parse(&input)
            XCTAssertTrue(content.count == count)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testHTMLParsing() throws {
        let htmls = [
            sampleHTML,
            sampleHeadContentHTML,
            formattedTwitterHTML,
        ]

        for html in htmls {
            try parseHTML(html)
        }
    }

    func testRemoteHTMLParsin() async throws {
        let urls = [
            "https://www.youtube.com/playlist?list=PL6yRaaP0WPkXlpHmHyuA35TLiLIb9R-Wo",
            "https://twitter.com/tualatrix/status/1589965618484113410",
            "https://fluttergems.dev/report-oct-2022/",
            "https://twitter.com/johnfetterman/status/1590221958536646657",
            "https://github.com/hemashushu/practice-mcu-bare-metal-rust",
            "https://github.com/zellij-org/zellij",
            "https://learningos.github.io/rust-based-os-comp2022/",
        ]

        let session = URLSession(configuration: .ephemeral)
        try await withThrowingTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    let (data, _) = try await session.data(from: URL(string: url)!)
                    let initial = Date()
                    if let html = String(data: data, encoding: .utf8) {
                        let parsingStart = Date()

                        let count = checkMetaTagCount(for: html, includeAll: true)
                        let content = try parseHeadTags(of: html, includeScript: true)
                        let countentCount = content.count
                        let now = Date()
                        let totalTime = initial.timeIntervalSince(now)
                        let parsingTime = parsingStart.timeIntervalSince(now)
                        print(
                            """
                            =============
                            parsing
                            html from \(url)
                            get \(countentCount) tags
                            cost \(-totalTime) convert and parsing
                            cost \(-parsingTime) parsing
                            =============
                            """
                        )
                        XCTAssertTrue(countentCount == count, "\n for \(url) \n expect \(count) tags, get \(countentCount)")
                    }
                }
            }

            for _ in urls {
                try await group.next()
            }
        }
    }
}

extension HTMLParserTests: HTMLParseSpec {}
