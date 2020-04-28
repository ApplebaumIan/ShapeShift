//
//  CanvasView.swift
//  Product Visualizer
//
//  Created by Ian Applebaum on 8/9/18.
//  Copyright © 2018 Ian Applebaum. All rights reserved.
//

//import Foundation
/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

let π = CGFloat.pi
class Canvas: UIView{
	public var colorVal = "black"{
		didSet{
			print("set \(colorVal)")
		}
	}
	public func undo() {
		_ = lines.popLast()//the _ is because the var is unused
		setNeedsDisplay()
	}
	public func clear(){
		UIView.animate(withDuration: 0.15) {
			_ = self.lines.removeAll()
			self.setNeedsDisplay()
		}
		
	}
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		//drawing function
		guard let context = UIGraphicsGetCurrentContext() else{return}
		switch colorVal {
		case "black":
			context.setStrokeColor(#colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
		case "red":
			context.setStrokeColor(#colorLiteral(red: 0.9254902005195618, green: 0.23529411852359772, blue: 0.10196078568696976, alpha: 1.0))
		case "blue":
			context.setStrokeColor(#colorLiteral(red: 0, green: 0.3529411765, blue: 0.5843137255, alpha: 1))
		default:
			context.setStrokeColor(#colorLiteral(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0))
		}
		
		context.setLineWidth(3)
		context.setLineCap(.round)
		//context.setLineCap(.square)
		//context.setLineCap(.butt)
		//lines
		lines.forEach( { (line) in
			for(i,p) in line.enumerated(){
				if i == 0 {
					context.move(to: p)
				}else{
					context.addLine(to: p)
				}
			}
		})
		context.strokePath()
		
	}
	//var line = [CGPoint]()
	var lines = [[CGPoint]]() // 2D Array
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		lines.append([CGPoint]())
	}
	//track finger
	var penOnly = true
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if penOnly == true{
		for touch in touches{
			if touch.type == .stylus {
				guard let point = touches.first?.location(in: nil) else {return}
				
				//let lastLine = lines.last
				guard var lastLine = lines.popLast() else {return}
				lastLine.append(point)
				lines.append(lastLine)
				//lastLine?.append(point)
				setNeedsDisplay()
			}
			
			}
		} else{
			guard let point = touches.first?.location(in: nil) else {return}
			//let lastLine = lines.last
			guard var lastLine = lines.popLast() else {return}
			lastLine.append(point)
			lines.append(lastLine)
			//lastLine?.append(point)
			setNeedsDisplay()
		}
	
	}
}
