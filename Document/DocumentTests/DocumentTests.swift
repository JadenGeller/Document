//
//  DocumentTests.swift
//  DocumentTests
//
//  Created by Jaden Geller on 3/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import XCTest
@testable import Document

class DocumentTests: XCTestCase {

    func testDocument() {
        let string = "Hello world\nand all that\ninhabit it\n"
        let document = Document(string)
        XCTAssertEqual(string, String(document))
    }
    
    func testBreakLine() {
        let document = Document("abc\ndef\n")
        XCTAssertEqual("d", document[document.startIndex.breakLine()])
    }
}
