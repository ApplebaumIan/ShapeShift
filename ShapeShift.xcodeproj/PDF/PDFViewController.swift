//
//  PDFViewController.swift
//  ShapeShifter
//
//  Created by Ian Applebaum on 4/19/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import UIKit
import PDFKit
class PDFViewController: UIViewController, PDFViewDelegate {
	let pdfView = MainPDFView()
	var pdf : Document?
	var markupButtons = UIStackView()
	let closeButton = UIButton()
	let sssharer = ScreenshotSharer()
	private let pdfDrawing = PDFDraw()
	private let pdfDrawingToolsDel = PDFDrawingTools()
	public init() {
		super.init(nibName: nil, bundle: nil)
	}
	public init(pdf: Document) {
		super.init(nibName: nil, bundle: nil)
		self.pdf = pdf
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	func closeButtonSetup() {
		view.addSubview(closeButton)
		closeButton.translatesAutoresizingMaskIntoConstraints = false
		closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
		closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
		closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20).isActive = true
		closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
		closeButton.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
		view.bringSubviewToFront(closeButton)
	}
	fileprivate func setUpMarkupTools() {
		pdfDrawingToolsDel.pdfDrawDelagate = pdfDrawing
		pdfDrawingToolsDel.pdfViewDelagate = pdfView
		pdfDrawingToolsDel.viewController = self
		pdfDrawingToolsDel.viewToAddTools = view
		pdfDrawingToolsDel.setUpButtons()
		markupButtons = pdfDrawingToolsDel.layOutButtons()
		pdfDrawingToolsDel.markupButtondDel = markupButtons
		
//		pdfDrawingToolsDel.snackbar = snackbar
	}
	fileprivate func pdfViewConstraints() {
		pdfView.translatesAutoresizingMaskIntoConstraints = false
		pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: 0).isActive = true
		pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	fileprivate func PDFSetUp() {
		if let pdf = self.pdf{
			pdfView.setPDF(document: pdf)
		}else{
			pdfView.setPDF(fileURL: Bundle.main.bundleURL.appendingPathComponent("blank.pdf"))//sets the pdf of the view.
		}
		pdfView.delegate = self
			//Drawing/annotation recognizer
				let pdfDrawingGestureRecognizer = DrawingRecognizer()
				pdfView.addGestureRecognizer(pdfDrawingGestureRecognizer)
				pdfDrawingGestureRecognizer.drawingDelegate = pdfDrawing
				pdfDrawing.pdfView = pdfView
		//		snackbarSetup()
				//test to show that the view is working!
				//let brochure = BrochureDB()
				//var brochures = brochure.getAll()
				//let selectorGuide = brochure.getSelectorGuide()//brochures[13]//get the 36th brochure... btw this wont work unless all of the brochures are in the root of the documents directory... it's going to show up blank other wise. ~Ian
				view.addSubview(pdfView)
		view.backgroundColor = .systemBackground
				pdfViewConstraints()//constraints for pdfView
		imageView.isHidden = true
	}
	


	
	let customSharer = ScreenshotViewController()
	override func viewDidLoad() {
		super.viewDidLoad()

		
//	topBar = view.addTopBar()
//    super.viewDidLoad()
		self.title = self.pdf?.fileURL.lastPathComponent
		PDFSetUp()
		setUpMarkupTools()
		let toolBar = UIToolbar()
		let barItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
		let label = UILabel()
		label.text = pdf?.fileURL.lastPathComponent
//		label.center = CGPoint(x: CGRectGetMidX(view.frame), y: view.frame.height)
//		label.textAlignment = NSTextAlignment.Center

		let toolbarTitle = UIBarButtonItem(customView: label)
//		titleItem.title = self.pdf?.fileURL.lastPathComponent
		barItem.tintColor = .systemYellow
		let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolBar.setItems([flexible,toolbarTitle,flexible,barItem], animated: true)
//		navigationItem.rightBarButtonItem = barItem
		view.addSubview(toolBar)
		toolBar.translatesAutoresizingMaskIntoConstraints = false
		toolBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		sssharer.registerScreenCapturer(cropStatusBar: true, cropRect: CGRect.zero, sharerViewController: customSharer, captureBlock: { (image, customScreenshotSharerViewController) in
					 }) { (isSuccess) in
					
					 }
//		let backButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.done, target: self, action: Selector(("backButtonClicked")))
		 let buttonHolder = UIView()
		 view.addSubview(buttonHolder)
		 buttonHolder.translatesAutoresizingMaskIntoConstraints = false
		 buttonHolder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		 buttonHolder.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		 buttonHolder.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		 buttonHolder.heightAnchor.constraint(equalToConstant: 50).isActive = true
//		buttonHolder.backgroundColor = .green
		buttonHolder.backgroundColor = .clear
		 buttonHolder.addSubview(markupButtons)
//		closeButtonSetup()
		topCoverSetup()
    }  
	@objc func save(){
		if let pdf = pdf {
			pdfView.document?.write(to: pdf.fileURL)
		}
		self.dismiss(animated: true, completion: nil)
	}
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		   pdfView.autoScales = true // This call is required to fix PDF document scale, seems to be bug inside PDFKit
	   }
	let imageView = UIImageView()
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		pdfDrawing.setup()
		view.addSubview(imageView)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		pdfDrawing.imageView = imageView
	}
		/// Adds a nice cover for devices with a notch
		func topCoverSetup() {
			let topCover = UIView()
			let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
			let blurEffectView = UIVisualEffectView(effect: blurEffect)
			blurEffectView.frame = topCover.bounds
			blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
			topCover.addSubview(blurEffectView)
	
			view.addSubview(topCover)
			topCover.translatesAutoresizingMaskIntoConstraints = false
			topCover.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
			topCover.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
			topCover.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
			topCover.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
			let backgroundColoer : UIColor = .tertiarySystemBackground
//			topCover.backgroundColor = backgroundColoer.withAlphaComponent(0.50)
		}
}
