//
//  MainPDFView.swift
//  Product Visualizer
//
//  Created by Marisa Kruidenier on 8/8/19.
//  Copyright © 2019 Ian Applebaum. All rights reserved.
//

import UIKit
import PDFKit

class MainPDFView: PDFView {
//		SET PDF FUNCTION accepts any object that is relevant to opening PDFs. If you pass a PRODUCT
//		you must provide whether you would like a datasheet or MSDS. YOU CANNOT HAVE BOTH!!!
//		It would look like this:
/*
//	get array of products!
	let products = ProductsDB()
	var product = products.getAll()

//	get the 36th product... btw this wont work unless all of the product assets
//	are in /Documents/All_EPOTEK_Assets/ ... it's going to show up blank otherwise. ~Ian
	let productDataSheetToDisplay = product[36]

//	SET PDF to display the product datasheet
	pdfView.setPDF(product: productDataSheetToDisplay, datasheet: true)//sets the pdf of the view.

//	ADD PDF TO THE VIEW
	view.addSubview(pdfView)
*/
//		FOR MSDS replace datasheet with MSDS.
	func setPDF(brochure: brochures = brochures(), techtip: techtips = techtips(), summary: techsummary = techsummary(), product: bvopz_products = bvopz_products(id: nil, product: nil, cfds: nil, numcomponents: nil, potlifevalue: nil, viscosityvalue: nil, tgvalue: nil, thixovalue: nil, mincuretemp: nil, dieshearstrength: nil, thermalcond: nil, cte: nil, indrefrection: nil, spectraltrans: nil, hardness: nil, creationdate: nil, editdate: nil, featured: nil, safetydatafile: nil, datastylesheet: nil, published: nil, notes: nil), datasheet: Bool = false, MSDS: Bool = false) {
		
		if brochure.pdf != nil {
			let name = brochure.pdf
			let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("All_EPOTEK_Assets/\(name!)")
			print(pdfLink)
			self.document = PDFDocument(url: pdfLink)
			//self.addTopBar(screenName: brochure.title!, customerName: "Marisa Kruidenier")
		}
		if techtip.pdf != nil {
			let name = techtip.pdf
			let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("All_EPOTEK_Assets/\(name!)")
			print(pdfLink)
			self.document = PDFDocument(url: pdfLink)
			//self.addTopBar(screenName: techtip.title!, customerName: "Marisa Kruidenier")
		}
		if summary.pdf != nil {
			let name = summary.summary_pdf
			let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("All_EPOTEK_Assets/\(name!)")
			print(pdfLink)
			self.document = PDFDocument(url: pdfLink)
			//self.addTopBar(screenName: summary.title!, customerName: "Marisa Kruidenier")
		}
		if product.id != nil {
			if datasheet == true{
				let name = product.datastylesheet
				let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("All_EPOTEK_Assets/\(name!)")
				print(pdfLink)
				self.document = PDFDocument(url: pdfLink)
			}
			if MSDS == true{
				let name = product.safetydatafile
				let pdfLink = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("All_EPOTEK_Assets/\(name!)")
				print(pdfLink)
				self.document = PDFDocument(url: pdfLink)
			}
			
			//self.addTopBar(screenName: product.product!, customerName: "Marisa Kruidenier")
		}
	
		//let name = pdf.pdf!
		//var line = [CGPoint]()
		
	}
	func productViewer() {
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

