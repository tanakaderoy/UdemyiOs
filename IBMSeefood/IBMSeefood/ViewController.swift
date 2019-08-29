//
//  ViewController.swift
//  IBMSeefood
//
//  Created by Tanaka Mazivanhanga on 7/23/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import VisualRecognition
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let apiKey = "fgeY5uJqZvcc9Mu2FI2pF2gSXKmto28Sj5L-IMWlG5xP"
    let version = "2019-07-22"
    @IBOutlet weak var imageView: UIImageView!
    var classificationArray = [String]()
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            cameraButton.isEnabled = false
            SVProgressHUD.show()
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            guard let imageData = image.jpegData(compressionQuality: 0.01) else { fatalError() }
            guard let compressedImage = UIImage(data: imageData) else {fatalError()}
            let visualRecgnition = VisualRecognition(version: version, apiKey: apiKey)
            visualRecgnition.classify(image: compressedImage) { (classifiedImages, error) in
                
                if let classes = classifiedImages?.result?.images.first?.classifiers.first?.classes{
                    self.classificationArray = []
                    for index in 1 ..< classes.count{
                        self.classificationArray.append(classes[index].className)
                    }
                    print(self.classificationArray)
                    DispatchQueue.main.async {
                        self.cameraButton.isEnabled = true
                        SVProgressHUD.dismiss()
                    }
                    if self.classificationArray.contains("frankfurter bun"){
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Hotdog!"
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Not Hotdog!"
                        }
                        
                    }
                }
            }
        }
    }
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

