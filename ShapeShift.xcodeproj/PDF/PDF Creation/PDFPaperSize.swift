//
//  PDFPaperSize.swift
//  HTMLPDFRenderer
//
//  Copyright © 2015 Aleksandar Vacić, Radiant Tap
//	https://github.com/radianttap/HTML2PDFRenderer
//
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

extension HTML2PDFRenderer {
	public enum PaperSize {
		case a4
		case letter
		case custom(view : UIView = UIView())
		case letterLandscape
		var size: CGSize {
			switch self {
			case .a4:
				return CGSize(width: 595.2, height: 841.8)

			case .letter:
				return CGSize(width: 612, height: 792)
			case .custom:
				return sizeOfView()
			case .letterLandscape:
				return CGSize(width: 792, height: 612 )
			}
		}
	}
}
func sizeOfView(view: UIView = UIView()) -> CGSize {
	return view.frame.size
}
