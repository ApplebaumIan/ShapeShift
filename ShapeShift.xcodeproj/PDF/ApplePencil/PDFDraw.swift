//
//  PDFDraw.swift
//  ShapeShifter
//
//  Created by Ian Applebaum on 4/19/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//
/*This class actually handles the drawings on a PDF.*/
import Foundation
import PDFKit
import SwiftOCR
class PDFDraw {
	weak var pdfView: PDFView!
	private var path: UIBezierPath?
	private var currentAnnotation : DrawingAnnotation?
	private var currentPage: PDFPage?
	public var colorVal = UserDefaults.standard.value(forKey: "colorVal") as? String ?? "black"{/* This is the current color of the tool. but im holding the value in user defaults so that the user can choose the color and keep it through out use of the app.*/
		didSet{
			print("set \(String(describing: colorVal))")
			UserDefaults.standard.set(colorVal, forKey: "colorVal")
			UserDefaults.standard.synchronize()
		}
	}
	// current drawing rect
	   var minX = 0
	   var minY = 0
	   var maxX = 0
	   var maxY = 0
	   
	   var trackTimer : Timer?
	   var lastTouchTimestamp : TimeInterval?
	   var ocrImageRect : CGRect?
	   var currentTextRect : CGRect?
	
	var imageView: UIImageView?
	var context : CGContext?

	
	let undoManager = UndoManager()/*this guy manages all of your undo needs.*/
	public var currentTool: tool = .pen/*the current tool being used*/
	/*These are types of tools and the width and alpha values they hold.*/
	enum tool :Int{
		case eraser = 0
		case pen = 1
		case highlighter = 2
		/*how thick each tool is*/
		var width: CGFloat {
			switch self {
			case .pen:
				return 3
			case .highlighter:
				return 10
			default:
				return 0
			}
		}
		/*is the tool translucent?*/
		var alpha: CGFloat {
			switch self {
			case .highlighter:
				return 0.3 //0,5
			default:
				return 1
			}
		}
	}
}
extension PDFDraw: DrawingGestureRecognizerDelegate{
	/*start drawing*/
	func gestureRecognizerBegan(_ location: CGPoint) {
		guard let page = pdfView.page(for: location, nearest: true) else {
			return
		}
		currentPage = page
		let convertedPoint = pdfView.convert(location, to: currentPage!)
//		if currentTool == .eraser {
//			removeAnnotationAtPoint(point: convertedPoint, page: page)
//			return
//		}
		path = UIBezierPath()
		path?.move(to: convertedPoint)
	}
	/*add drawing to PDF*/
	func gestureRecognizerMoved(_ location: CGPoint) {
		guard let page = currentPage else {
			return
		}
		lastTouchTimestamp = Date().timeIntervalSince1970
		imageView?.image?.draw(in: pdfView.bounds)
		let convertedPoint = pdfView.convert(location, to: page)
		//eraser
		if currentTool == .eraser {
			removeAnnotationAtPoint(point: convertedPoint, page: page)
			return
		}
		//annotating
		self.path?.addLine(to: convertedPoint)
		self.path?.move(to: convertedPoint)
		minX = min(minX, Int(location.x))
				  minY = min(minY, Int(location.y))
				  maxX = max(maxX, Int(location.x))
				  maxY = max(maxY, Int(location.y))
		self.drawAnnotation(onPage: page)
		
	}
	/*stop drawing and add annotation to PDF*/
	func gestureRecognizerEnded(_ location: CGPoint) {
		guard let page = currentPage else {
			return
		}
		let convertedPoint = pdfView.convert(location, to: page)
		// Erasing
		if currentTool == .eraser {
			removeAnnotationAtPoint(point: convertedPoint, page: page)
			return
		}
		
		path?.addLine(to: convertedPoint)
		path?.move(to: convertedPoint)
		
		// Final annotation
		guard let remover = currentAnnotation else{return}
		page.removeAnnotation(remover)
		currentAnnotation = nil
		createFinalAnnotation(path: path!, page: page)
		currentAnnotation = nil
		let ss = ScreenshotSharer()
		imageView?.image = ss.takeImageOf(view: pdfView)
		drawDoodlingRect(context: context)
		resetDoodleRect()
	}
	private func createFinalAnnotation(path: UIBezierPath, page: PDFPage) -> PDFAnnotation {
		let border = PDFBorder()
	  border.lineWidth = currentTool.width
	  let bounds = CGRect(x: path.bounds.origin.x - 5,
						  y: path.bounds.origin.y - 5,
					  width: path.bounds.size.width + 10,
					 height: path.bounds.size.height + 10)
	  var signingPathCentered = UIBezierPath()
	  signingPathCentered.cgPath = path.cgPath
	  signingPathCentered.moveCenter(to: bounds.center)
	  let annotation = PDFAnnotation(bounds: bounds, forType: .ink, withProperties: nil)
	  switch colorVal {
	  case "black":
		  annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)
	  case "red":
		  annotation.color = #colorLiteral(red: 0.9576062817, green: 0.02688773809, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)
	  case "blue":
		  annotation.color = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.5843137255, alpha: 1).withAlphaComponent(currentTool.alpha)
	 case "yellow":
			if currentTool == .pen {annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)} else{annotation.color = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1).withAlphaComponent(currentTool.alpha)}
	  default:
		  annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)
	  }
	  annotation.border = border
		undoManager.registerUndo(withTarget: self){target in
			page.removeAnnotation(annotation)
		}
	  annotation.add(signingPathCentered)
	  page.addAnnotation(annotation)
	  return annotation
	}
	private func createAnnotation(path: UIBezierPath, page: PDFPage) -> DrawingAnnotation {
		let border = PDFBorder()
		border.lineWidth = currentTool.width // Set your line width here
		let annotation = DrawingAnnotation(bounds: page.bounds(for: pdfView.displayBox), forType: .ink, withProperties: nil)
		//annotation.color =
		switch colorVal {
		case "black":
			annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)
		case "red":
			annotation.color = #colorLiteral(red: 0.9576062817, green: 0.02688773809, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)
		case "blue":
			annotation.color = #colorLiteral(red: 0, green: 0.3529411765, blue: 0.5843137255, alpha: 1).withAlphaComponent(currentTool.alpha)
		case "yellow":
			if currentTool == .pen {annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)} else{annotation.color = #colorLiteral(red: 1, green: 0.8392156863, blue: 0.03921568627, alpha: 1).withAlphaComponent(currentTool.alpha)}
		default:
			annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(currentTool.alpha)
		}
		if currentTool == .eraser {
			annotation.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
		}
		annotation.border = border
		annotation.add(path)
		
				
		
		
		return annotation
	}
	private func removeAnnotationAtPoint(point: CGPoint, page: PDFPage) {
		DispatchQueue.main.async {
			if let selectedAnnotation = page.annotationWithHitTest(at: point) {
				self.undoManager.registerUndo(withTarget: self){target in
					page.addAnnotation(selectedAnnotation)
				}
				selectedAnnotation.page?.removeAnnotation(selectedAnnotation)
			}
		}
		
	}
	private func clear(onDocument: PDFDocument) {/*actually clears the annotations off of the pdf*/
		undoManager.beginUndoGrouping()/*Groups all of the cleared annotations together so when you undo you get them all back*/
		let numPages = onDocument.pageCount/*this gives me the number of pages in the PDF Document because apple doesnt just supply the pages in a PDFDocument as an Array...*/
		for pageNumber in 0..<numPages{/*itterate through each page of the PDF document*/
			let onPage = onDocument.page(at: pageNumber)/*get the page*/
			
			for annotations in onPage!.annotations{/*remove each annotation on page*/
				undoManager.registerUndo(withTarget: self){target in/*register the removal to undo*/
					onPage!.addAnnotation(annotations)
				}
				onPage!.removeAnnotation(annotations)/*remove the annotation*/
			}
		}
		undoManager.endUndoGrouping()/*stop the undo register*/
		
	}
	
	func clear() {/*invoke clear*/
		guard let docutment = pdfView.document else {
			return
		}
		clear(onDocument: docutment)
	}
	func undo()  {/*invoke undo*/
		undoManager.undo()
	}
	func redo() {/*invoke redo but this doesnt really work yet*/
		undoManager.redo()
	}
	private func drawAnnotation(onPage: PDFPage) {
		guard let path = path else { return }
			 
		if currentAnnotation == nil {
			currentAnnotation = createAnnotation(path: path, page: onPage)
		}
		
		currentAnnotation?.path = path
		forceRedraw(annotation: currentAnnotation!, onPage: onPage)
	}
	private func forceRedraw(annotation: PDFAnnotation, onPage: PDFPage) {
		onPage.removeAnnotation(annotation)
		onPage.addAnnotation(annotation)
	}
	
}


extension PDFPage {
	func annotationWithHitTest(at: CGPoint) -> PDFAnnotation? {
		for annotation in annotations {
			if annotation.contains(point: at) {
				return annotation
			}
		}
		return nil
	}
}
