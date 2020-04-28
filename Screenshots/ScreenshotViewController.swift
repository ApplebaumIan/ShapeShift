//
//  ScreenshotViewController.swift
//  Product Visualizer
//
//  Created by Tommy Tan on 7/30/19.
//  Copyright © 2019 Ian Applebaum. All rights reserved.
//

import UIKit
class ScreenshotViewController:  ScreenshotSharerViewController {
	
	override func loadView() {
		super.loadView()

	}
	override func viewDidLoad() {
		super.viewDidLoad()
		if #available(iOS 13.0, *) {
			overrideUserInterfaceStyle = .light
		} else {
			// Fallback on earlier versions
		}
		
		//		 addBackground()
	}




	let imageView = UIImageView()

	override func setScreenshotImage(_ image: UIImage) {
		//		let image = #imageLiteral(resourceName: "thumbnail_selectorguide")//UIImage.init(contentsOfFile: ss.path!)
		imageView.image = image
		let sizeOfImage: CGSize = CGSize(width: image.size.width/2, height: image.size.height/2)
		imageView.frame = CGRect(origin: CGPoint(x: 0, y: 20), size: sizeOfImage)//CGRect(x: 500, y: 350, width: 100, height: 200)
		//		imageView.addSubview(backgroundView)
		//		imageView.pin(to: backgroundView)
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.black.cgColor
		view.addSubview(imageView)

	}



}
