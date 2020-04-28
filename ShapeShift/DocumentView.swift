//
//  DocumentView.swift
//  ShapeShift
//
//  Created by Ian Applebaum on 4/27/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import SwiftUI

struct DocumentView: View {
    var document: UIDocument
    var dismiss: () -> Void

    var body: some View {
        VStack {
            HStack {
                Text("File Name")
                    .foregroundColor(.secondary)

                Text(document.fileURL.lastPathComponent)
            }

            Button("Done", action: dismiss)
        }
    }
}
