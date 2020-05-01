//
//  HandwritingRecognition.swift
//  ShapeShifter
//
//  Created by Ian Applebaum on 4/19/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
import SwiftOCR
extension PDFDraw{
	public func setup () {
        resetDoodleRect()
        
        lastTouchTimestamp = 0
        
        if #available(iOS 10.0, *) {
            trackTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: {
                timer in
                
                let now = Date().timeIntervalSince1970
                
                if Int(self.lastTouchTimestamp!) > 0 && now - self.lastTouchTimestamp! > 1 {
                    self.drawDoodlingRect(context: self.context)
                }
            })
        } else {}
    }
	
	func resetDoodleRect() {
		minX = Int(self.pdfView.frame.width)
		minY = Int(self.pdfView.frame.height)
		   
		   maxX = 0
		   maxY = 0
		   
		   lastTouchTimestamp = 0
		   
		UIGraphicsBeginImageContextWithOptions(self.pdfView.bounds.size, false, 0.0)
		   context = UIGraphicsGetCurrentContext()
	   }
	func drawDoodlingRect(context: CGContext?) {
        let inset = 10
        
//        markerColor.setStroke()
        context!.setLineWidth(1.0)
        context!.setLineCap(.round)
        UIColor.clear.setFill()
        
        ocrImageRect = CGRect(x: minX - inset, y: minY - inset, width: (maxX-minX) + inset*2, height: (maxY-minY) + 2*inset)
        context!.addRect(ocrImageRect!)
        context!.strokePath()
        
        drawTextRect(context: context, rect: ocrImageRect!)
        let ss = ScreenshotSharer()
		imageView?.image = ss.takeImageOf(view: pdfView)
        
        fetchOCRText()
        
        resetDoodleRect()
    }

    func drawTextRect(context: CGContext?, rect: CGRect) {
        UIColor.lightGray.setStroke()
        currentTextRect = CGRect(x: rect.origin.x, y: rect.origin.y + rect.height, width: rect.width, height: 15)
        context!.addRect(currentTextRect!)
        context!.strokePath()
    }
	func fetchOCRText () {
        let manager = CognitiveServices()
        
		let ocrImage = imageView!.image!.crop(rect: ocrImageRect!)
        
//        manager.retrieveTextOnImage(ocrImage) {
//            operationURL, error in
//
//            if #available(iOS 10.0, *) {
//
//                guard let _ = operationURL else {
//                    print("Seems like the network call failed - did you enter the Computer Vision Key in CognitiveServices.swift in line 69? :)")
//                    return
//                }
//
//                let when = DispatchTime.now() + 2
//                DispatchQueue.main.asyncAfter(deadline: when) {
//
//                    manager.retrieveResultForOcrOperation(operationURL!, completion: {
//                        results, error -> (Void) in
//
//                        if let theResult = results {
//                            var ocrText = ""
//                            for result in theResult {
//                                ocrText = "\(ocrText) \(result)"
//                            }
//                            self.addLabelForOCR(text: ocrText)
//                        } else {
//                            self.addLabelForOCR(text: "No text for writing")
//                        }
//
//                    })
//                }
//            }
//        }
		let swiftOCRInstance = SwiftOCR()
		
		swiftOCRInstance.recognize(ocrImage) { recognizedString in
			print("\(recognizedString)")
		}
    }
	public func retrieveTextOnImage(_ image: UIImage, completion: @escaping (String?, NSError?) -> ()) {
        
        assert(CognitiveServicesComputerVisionAPIKey.count > 0,
               "Please set the value of the API key variable (CognitiveServicesVisualFeaturesAPIKey) before attempting to use the application.")
        
        var urlString = CognitiveServicesConfiguration.HandwrittenOcrURL
        urlString += "?\(CognitiveServicesHTTPParameters.Handwriting)=true"
        
        let url = URL(string: urlString)
        print("calling the following URL: \(String(describing: url))")
        let request = NSMutableURLRequest(url: url!)
        
        request.addValue(CognitiveServicesComputerVisionAPIKey,
                         forHTTPHeaderField: CognitiveServicesHTTPHeader.SubscriptionKey)
        request.addValue(CognitiveServicesHTTPContentType.OctetStream,
                         forHTTPHeaderField: CognitiveServicesHTTPHeader.ContentType)
        
		let requestData = image.jpegData(compressionQuality: CognitiveServicesConfiguration.JPEGCompressionQuality)
        request.httpBody = requestData
        request.httpMethod = CognitiveServicesHTTPMethod.POST
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("executed task")
            if let error = error {
                completion(nil, error as NSError?)
                return
            }
            
            let headerFields = (response as! HTTPURLResponse).allHeaderFields
            
            let operationID = headerFields["Operation-Location"] as? String
            if let opID = operationID {
                completion(opID, nil)
            } else {
                completion(nil, nil)
            }
            
        }
        
        task.resume()
    }
	func addLabelForOCR(text: String) {
        DispatchQueue.main.async {
            let label = UILabel(frame: self.currentTextRect!)
            print(label.frame)
            label.text = text.count > 0 ? text : "Text not recognized"
            label.font = UIFont(name: "Helvetica Neue", size: 9)
//			self.pdfView.pdfpages
			self.pdfView.addSubview(label)
        }
    }
}

extension UIImage {
func crop( rect: CGRect) -> UIImage {
	var rect = rect
	rect.origin.x*=self.scale
	rect.origin.y*=self.scale
	rect.size.width*=self.scale
	rect.size.height*=self.scale
	
	let imageRef = self.cgImage!.cropping(to: rect)
	let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
	return image
	}
}
