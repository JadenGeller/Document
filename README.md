# Document

`Document` is a Swift type that represents line break-delimited documents. It exposes a collection of lines that can be accessed via its `lines` property providing constant-time lookup of a given line in a document. `Document` conforms to `SequenceType` as if it were a line break-delimited `String`, so it is easy to iterate over its characters.

```swift
let doc = Document("Hello world!\nand all who inhabit it\n")
print(doc.lines[1]) // -> and all who inhabit it
print(doc[doc.startIndex.breakLine().successor()]) // -> n
```
