//
//  Document.swift
//  ShapeShift
//
//  Created by Ian Applebaum on 4/27/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
    }
}

