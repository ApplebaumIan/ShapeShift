//
//  PDFDrawingTools.swift
//  Product Visualizer
//
//  Created by Ian Applebaum on 1/2/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
class PDFDrawingTools{
	/*all of the delagates needed for PDFDrawingTools to work*/
	var pdfViewDelagate : MainPDFView?
	var pdfDrawDelagate :PDFDraw?
	var viewController : UIViewController?
	var viewToAddTools: UIView?
	var markupButtondDel: UIStackView?
	var defaults = UserDefaults.standard
	var snackbar = UISnackbar()
	
	/*UIButtons for tool icons. I created these in a fancy closure way*/
	let undoButton: UIButton = {
		let button = UIButton(type: .custom)
		
		let undoIcon = #imageLiteral(resourceName: "Undo")
			
		let image = undoIcon.resized(newSize: CGSize(width: 50, height: 50))
			button.setImage(image, for: .normal )
		
		
		return button
	}()
	let clearButton: UIButton = {
		let button = UIButton(type: .custom)
		//button.setImage(#imageLiteral(resourceName: "cancel_button.png"), for: .normal)
		let resized = #imageLiteral(resourceName: "cancel_button").resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(resized, for: .normal)
		//button.setTitle("clear", for: .normal)
		//button.titleLabel?.font = .boldSystemFont(ofSize: 24)

		return button
	}()
	/*this button switches the color tool and also shows the current tool used.*/
	let colorButton: UIButton = {
		let button = UIButton(type: .custom)
		let image = #imageLiteral(resourceName: "blue_orb.png")
		var pen : UIImage
		
		switch UserDefaults.standard.value(forKey: "colorVal") as? String ?? "black"{/*The current tool selected is saved and called in UserDefualts so that pen color is consistent between view controllers and session. This is to keep the user from constantly switching to the color tool they want every time they start a new session.*/
		case "black":
			pen = #imageLiteral(resourceName: "black_pencil-3")
		case "red":
			pen = #imageLiteral(resourceName: "red_pencil-3")
		case "blue":
			pen = #imageLiteral(resourceName: "blue_pencil-3")
		default:
			pen = #imageLiteral(resourceName: "black_pencil-3")
		}

		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		
		return button
	}()
	/*these buttons are the buttons displayed when colorButton is tapped. the @objc functions are whats called when the button is tapped to actually select the tool.*/
	let redButton: UIButton = {
		let button = UIButton(type: .custom)
		let image = #imageLiteral(resourceName: "blue_orb.png")
		let pen = #imageLiteral(resourceName: "red_pencil-3")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		return button
	}()
	@objc func redSelect(){
		pdfDrawDelagate!.colorVal = "red"
		pdfDrawDelagate!.currentTool = .pen
		let pen = #imageLiteral(resourceName: "red_pencil-3")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		self.colorButton.setImage(penResize, for: .normal)
		penMode()
	}
	@objc func blackSelct(){
		pdfDrawDelagate!.colorVal = "black"
		pdfDrawDelagate!.currentTool = .pen
		let pen = #imageLiteral(resourceName: "black_pencil-3")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		self.colorButton.setImage(penResize, for: .normal)
		penMode()
	}
	@objc func blueSelect(){
		pdfDrawDelagate!.colorVal = "blue"
		pdfDrawDelagate!.currentTool = .pen
		let pen = #imageLiteral(resourceName: "blue_pencil-3")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		self.colorButton.setImage(penResize, for: .normal)
		penMode()
	}
	let blueButton: UIButton = {
		let button = UIButton(type: .custom)//
		let image = #imageLiteral(resourceName: "blue_orb.png")
		let pen = #imageLiteral(resourceName: "blue_pencil-3")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		return button
	}()
	let blackButton: UIButton = {
		let button = UIButton(type: .custom)//
		let image = #imageLiteral(resourceName: "blue_orb.png")
		let pen = #imageLiteral(resourceName: "black_pencil-3")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		return button
	}()
	let redHighlighter: UIButton = {
		let button = UIButton(type: .custom)
		let image = #imageLiteral(resourceName: "blue_orb.png")
		let pen = #imageLiteral(resourceName: "red_highlighter")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		return button
	}()
	@objc func redHighlightSelect(){
		pdfDrawDelagate!.colorVal = "red"
		pdfDrawDelagate!.currentTool = .highlighter
		let pen = #imageLiteral(resourceName: "red_highlighter")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		self.colorButton.setImage(penResize, for: .normal)
		penMode()
	}
	let yellowHighlighter: UIButton = {
		let button = UIButton(type: .custom)
		let image = #imageLiteral(resourceName: "blue_orb.png")
		let pen = #imageLiteral(resourceName: "yellow_highlighter")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		return button
	}()
	@objc func yellowHighlightSelect(){
		pdfDrawDelagate!.colorVal = "yellow"
		pdfDrawDelagate!.currentTool = .highlighter
		let pen = #imageLiteral(resourceName: "yellow_highlighter")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		self.colorButton.setImage(penResize, for: .normal)
		penMode()
	}
	
	/*Will bring back the eraser when its fully functional or asked for*/
	let eraserButton: UIButton = {
		let button = UIButton(type: .custom)
		let image = #imageLiteral(resourceName: "blue_orb.png")
		let pen = #imageLiteral(resourceName: "eraser-1")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		button.setImage(penResize, for: .normal)
		let resized = image.resized(newSize: CGSize(width: 50, height: 50))
		button.setBackgroundImage(resized, for: .normal)
		return button
		}()
	@objc func eraserSelect(){
		//		pdfDrawing.colorVal = "red"
		let pen = #imageLiteral(resourceName: "eraser-1")
		let penResize = pen.resized(newSize: CGSize(width: 50, height: 50))
		self.colorButton.setImage(penResize, for: .normal)
		pdfDrawDelagate!.currentTool = .eraser
		penMode()
	}
	
	func setUpButtons() {/*This function sets up all the targets for each of the buttons.*/
		undoButton.addTarget(self, action: #selector(handleUndo), for: .touchUpInside)
		clearButton.addTarget(self, action: #selector(handleClear), for: .touchUpInside)
		colorButton.addTarget(self, action: #selector(penMode), for: .touchUpInside)
		redButton.addTarget(self, action: #selector(redSelect), for: .touchUpInside)
		redHighlighter.addTarget(self, action: #selector(redHighlightSelect), for: .touchUpInside)
		yellowHighlighter.addTarget(self, action: #selector(yellowHighlightSelect), for: .touchUpInside)
		eraserButton.addTarget(self, action: #selector(eraserSelect), for: .touchUpInside)
		blueButton.addTarget(self, action: #selector(blueSelect), for: .touchUpInside)
		blackButton.addTarget(self, action: #selector(blackSelct), for: .touchUpInside)
		/*future long gesture support for redo*/
		/*
		let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleRedo))
		undoButton.addGestureRecognizer(longGesture)
		*/
	}
	/*These functions hide and show the change color tool switcher.*/
	fileprivate func showToolSwitcher(_ colorButtonView: UIView, _ redButtonView: UIView, _ blueButtonView: UIView, _ blackButtonView: UIView, _ redHiglighterView: UIView, _ yellowHighlighterView: UIView, _ clearButtonView: UIView, _ eraserButtonView: UIView, _ undoButtonView: UIView) {
		// Animates removing the first item in the stack.
		UIView.animate(withDuration: 0.15) { () -> Void in
			colorButtonView.isHidden = false
			redButtonView.isHidden = true
			blueButtonView.isHidden = true
			blackButtonView.isHidden = true
			redHiglighterView.isHidden = true
			yellowHighlighterView.isHidden = true
			clearButtonView.isHidden = false
			//			eraserButtonView.isHidden = true
			undoButtonView.isHidden = false
			//					undoView.isHidden = false
			//grabView.isHidden = false
		}
	}
	
	fileprivate func hideToolSwitcher(_ colorButtonView: UIView, _ redButtonView: UIView, _ blueButtonView: UIView, _ blackButtonView: UIView, _ redHiglighterView: UIView, _ yellowHighlighterView: UIView, _ clearButtonView: UIView, _ eraserButtonView: UIView, _ undoButtonView: UIView) {
		UIView.animate(withDuration: 0.15) { ()
			colorButtonView.isHidden = true
			redButtonView.isHidden = false
			blueButtonView.isHidden = false
			blackButtonView.isHidden = false
			redHiglighterView.isHidden = false
			yellowHighlighterView.isHidden = false
			clearButtonView.isHidden = true
			//			eraserButtonView.isHidden = false
			undoButtonView.isHidden = true
			//					undoView.isHidden=true
			//grabView.isHidden=true
			//self.stackViewGlobal.axis = .horizontal
		}
	}
	fileprivate func hideToolSwitcher(_ stackView: UIStackView) {
		let redButtonView = stackView.arrangedSubviews[1]
		let blueButtonView = stackView.arrangedSubviews[2]
		let blackButtonView = stackView.arrangedSubviews[3]
		let yellowHighlighterView = stackView.arrangedSubviews[4]
		let redHighlighterView = stackView.arrangedSubviews[5]
		let eraserButtonView = stackView.arrangedSubviews[6]
		let clearButtonView = stackView.arrangedSubviews[7]
		let undoButtonView = stackView.arrangedSubviews[8]
		UIView.animate(withDuration: 0.15){()
			redButtonView.isHidden = true
			blueButtonView.isHidden = true
			blackButtonView.isHidden = true
			yellowHighlighterView.isHidden = true
			redHighlighterView.isHidden = true
			eraserButtonView.isHidden = true
			clearButtonView.isHidden = false
			undoButtonView.isHidden = false
		}
	}
	var chooseTool = false {/*this variable controls whether the tool switcher is invoked. ig its false we show the tool switcher. if its true we hide them because a tool has been chosen.*/
		didSet{
			let colorButtonView = self.markupButtondDel!.arrangedSubviews[0]
			let redButtonView = self.markupButtondDel!.arrangedSubviews[1]
			let blueButtonView = self.markupButtondDel!.arrangedSubviews[2]
			let blackButtonView = self.markupButtondDel!.arrangedSubviews[3]
			let yellowHighlighterView = self.markupButtondDel!.arrangedSubviews[4]
			let redHiglighterView = self.markupButtondDel!.arrangedSubviews[5]
			let eraserButtonView = self.markupButtondDel!.arrangedSubviews[6]
			let clearButtonView = self.markupButtondDel!.arrangedSubviews[7]
			let undoButtonView = self.markupButtondDel!.arrangedSubviews[8]
			if chooseTool == false {
				showToolSwitcher(colorButtonView, redButtonView, blueButtonView, blackButtonView, redHiglighterView, yellowHighlighterView, clearButtonView, eraserButtonView, undoButtonView)
			}else {
				hideToolSwitcher(colorButtonView, redButtonView, blueButtonView, blackButtonView, redHiglighterView, yellowHighlighterView, clearButtonView, eraserButtonView, undoButtonView)
			}
		}
	}
	@objc func penMode(){/*this function acts as a switch to turn on and off the tool switcher*/
		if chooseTool == false {
			self.chooseTool = true
		}else {
			self.chooseTool = false
		}
		
	}
	
	private func pinBackground(_ view: UIView, to stackView: UIStackView) {/*this function is kinda cool. it just pins a background to a stackview. not really using it anymore just kinda cool*/
		view.translatesAutoresizingMaskIntoConstraints = false
		stackView.insertSubview(view, at: 0)
		view.pin(to: stackView)
	}
	
	/*This function sets up the stackView for the Tool Switcher*/
	func layOutButtons() ->UIStackView {
		let _: UIView = {
			let view = UIView()
			view.backgroundColor = #colorLiteral(red: 0.8039215803146362, green: 0.8039215803146362, blue: 0.8039215803146362, alpha: 0.75)
			view.layer.masksToBounds = true
			view.layer.borderColor = #colorLiteral(red: 0, green: 0.35, blue: 0.58, alpha: 1.0)
			view.layer.borderWidth = 3
			view.layer.cornerRadius = 5.0
			//view.roundCorners(corners: [.topRight,.bottomLeft], radius: 3.0)
			
			return view
		}()
		/*the stack view is basically an array of arranged Subviews. So each button can be called at index in the array.*/
		let stackView = UIStackView(arrangedSubviews: [colorButton,redButton,blueButton,blackButton,yellowHighlighter,redHighlighter,eraserButton,clearButton,undoButton])
		/*These functions hide all of the tool switcher buttons and only shows the colorButton (the button that switches the tool), the clear, and undo button.*/
		hideToolSwitcher(stackView)
		stackView.distribution = .fillEqually
		viewToAddTools!.addSubview(stackView)
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.leadingAnchor.constraint(equalTo: viewToAddTools!.leadingAnchor).isActive = true
		stackView.topAnchor.constraint(equalTo: viewToAddTools!.topAnchor, constant: 200).isActive = true
		stackView.axis = .horizontal
		stackView.spacing = UIStackView.spacingUseSystem
		stackView.isLayoutMarginsRelativeArrangement = true
		return stackView
	}
	/*
	So here we start trying to get a screen grab of the view. There are some issues.
	Issue 1. If you use:
	```
	UIGraphicsBeginImageContext(view.frame.size)
	view.layer.render(in: UIGraphicsGetCurrentContext()!)
	let image = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	```
	The image is blank showing none of the PDF markup...
	Issue 2. If you use the current method:
	```
	let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteURL.appendingPathComponent("webViewPdf.pdf")
	let image = drawPDFfromURL(url: doc)
	return image ?? #imageLiteral(resourceName: "molecules")
	```
	we could have pdfs with multiple pages which make things tricky...
	*/
	func getImage() -> UIImage {
		let doc = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteURL.appendingPathComponent("webViewPdf.pdf")
		let image = drawPDFfromURL(url: doc)
		//hideNavigation()
		//		UIGraphicsBeginImageContext(view.frame.size)
		//		view.layer.render(in: UIGraphicsGetCurrentContext()!)
		//		let image = UIGraphicsGetImageFromCurrentImageContext()
		//		UIGraphicsEndImageContext()
		//		showNavigation()
		//stackViewGlobal.isHidden = false//
		
		return image ?? #imageLiteral(resourceName: "molecules")
	}
	/*Most of this code is a mess. We have to implement this properly. */
	@objc func takeScreenshotButtonClicked(){
		let image = getImage()/*the screenshot*/
		//HELLO I NEED TO FIX THIS
		
		//sqlFuncClass.saveScreenShotImageOnDisk(ScreenShot: image!, name: "ScreenShot\(self.count)")//name of screenshot could be changed to customer name, data ,or whatever we choose!
		//temporary share sheet
		var imagesToShare = [AnyObject]()
		imagesToShare.append(image)
		
		//        let screenshot = UIImage(sqlFuncClass.readScreenShotImageFromDisk(name: "ScreenShot\(count)"))
		//        imagesToShare.append( )
		//        let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
		//        activityViewController.popoverPresentationController?.sourceView = self.view
		//        present(activityViewController, animated: true, completion: nil)
		
		//let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("screenshot")
		do{
			let screenShotImage = try
				FileManager.default.url(for: .documentDirectory,
										in: .userDomainMask,
										appropriateFor: nil,
										create:true)//directory to save the file to.
			let pathToScreenShot = screenShotImage.appendingPathComponent("screenshot.png")
			print(pathToScreenShot)
			if let data = image.pngData(),!FileManager.default.fileExists(atPath: pathToScreenShot.path){
				do{
					try data.write(to: pathToScreenShot)
					print("saved screenshot")
				}catch{
					print("FUCK screenshot didnt save...: \(error)")
				}
			}
			//this is where insert goes
			let path_to_image = pathToScreenShot.path
			let screenshot = ScreenShots(user_id: 1, name: "Test Screenshot", note: "test", path: path_to_image)
			let screenshot_handle = ScreenshotDB()
			screenshot_handle.insert(screenshot: screenshot)
			print("Inserted")
		}catch{
			print("file error \(error)")
		}
		
		
		//  let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
		//activityViewController.popoverPresentationController?.sourceView = self.view
		//present(activityViewController, animated: true, completion: nil)
		print("button pressed")
		viewController!.present(ScreenshotViewController(), animated: true, completion: nil)//I'm leaving this as the default card view because i think it will look and feel better. ~Ian
		
		//  let activityViewController = UIActivityViewController(activityItems: imagesToShare , applicationActivities: nil)
		//activityViewController.popoverPresentationController?.sourceView = self.view
		//present(activityViewController, animated: true, completion: nil)
		print("button pressed")
		
	}
	
	func drawPDFfromURL(url: URL) -> UIImage? {/*this function makes a pdf an image*/
		guard let document = CGPDFDocument(url as CFURL) else { return nil }
		guard let page = document.page(at: 1) else { return nil }
		
		let pageRect = page.getBoxRect(.mediaBox)
		let renderer = UIGraphicsImageRenderer(size: pageRect.size)
		let img = renderer.image { ctx in
			UIColor.white.set()
			ctx.fill(pageRect)
			
			ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
			ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
			
			ctx.cgContext.drawPDFPage(page)
		}
		
		return img
	}
	
	func takeScreenshotButtonSetup() {
		/*
		takeScreenshotButton.translatesAutoresizingMaskIntoConstraints = false
		//		takeScreenshotButton.backgroundColor = .orange
		takeScreenshotButton.setTitleColor(.black, for: .normal)
		//		takeScreenshotButton.setTitle("Take Screenshot", for: .normal)
	//		takeScreenshotButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
		takeScreenshotButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
			takeScreenshotButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
		takeScreenshotButton.addTarget(self, action: #selector(takeScreenshotButtonClicked), for: .touchUpInside)
			takeScreenshotButton.contentMode = .scaleAspectFit
		takeScreenshotButton.clipsToBounds = true
		takeScreenshotButton.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
		let resized = #imageLiteral(resourceName: "screen_grab2.png").resized(newSize: CGSize(width: 50, height: 50))
		takeScreenshotButton.setImage(resized, for: .normal)
		view.addSubview(takeScreenshotButton)
		takeScreenshotButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 350).isActive = true
		takeScreenshotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -5).isActive = true
		*/
	}
	/*these functions call PDFDraw undo and redo*/
	@objc fileprivate func handleUndo() {
		pdfDrawDelagate!.undo()
	}
	@objc fileprivate func handleRedo() {
		pdfDrawDelagate!.redo()
	}
	func checkForAnnotations() -> Bool {/*this function checks whether there are any annotations on the pdf you are marking up. returns true if there are any annotations.*/
		let numPAge = self.pdfViewDelagate?.document?.pageCount
		for i in 0..<numPAge!{
			if (self.pdfViewDelagate?.document?.page(at: i)?.annotations.isEmpty)!{
				continue
			}
			else{
				return true
			}
		}
		return false
	}
	@objc func handleClear() {
		if checkForAnnotations() {
			self.pdfDrawDelagate?.clear()
		}else{
			nothingToClear()
		}
		/*this is no longer used because clear is no longer destructive. I left this here because I thought it was a good example of an alert.*/
		/*
		// Create the alert controller
		let alertController = UIAlertController(title: "Clear Annotations?", message: "Clearing annotations will permanently remove all drawings from the screen. You cannot undo this action.", preferredStyle: .alert)
		
		// Create the actions
		let okAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive) {
		UIAlertAction in
		NSLog("OK Pressed")
		//			self.canvas.clear()
		self.pdfDrawDelagate!.clear()
		//self.showNavigation()
		//self.canvasView.clearCanvas(animated: true)
		//self.clearButton.isHidden = true
		}
		let grabAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default) {
		UIAlertAction in NSLog("Save pressed.")
		self.takeScreenshotButtonClicked()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
		UIAlertAction in
		NSLog("Cancel Pressed")
		//self.showNavigation()
		// self.clearButton.isHidden = false
			}
		let image = getImage()
		alertController.addImage(image: image)
		//alertController.view.tintColor = #colorLiteral(red: 0, green: 0.35, blue: 0.58, alpha: 1.0)
		//alertController.view.window!.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 0)
		let subview :UIView = alertController.view.subviews.first! as UIView
		_ = subview.subviews.first! as UIView
		//alertContentView.backgroundColor = #colorLiteral(red: 0, green: 0.35, blue: 0.58, alpha: 1.0)
		//alertContentView.layer.cornerRadius = 15//roundCorners(corners: UIRectCorner([.topLeft,.topRight,.bottomLeft,.bottomRight]), radius: 5)
			alertController.view.tintColor = #colorLiteral(red: 0, green: 0.35, blue: 0.58, alpha: 1.0)
		// Add the actions
		alertController.addAction(okAction)
		alertController.addAction(grabAction)
		alertController.addAction(cancelAction)
		// Present the controller
		viewController!.present(alertController, animated: true, completion: nil)
		*/
		
	}
	func getColor()->String{/*The current color value of the tool used.*/
		return pdfDrawDelagate!.colorVal
	}
	
	/*this sets up the snackbar to notify the user of markups stuff such as when there is nothing to clear*/
	func snackbarSetup() {
		viewController!.view.addSubview(snackbar)
		snackbar.centerXAnchor.constraint(equalTo: viewController!.view.centerXAnchor).isActive = true
		snackbar.bottomAnchor.constraint(equalTo: viewController!.view.bottomAnchor).isActive = true
	}
	func nothingToClear() {
		print("nothing to clear")
		snackbar.show(message: "Nothing to clear.",duration: 3)
	}
	
}
