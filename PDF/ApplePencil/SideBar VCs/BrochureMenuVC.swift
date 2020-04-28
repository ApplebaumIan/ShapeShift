//
//  BrochureMenuVC.swift
//  Product Visualizer
//
//  Created by Likhon Gomes on 8/15/18.
//  Copyright © 2018 Ian Applebaum. All rights reserved.
//

import UIKit


class BrochureMenuVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var outerBox: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var ListOfbros:Array<Brochure> = []
    var bros:Array<Brochure> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadJSON()
        collectionView.delegate = self
        collectionView.dataSource = self
        outerBox.layer.cornerRadius = 20
        outerBox.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        outerBox.clipsToBounds = true
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView.reloadData()
        print(self.bros.count)
        return self.bros.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        loadJSON()

        let data = bros[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let title = cell.viewWithTag(5) as! UILabel
        let description = cell.viewWithTag(1) as! UILabel
        let thumbnail = cell.viewWithTag(2) as! UIImageView
        let selectionBox = cell.viewWithTag(3) as! UIButton
        
        title.text = data.title
        description.text = data.description
        //print("fdjgj jhg jghf jgvj fjgkjhgk ufk")
        //print(data.thumbnail_link)
        
        DispatchQueue.main.async {
            self.getImage(imageView:thumbnail, indexPath: indexPath, name: "brochures")
        }
        return cell
    }
    func loadJSON() {
                var json = JSONfuncs()
               let data = json.readepotekDataFromDisk(name: "brochures")
                do{
                    self.bros = try JSONDecoder().decode([Brochure].self, from: data!)
                    //self.ListOfbros = bros
                    //print(self.bros[0].title)
                    //print(self.bros[10].title)
                    //print(self.bros.count)
                    //self.collectionView.reloadData()
                   // print("===========================================================")
                } catch let jsonErr {
                    print("===========================================================")
                    print("Error serializing json", jsonErr)
                    print("===========================================================")
            
        }
            }


    func getImage(imageView:UIImageView,indexPath:IndexPath,name:String) {
        var json = JSONfuncs()
        //let url:URL = URL(string:url)!
        //URLSession.shared.dataTask(with: url) { (data, resonse, err) in
        //var data = json.readepotekDataFromDisk(name: "brochures")
        let data = json.readepotekImageFromDisk(name: json.getTitleOfThumb(indexPath: indexPath, name: name))
        if data != nil{
                let image = UIImage(data:data!)
                if image != nil {
                    DispatchQueue.main.async {
                       // print("it worked")
                        imageView.image = image
                    }
                }
            }
        //}.resume()
    }
    
    
    func prepareforReuse() {
        
        self.collectionView.reloadData()
    }
    
    @IBAction func dismissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
