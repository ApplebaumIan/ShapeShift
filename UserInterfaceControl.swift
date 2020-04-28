//
//  UserInterfaceControl.swift
//  ShapeShifter
//
//  Created by Ian Applebaum on 4/19/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
let deleteSessionIcon = UIImage(systemName: "trash")
@available(iOS 13.0, *)
let emailToCustomerIcon = UIImage(systemName: "envelope.fill")
@available(iOS 13.0, *)
let addCustomerIcon = UIImage(systemName: "person.badge.plus.fill")
@available(iOS 13.0, *)
let switchCustomerIcon = UIImage(systemName: "person.fill")
@available(iOS 13.0, *)
let adminIcon = UIImage(systemName: "gear")
@available(iOS 13.0, *)
let backButtonIcon = UIImage(systemName: "chevron.left")
extension UIViewController{
	func defaultPresent(vc:UIViewController){
		/*vc.modalPresentationStyle = .fullScreen
		vc.modalTransitionStyle = .crossDissolve
		present(vc, animated: true, completion: nil)*/
		self.navigationController?.pushViewController(vc, animated: true)
	}
	func overLayPresent(vc:UIViewController){
		vc.modalPresentationStyle = .overCurrentContext
		vc.modalTransitionStyle = .crossDissolve
		present(vc, animated: true, completion: nil)
	}
}
public extension UIAlertController{
    func addImage(image:UIImage){
        let maxSize = CGSize(width: 245, height: 300)
        let imgSize = image.size
        var ratio:CGFloat!
        if imgSize.width>imgSize.height {
            ratio = maxSize.width / imgSize.width
        }else {
            ratio = maxSize.height/imgSize.height
        }
        let scaledSize = CGSize(width: imgSize.width * ratio, height: imgSize.height * ratio)
        var resizedImage = image.resized(newSize: scaledSize)
        if imgSize.height > imgSize.width {
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0))
        }

        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        imgAction.isEnabled = false
        imgAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)

    }
}
public extension UIView {
    func pin(to view: UIView) {
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
