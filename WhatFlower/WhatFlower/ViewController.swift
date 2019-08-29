//
//  ViewController.swift
//  WhatFlower
//
//  Created by Tanaka Mazivanhanga on 7/26/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var wikipediaImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let imagePicker = UIImagePickerController()
    var flowerName = ""
    
    let wikipediaURl = "https://en.wikipedia.org/w/api.php"
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imagePicker.dismiss(animated: true, completion: nil)
            guard let convertedCIImage = CIImage(image: image) else {fatalError()}
            detect(flowerImage: convertedCIImage)
            
        }
    }
    func getFlowerImageData(url: String, parameters: [String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                let flowerJSON: JSON = JSON(response.result.value!)
                //                self.updateWeatherData(json: weatherJSON)
                //                self.updateUIWithWeatherData()
                let pageids = flowerJSON["query"]["pageids"][0].intValue
                let filename = flowerJSON["query"]["pages"]["\(pageids)"]["images"][0]["title"].stringValue
                
               
                
                
               
                
               let imageURLParamas =  ["action": "query",
                "format": "json",
                "prop": "imageinfo",
                "iiprop": "url",
                "indexpageids" : "",
                "titles": filename]
               
                self.getImageSource(url: self.wikipediaURl, parameters: imageURLParamas)
                
                
            }else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    func getImageSource(url: String, parameters: [String:String]){
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                let flowerJSON: JSON = JSON(response.result.value!)
               
                let pageids = flowerJSON["query"]["pageids"][0].stringValue
                let fileUrl = flowerJSON["query"]["pages"][pageids]["imageinfo"][0]["url"].stringValue
                print(pageids)
                print(fileUrl)
                let imageData =  try? Data(contentsOf: URL(string: fileUrl)!)
                if let imageData = imageData {
                    self.wikipediaImageView.image = UIImage(data: imageData)
                }
                //self.wikipediaImageView.image = UIImage(data: Data)

                
            }else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
        
    }


    
    
    func getFlowerData(url: String, parameters: [String:String]){
        
        
        
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                let flowerJSON: JSON = JSON(response.result.value!)
//                self.updateWeatherData(json: weatherJSON)
//                self.updateUIWithWeatherData()
                let pageids = flowerJSON["query"]["pageids"][0].intValue
                let description = flowerJSON["query"]["pages"]["\(pageids)"]["extract"].stringValue
                let flowerImageURL = flowerJSON["query"]["pages"]["\(pageids)"]["thumbnail"]["source"].stringValue
                
                self.imageView.sd_setImage(with: URL(string: flowerImageURL))
                
                DispatchQueue.main.async {
                    self.updateUI(description)

                }
                
               // print(flowerJSON["query"]["pages"]["\(pageids)"]["extract"].stringValue)
                
            }else{
                print("Error \(String(describing: response.result.error))")
                
            }
        }
    }
    
    func updateUI(_ description: String){
        label.text = description
    }
    
    func detect(flowerImage: CIImage){
        do{
            let model = try VNCoreMLModel(for: FlowerClassifier().model)
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else{ fatalError()}
                //print(results)
                self.navigationItem.title = results.first?.identifier
                self.flowerName = results.first!.identifier
                
            }
            
            let handler = VNImageRequestHandler(ciImage: flowerImage)
            try handler.perform([request])
            let parameters : [String:String] = [
                "format" : "json",
                "action" : "query",
                "prop" : "extracts|pageimages",
                "exintro" : "",
                "explaintext" : "",
                "titles" : self.flowerName,
                "indexpageids" : "",
                "redirects" : "1",
                "pithumbsize" : "500"
            ]
            self.getFlowerData(url: self.wikipediaURl, parameters: parameters)
            
            let Imageparameters = [
                "action":"query",
                "format":"json",
                "prop":"images",
                "indexpageids" : "",
                "titles":self.flowerName,
                "redirects" : "1",
            ]
            self.getFlowerImageData(url: wikipediaURl, parameters: Imageparameters)
            
            
        }
        catch{
            print(error.localizedDescription)
        }
    }

    @IBAction func cameraButtonTouched(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

