//
//  DocumentBrowserViewController.swift
//  ShapeShift
//
//  Created by Ian Applebaum on 4/27/20.
//  Copyright © 2020 Ian Applebaum. All rights reserved.
//

import UIKit
import SwiftUI
import AppleWelcomeScreen
class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate,UINavigationControllerDelegate {
	  /// The configuration struct that configures the appearence of our welcome screen.
		var welcomeScreenConfig = AWSConfigOptions()
	
		/// presents the welcome screen using our custom configuration.
		@objc func showWelcomeScreen() {
			  let vc = AWSViewController()
			vc.configuration = self.welcomeScreenConfig
			  self.present(vc, animated: true)
		}
	  /// Configures the welcome screen. Setting it's style, and content in `welcomeScreenConfig`.
		fileprivate func welcomeScreenSetup() {
			welcomeScreenConfig.appName = "ShapeShift"
			welcomeScreenConfig.appDescription = "ShapeShift lets you convert your hand writing into text and save it within the original PDF!"
			welcomeScreenConfig.tintColor = .systemYellow
	
			var item1 = AWSItem()
			if #available(iOS 13.0, *) {
	
				item1.image = UIImage(systemName: "pencil.and.outline")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
			} else {
				// Fallback on earlier versions
			}
			item1.title = "Handwritting Recognition"
			item1.description = "Write stuff down, instantly converts to text."
			
	
			var item2 = AWSItem()
			if #available(iOS 13.0, *) {
				item2.image = UIImage(systemName: "doc.append")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
			} else {
				// Fallback on earlier versions
			}
			item2.title = "Annotations"
			item2.description = "ShapeShift uses standard PDF annotations so you can view your drawings anywhere."
//
			var item3 = AWSItem()
			if #available(iOS 13.0, *) {
				item3.image = UIImage(systemName: "folder.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
			} else {
				// Fallback on earlier versions
			}
			item3.title = "Familiar File Management"
			item3.description = "Using the Apple Files App you can import any PDF you choose, and move them to where you want"
	
			welcomeScreenConfig.items = [item1 ]
	
			welcomeScreenConfig.continueButtonAction = {
				defaults.set(true, forKey: "WelcomeVersion1.0.0")
				self.dismiss(animated: true)
			}
		}
	override func viewDidAppear(_ animated: Bool) {
		if defaults.bool(forKey: "WelcomeVersion1.0.0") {
							   return
						   } else {
							   self.showWelcomeScreen()
		
					}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeScreenSetup()
        delegate = self
		
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
		var newDocumentURL: URL? = nil
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
		newDocumentURL = Bundle.main.url(forResource: "blank", withExtension: "pdf")
        if newDocumentURL != nil {
			importHandler(newDocumentURL, .copy)
			
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let document = Document(fileURL: documentURL)

        // Access the document
        document.open(completionHandler: { success in
            if success {
                // Display the content of the document:
//                let view = DocumentView(document: document, dismiss: {
//                    self.closeDocument(document)
//                })
				
                let documentViewController = PDFViewController(pdf: document)
				documentViewController.modalPresentationStyle = .fullScreen
                self.present(documentViewController, animated: true, completion: nil)
//
//				self.navigationController?.pushViewController(documentViewController, animated: true)
				
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
            }
        })
    }

    func closeDocument(_ document: Document) {
        dismiss(animated: true) {
            document.close(completionHandler: nil)
        }
    }
}


struct DocumentBrowserViewController_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
