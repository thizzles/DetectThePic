//
//  ViewController.swift
//  DetectThePic
//
//  Created by Tyler Hill on 6/1/23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var resnetModel = Resnet50()
    var results = [VNClassificationObservation]()
    var pickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        pickerController.delegate = self
        
        if let image = imageView.image {
            processPicture(image: image)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            processPicture(image: image)
            tableView.reloadData()
        }
        
        pickerController.dismiss(animated: true)
    }
    
    @IBAction func buttonMediaFolderTapped(_ sender: Any) {
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    @IBAction func buttonCameraTapped(_ sender: Any) {
        pickerController.sourceType = .camera
        present(pickerController, animated: true)
    }
    
    
    func processPicture(image: UIImage) {
        if let model = try? VNCoreMLModel(for: resnetModel.model) {
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation] {
                    self.results = results
                    self.tableView.reloadData()
                    
//                    for result in results {
//                        var prediction = result.identifier
//                        var initialConfidence = result.confidence * 50
//                        let formattedString = Int(round(100 * initialConfidence) / 100)
//
//                        print("My idea is that it is a \(prediction). I'm \(formattedString)% confident.")
//                        print(result)
//                    }
                }
            }
            if let image = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: image, options: [:])
                try? handler.perform([request])
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = results[indexPath.row]
        let prediction = "\(result.identifier.prefix(30))"
        let initialConfidence = result.confidence * 50
        let confidence = String(format: "%.2f", round(100 * initialConfidence) / 100)
        
        
        cell.textLabel?.text = "\(prediction): \(confidence)%"
        return cell
    }

}

