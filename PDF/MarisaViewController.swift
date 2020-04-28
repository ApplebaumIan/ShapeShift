//
//  MarisaViewController.swift
//  Product Visualizer
//
//  Created by Marisa Kruidenier on 8/8/19.
//  Copyright © 2019 Ian Applebaum. All rights reserved.
//

import UIKit
import PDFKit
import GRDB
class MarisaViewController: EpotekViewController, PDFViewDelegate {
	let pdfView = MainPDFView()
	var markupButtons = UIStackView()
	let sssharer = ScreenshotSharer()
	private let pdfDrawing = PDFDraw()
	
	fileprivate func setUpMarkupTools() {
		pdfDrawingToolsDel.pdfDrawDelagate = pdfDrawing
		pdfDrawingToolsDel.pdfViewDelagate = pdfView
		pdfDrawingToolsDel.viewController = self
		pdfDrawingToolsDel.viewToAddTools = view
		pdfDrawingToolsDel.setUpButtons()
		pdfDrawingToolsDel.snackbarSetup()
		markupButtons = pdfDrawingToolsDel.layOutButtons()
		pdfDrawingToolsDel.markupButtondDel = markupButtons
		
//		pdfDrawingToolsDel.snackbar = snackbar
	}
	fileprivate func pdfViewConstraints() {
		pdfView.translatesAutoresizingMaskIntoConstraints = false
		pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -70).isActive = true
		pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	fileprivate func PDFSetUp() {
		if brochurePDF.pdf != nil {
			pdfView.setPDF(brochure: brochurePDF)//sets the pdf of the view.
			pdfView.delegate = self
		}
		if techtipPDF.pdf != nil {
			pdfView.setPDF(techtip: techtipPDF)//sets the pdf of the view.
			pdfView.delegate = self
		}
		if summaryPDF.pdf != nil {
			pdfView.setPDF(summary: summaryPDF)//sets the pdf of the view.
			pdfView.delegate = self
		}
		if product != nil {
			if datasheet {
				pdfView.setPDF(product:product!,datasheet: datasheet)
				pdfView.delegate = self
			}
			if SDS {
				pdfView.setPDF(product:product!,MSDS: SDS)
				pdfView.delegate = self
			}
		}
		//Drawing/annotation recognizer
		let pdfDrawingGestureRecognizer = DrawingRecognizer()
		pdfView.addGestureRecognizer(pdfDrawingGestureRecognizer)
		pdfDrawingGestureRecognizer.drawingDelegate = pdfDrawing
		pdfDrawing.pdfView = pdfView
//		snackbarSetup()
		setUpMarkupTools()
		//test to show that the view is working!
		//let brochure = BrochureDB()
		//var brochures = brochure.getAll()
		//let selectorGuide = brochure.getSelectorGuide()//brochures[13]//get the 36th brochure... btw this wont work unless all of the brochures are in the root of the documents directory... it's going to show up blank other wise. ~Ian
		view.addSubview(pdfView)
		view.backgroundColor = .white
		pdfViewConstraints()//constraints for pdfView
	}
	
	let customSharer = ScreenshotViewController()
	override func viewDidLoad() {
		super.viewDidLoad()

		if brochurePDF.pdf != nil {
			setScreenTitle(title: brochurePDF.title!)
			customSharer.sessionType = SessionActivityType(id: .screenshot)
			SessionActivity(sessionId: (currentSession?.id!)!, typeId: SessionActivityType(id: .openBrochure).getStatus(), description: nil, assetID: brochurePDF.id, quickNoteId: nil, screenshotPath: nil, title: nil)
		}
		if techtipPDF.pdf != nil {
			setScreenTitle(title: techtipPDF.title!)
			customSharer.sessionType = SessionActivityType(id: .screenshot)
			SessionActivity(sessionId: (currentSession?.id!)!, typeId: SessionActivityType(id: .openTechtip).getStatus(), description: nil, assetID: techtipPDF.techtip_id, quickNoteId: nil, screenshotPath: nil, title: nil)
		}
		if summaryPDF.pdf != nil {
			setScreenTitle(title: summaryPDF.title!)
			customSharer.sessionType = SessionActivityType(id: .screenshot)
			SessionActivity(sessionId: (currentSession?.id!)!, typeId: SessionActivityType(id: .openSummary).getStatus(), description: nil, assetID: summaryPDF.id, quickNoteId: nil, screenshotPath: nil, title: nil)
		}
		if product != nil {
			if datasheet {
				setScreenTitle(title: (product?.product!)!)
				customSharer.sessionType = SessionActivityType(id: .screenshot)
				SessionActivity(sessionId: (currentSession?.id!)!, typeId: SessionActivityType(id: .openDataSheet).getStatus(), description: nil, assetID: product?.id, quickNoteId: nil, screenshotPath: nil, title: nil)
			}
			if SDS {
				setScreenTitle(title: (product?.product!)!)
				customSharer.sessionType = SessionActivityType(id: .screenshot)
				SessionActivity(sessionId: currentSession!.id!, typeId: SessionActivityType(id: .openSDS).getStatus(), description: nil, assetID: product?.id, quickNoteId: nil, screenshotPath: nil, title: nil)
			}
		}
//	topBar = view.addTopBar()
//    super.viewDidLoad()
		PDFSetUp()
		pdfDrawingToolsDel.snackbarSetup()
		navStack.insertArrangedSubview(markupButtons, at: .zero)
		
		sssharer.registerScreenCapturer(cropStatusBar: true, cropRect: CGRect.zero, sharerViewController: customSharer, captureBlock: { (image, customScreenshotSharerViewController) in
					 }) { (isSuccess) in
					
					 }
		let backButton = UIBarButtonItem(title: "Close", style: UIBarButtonItem.Style.done, target: self, action: Selector(("backButtonClicked")))
		 navigationItem.leftBarButtonItem = backButton
    }

	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		   pdfView.autoScales = true // This call is required to fix PDF document scale, seems to be bug inside PDFKit
	   }
}
