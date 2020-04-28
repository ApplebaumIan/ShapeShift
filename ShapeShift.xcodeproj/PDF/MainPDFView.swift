//
//  MainPDFView.swift
//  ShapeShifter
//
//  Created by Ian Applebaum on 4/19/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import UIKit
import PDFKit

class MainPDFView: PDFView {

	func setPDF(fileURL: URL) {
		
		
//			let name = brochure.pdf
//			let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("All_EPOTEK_Assets/\(name!)")
//			print(pdfLink)
			self.document = PDFDocument(url: fileURL)
			//self.addTopBar(screenName: brochure.title!, customerName: "Marisa Kruidenier")
		
		
	}
	
	func setPDF(document: Document) {
		self.document = PDFDocument(url: document.fileURL)
	}
	
	func pdfViewer() {
		let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("webViewPdf.pdf")
		self.document = PDFDocument(url: pdfLink)
		self.backgroundColor = .clear
		
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.autoScales = true
		self.isUserInteractionEnabled = true
		self.displayDirection = .horizontal
		
		
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

