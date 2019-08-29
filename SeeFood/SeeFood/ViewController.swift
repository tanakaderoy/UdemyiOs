//
//  ViewController.swift
//  SeeFood
//
//  Created by Tanaka Mazivanhanga on 7/22/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            guard let ciImage = CIImage(image: image) else{fatalError()}
            detect(image: ciImage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func detect(image: CIImage){
        do{
            let model = try VNCoreMLModel(for: Inceptionv3().model)
            let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else{ fatalError()}
             //   print(results)
                if let firstResult = results.first {
                    if firstResult.identifier.contains("hotdog"){
                        self.navigationItem.title = "Hotdog!"
                    }else{
                        self.navigationItem.title = "Not Hotdog"
                    }
                }
            }
            
            let handler = VNImageRequestHandler(ciImage: image)
            try handler.perform([request])
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

