//
//  ViewController.swift
//  Detect The Pic
//
//  Created by ESHITA on 09/11/19.
//  Copyright © 2019 ESHITA. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var resnetModel = Resnet50()
    var resultsText = [VNClassificationObservation]()
    var pickerController = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        pickerController.delegate = self
        if let image = imageView.image{
            detectPicture(image: image)
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            detectPicture(image: image)
        }
        pickerController.dismiss(animated: true, completion: nil)
    }

    func detectPicture (image: UIImage){
        if let model = try? VNCoreMLModel(for: resnetModel.model){
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    //print(results)
                    self.resultsText = Array(results.prefix(20))
                    self.tableView.reloadData()
                    //                    for result in results {
                    //                        print("\(result.identifier): \(result.confidence * 50)%")
                    //                    }
                }
            }
            if let imageData = image.jpegData(compressionQuality: 1.0){
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsText.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = resultsText[indexPath.row]
        
        let name = result.identifier.prefix(30)
        cell.textLabel?.text = ("\(name): \(Int(result.confidence * 100))%").capitalized
        //FOR WHITE COLOR TEXT
        //cell.textLabel?.textColor = UIColor.init(displayP3Red: 1, green: 1, blue: 1, alpha: 1)
        
        //FOR BLACK COLOR :-
        cell.textLabel?.textColor = UIColor.init(displayP3Red: 0, green: 0, blue: 0, alpha: 1)
        //cell.textLabel?.font = UIFont(name: "TimesNewRomanPSMT", size: 22.0)
        cell.textLabel?.font = UIFont(name: "Apple SD Gothic Neo Light", size: 22.0)
       // cell.backgroundColor = UIColor.init(red: 0.5765, green: 0.6667, blue: 0.7294, alpha: 1)
        cell.backgroundColor = UIColor.init(red: 0.8588, green: 0.5686, blue: 0.549, alpha: 0.5)
        return cell
    }
    
    
    @IBAction func mediaTapped(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
}

