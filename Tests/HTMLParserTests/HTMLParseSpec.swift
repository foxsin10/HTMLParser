import Foundation
import XCTest

import Parsing
import HTMLParser

protocol HTMLParseSpec {}

extension HTMLParseSpec {
    var plainMetas: [String] {
        [
            #"<meta name=apple-itunes-app content=app-id=544007664, app-argument=https://m.youtube.com/playlist?list=PL6yRaaP0WPkXlpHmHyuA35TLiLIb9R-Wo&amp;referring_app=com.apple.mobilesafari-smartbanner, affiliate-data=ct=smart_app_banner_polymer&amp;pt=9008>"#,
            #"<meta http-equiv=origin-trial content=Aj3qcaJaUoh6poPNVBAuhNwAOEH3X2ZVFfBWWaoE9IIB3TPHga7leZ1FHiJ/KbGl6XGeA5KaNamoxK5BFiVs6wsAAABveyJvcmlnaW4iOiJodHRwczovL20ueW91dHViZS5jb206NDQzIiwiZmVhdHVyZSI6IlByaXZhY3lTYW5kYm94QWRzQVBJcyIsImV4cGlyeSI6MTY4MDY1Mjc5OSwiaXNTdWJkb21haW4iOnRydWV9 />"#,
            #"<meta name=viewport content=width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,>"#,
            #"<meta name=google-site-verification content=Wq-n-QaxUP6b3GbKML3-IfS6tPC3lK5rHmsxmuMAktw/>"#,
            ###"<meta id=theme-meta name=theme-color content=#0f0f0f>"###,
            #"<link rel=icon href=https://m.youtube.com/static/favicon.ico type=image/x-icon>"#,
            #"<title>YouTube</title>"#,
            #"<meta name=description content=Share your videos with friends, family, and the world>"#,
            #"<meta name=keywords content=video, sharing, camera phone, video phone, free, upload>"#,
            #"<link rel=canonical href=https://www.youtube.com/playlist>"#,
            #"<meta property=og:url content=https://www.youtube.com/playlist>"#,
            #"<meta property=twitter:url content=https://www.youtube.com/playlist>"#,
        ]
    }

    var expectTags: [Tags] {
        [
            .meta(" name=apple-itunes-app content=app-id=544007664, app-argument=https://m.youtube.com/playlist?list=PL6yRaaP0WPkXlpHmHyuA35TLiLIb9R-Wo&amp;referring_app=com.apple.mobilesafari-smartbanner, affiliate-data=ct=smart_app_banner_polymer&amp;pt=9008"),
            .meta(" http-equiv=origin-trial content=Aj3qcaJaUoh6poPNVBAuhNwAOEH3X2ZVFfBWWaoE9IIB3TPHga7leZ1FHiJ/KbGl6XGeA5KaNamoxK5BFiVs6wsAAABveyJvcmlnaW4iOiJodHRwczovL20ueW91dHViZS5jb206NDQzIiwiZmVhdHVyZSI6IlByaXZhY3lTYW5kYm94QWRzQVBJcyIsImV4cGlyeSI6MTY4MDY1Mjc5OSwiaXNTdWJkb21haW4iOnRydWV9"),
            .meta(" name=viewport content=width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,"),
            .meta(" name=google-site-verification content=Wq-n-QaxUP6b3GbKML3-IfS6tPC3lK5rHmsxmuMAktw/"),
            .meta(" id=theme-meta name=theme-color content=#0f0f0f"),
            .link(" rel=icon href=https://m.youtube.com/static/favicon.ico type=image/x-icon"),
            .title(attribute: "", content: "YouTube"),
            .meta(" name=description content=Share your videos with friends, family, and the world"),
            .meta(" name=keywords content=video, sharing, camera phone, video phone, free, upload"),
            .link(" rel=canonical href=https://www.youtube.com/playlist"),
            .meta(" property=og:url content=https://www.youtube.com/playlist"),
            .meta(" property=twitter:url content=https://www.youtube.com/playlist"),
        ]
    }

    var sampleMetas: String {
        """
        <meta name=apple-itunes-app content=app-id=544007664, app-argument=https://m.youtube.com/playlist?list=PL6yRaaP0WPkXlpHmHyuA35TLiLIb9R-Wo&amp;referring_app=com.apple.mobilesafari-smartbanner, affiliate-data=ct=smart_app_banner_polymer&amp;pt=9008><meta http-equiv=origin-trial content=Aj3qcaJaUoh6poPNVBAuhNwAOEH3X2ZVFfBWWaoE9IIB3TPHga7leZ1FHiJ/KbGl6XGeA5KaNamoxK5BFiVs6wsAAABveyJvcmlnaW4iOiJodHRwczovL20ueW91dHViZS5jb206NDQzIiwiZmVhdHVyZSI6IlByaXZhY3lTYW5kYm94QWRzQVBJcyIsImV4cGlyeSI6MTY4MDY1Mjc5OSwiaXNTdWJkb21haW4iOnRydWV9 /><meta name=viewport content=width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no,><meta name=google-site-verification content=Wq-n-QaxUP6b3GbKML3-IfS6tPC3lK5rHmsxmuMAktw/><meta id=theme-meta name=theme-color content=#0f0f0f><link rel=icon href=https://m.youtube.com/static/favicon.ico type=image/x-icon><title>YouTube</title><meta name=description content=Share your videos with friends, family, and the world><meta name=keywords content=video, sharing, camera phone, video phone, free, upload><link rel=canonical href=https://www.youtube.com/playlist><meta property=og:url content=https://www.youtube.com/playlist><meta property=twitter:url content=https://www.youtube.com/playlist>
        """
    }

    var sampleHTML: String {
        """
          <!DOCTYPE html><html darker-dark-theme><head>\(sampleMetas)</head></html>
        """
    }

    var sampleHeadContentHTML: String {
        """
          <!DOCTYPE html><html darker-dark-theme><head prefix="my_namespace: https://example.com/ns#">\(sampleMetas)</head></html>
        """
    }

    var formattedTwitterHTML: String {
        """
          <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="icon" href="https://fluttergems.dev/media/favicon.png">
            <meta name="apple-mobile-web-app-capable" content="yes">
            <meta name="apple-mobile-web-app-title" content="Flutter Gems - A Curated List of Dart & Flutter packages">
            <link rel="apple-touch-icon-precomposed" href="https://fluttergems.dev/media/ios-desktop.png">
            <title>Monthly Report #1 - Top Dart & Flutter Packages in October, 2022 | Flutter Gems</title>
            <meta name="keywords" content="flutter,dart,packages,pub,dev,plugins,kotlin,android,swift">
            <meta name="description" content="Flutter Gems monthly report of top Dart and Flutter packages that gained popularity and traction in October, 2022. Flutter Gems is a curated list of top Dart and Flutter packages that are categorized based on functionality. Flutter Gems is also a visual alternative to pub.dev">
            <meta name="author" content="Ashita Prasad">
            <meta property="og:title" content="Monthly Report #1 - Top Dart & Flutter Packages in October, 2022 | Flutter Gems">
            <meta property="og:description" content="Flutter Gems monthly report of top Dart and Flutter packages that gained popularity and traction in October, 2022. Flutter Gems is a curated list of top Dart and Flutter packages that are categorized based on functionality. Flutter Gems is also a visual alternative to pub.dev">
            <meta property="og:image" content="https://fluttergems.dev/media/reports/1.png">
            <meta property="og:url" content="https://fluttergems.dev/report-oct-2022/">
            <meta name="twitter:title" content="Monthly Report #1 - Top Dart & Flutter Packages in October, 2022 | Flutter Gems">
            <meta name="twitter:description" content="Flutter Gems monthly report of top Dart and Flutter packages that gained popularity and traction in October, 2022. Flutter Gems is a curated list of top Dart and Flutter packages that are categorized based on functionality. Flutter Gems is also a visual alternative to pub.dev">
            <meta name="twitter:image" content="https://fluttergems.dev/media/reports/1.png">
            <meta name="twitter:card" content="summary_large_image">
            <meta name="twitter:site" content="@fluttergems">
            <link href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css" integrity="sha256-8M+b2Hj+vy/2J5tZ9pYDHeuPD59KsaEZn1XXj3xVhjg=" crossorigin="anonymous">
            <link href="/album.css" rel="stylesheet">
          </head>
        """
    }

    func parseHTML(_ html: String) throws {
        let content = try HTMLParser.parseHeadTags(of: html)
        let count = HTMLParser.checkMetaTagCount(for: html)
        XCTAssertTrue(content.count == count)
    }
}
