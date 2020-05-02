//
//  PDFAnnotationWithPath.swift
//  PDFKit Demo
//
//  Created by Tim on 06/02/2019.
//  Copyright © 2019 Tim. All rights reserved.
//

import UIKit
import PDFKit
import Foundation

extension PDFAnnotation {
    
    func contains(point: CGPoint) -> Bool {
		var hitPaths: [CGPath] = []
		if let paths = paths{
			for path in paths{
				var hitPath: CGPath?
				 hitPath = path.cgPath.copy(strokingWithWidth: 10.0, lineCap: .round, lineJoin: .round, miterLimit: 0)
				if let hitPath = hitPath{
					hitPaths.append(hitPath)
				}
			}
			
		}
		for path in hitPaths {
			if path.contains(point) {
				return true
			}
		}
        
        return  false
    }

}
