//
//  DrawingRecognizer.swift
//  Product Visualizer
//
//  Created by Ian Applebaum on 8/23/19.
//  Copyright © 2019 Ian Applebaum. All rights reserved.
//
/*
This class handles the gestures for drawing on a PDF.
*/
import UIKit
protocol DrawingGestureRecognizerDelegate: class {
	func gestureRecognizerBegan(_ location: CGPoint)
	func gestureRecognizerMoved(_ location: CGPoint)
	func gestureRecognizerEnded(_ location: CGPoint)
}
class DrawingRecognizer: UIGestureRecognizer {
	weak var drawingDelegate: DrawingGestureRecognizerDelegate?
	/*these functions track the touches for drawing whether its apple pencil or finger*/
	fileprivate func drawWithApplePencil(_ touches: Set<UITouch>, _ event: UIEvent) {
		if let touch = touches.first,
			touch.type == .pencil,
			let numberOfTouches = event.allTouches?.count,
			numberOfTouches == 1 {
			state = .began
			let location = touch.location(in: self.view)
			drawingDelegate?.gestureRecognizerBegan(location)
		}
		else{
			state = .failed
		}
	}
	fileprivate func drawWithFinger(_ touches: Set<UITouch>, _ event: UIEvent) {
		if let touch = touches.first,
			let numberOfTouches = event.allTouches?.count,
			numberOfTouches == 1 {
			state = .began
			let location = touch.location(in: self.view)
			drawingDelegate?.gestureRecognizerBegan(location)
		}
		else{
			state = .failed
		}
	}
	/*Track the first touch on the view*/
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		if UserDefaults.standard.bool(forKey: "Finger") == true{
			//needs to be optimized for panning and zooming gestures like two fingers etc.
			drawWithFinger(touches, event)
		}
		else{
			drawWithApplePencil(touches, event)
		}
	}
	/*track all of the touches moved on the view*/
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		state = .changed
		guard let location = touches.first?.location(in: self.view) else {
			return
		}
		drawingDelegate?.gestureRecognizerMoved(location)
	}
	/*track where the last touch on the view was*/
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		guard let location = touches.first?.location(in: self.view) else {
			state = .ended
			return
		}
		drawingDelegate?.gestureRecognizerEnded(location)
		state = .ended
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		state = .failed
	}
}
