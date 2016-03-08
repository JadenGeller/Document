//
//  File.swift
//  Document
//
//  Created by Jaden Geller on 3/8/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

public struct Document {
    public typealias LineView = [String]
    public var lines: LineView
    
    public init(_ string: String) {
        self.lines = Array(string
            .characters
            .split(allowEmptySlices: true) { $0 == "\n" }
            .map{ String($0) }
        )
    }
    
    public init(lines: [String]) {
        precondition({
            for line in lines where line.characters.contains("\n") { return false }
            return true
            }(), "Unexpected new line character.")
        self.lines = lines
    }
}

extension Document {
    public struct Index {
        // Inefficient, but required by ForwardIndexType protocol.
        // Will be
        private let document: Document
        
        /// Line index.
        public let line: Int
        
        /// Column index. Note that a `nil` index corresponds to the index of the
        /// newline character in the line.
        public let column: String.CharacterView.Index?
        
        private init(document: Document, line: Int, column: String.CharacterView.Index?) {
            self.document = document
            self.line = line
            self.column = column
        }
    }
}

extension Document.Index: ForwardIndexType {
    public func successor() -> Document.Index {
        if let nextColumn = column?.successor() {
            return Document.Index(
                document: document,
                line: line,
                column: (nextColumn == document.lines[line].endIndex) ? nil : nextColumn
            )
        } else {
            let nextLine = line.successor()
            return Document.Index(
                document: document,
                line: nextLine,
                column: nextLine < document.lines.endIndex && !document.lines[nextLine].isEmpty ?
                    document.lines[nextLine].startIndex : nil
            )
        }
    }
}

public func ==(lhs: Document.Index, rhs: Document.Index) -> Bool {
    return lhs.line == rhs.line && lhs.column == rhs.column
}

extension Document: CollectionType {
    public var startIndex: Index {
        return Index(
            document: self,
            line: 0,
            column: lines.first.map{ $0.characters.startIndex }
        )
    }
    
    public var endIndex: Index {
        return Index(
            document: self,
            line: lines.endIndex,
            column: nil
        )
    }
    
    public subscript(index: Index) -> Character {
        return index.column.map{ lines[index.line].characters[$0] } ?? "\n"
    }
}

extension String {
    public init(_ document: Document) {
        self.init(document.lines.joinWithSeparator("\n"))
    }
}

extension Document: CustomStringConvertible {
    public var description: String {
        return String(self)
    }
}

extension Document: ArrayLiteralConvertible {
    public init(arrayLiteral elements: String...) {
        self.init(lines: elements)
    }
}

extension Document: StringLiteralConvertible {
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    
    public init(stringLiteral value: String) {
        self.init(value)
    }
}
