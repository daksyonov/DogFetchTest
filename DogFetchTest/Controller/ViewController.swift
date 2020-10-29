//
//  ViewController.swift
//  DogFetchTest
//
//  Created by Dmitry Aksyonov on 19.10.2020.
//

import UIKit

class ViewController: UIViewController {
    
    let imageData: String! = nil
    var breeds: [String] = ["poodle", "greyhound"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        DogAPI.requestBreedsList { data, error in
            self.breeds = data?.sorted() ?? []
            
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        }
    }
    
    func handleImageFileResponse(_ image: UIImage?, error: Error?) {
        guard let image = image else { return }
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
    
    func handleBreedsList(_ list: [String]?, error: Error?) {
        guard let list = list else { return }
        
        self.breeds = list.sorted()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pickerView: UIPickerView!
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: self.breeds[row]) { dogImage, error in
            guard let dogImage = dogImage else { return }
            DogAPI.requestImageFile(dogImage, completion: self.handleImageFileResponse(_:error:))
        }
    }
}
