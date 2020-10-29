//
//  DogAPI.swift
//  DogFetchTest
//
//  Created by Dmitry Aksyonov on 19.10.2020.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint {
        case randomFromAll
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomFromAll:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
    }
    
    class func requestImageFile(_ dogImage: DogImage, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: dogImage.message) else { return }
        
        let task2 = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let downloadedImage = UIImage(data: data)
            completion(downloadedImage, nil)
        }
        
        task2.resume()
    }
    
    class func requestRandomImage(breed: String, completon: @escaping (DogImage?, Error?) -> Void) {
        let randomImageEndpoint = DogAPI.Endpoint.randomImageForBreed(breed).url
        
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { data, response, error in
            guard let data = data else { return }
            print(data)
            
            guard let dogImage = try? JSONDecoder().decode(DogImage.self, from: data) else {
                completon(nil, error)
                return
            }
            
            completon(dogImage, nil)
        }
        
        task.resume()
    }
    
    class func requestBreedsList(_ completion: @escaping ([String]?, Error?) -> Void) {
        let breedEndpoint = DogAPI.Endpoint.listAllBreeds.url
        
        let task = URLSession.shared.dataTask(with: breedEndpoint) { data, response, error in
            guard let data = data,
                  let breedsData = try? JSONDecoder().decode(BreedsList.self, from: data).message
            else {
                completion(nil, error)
                return
            }
            
            let breedsList = breedsData.map { $0.key }
            
            guard !breedsList.isEmpty else {
                completion(nil, error)
                return
            }
            completion(breedsList, nil)
        }
        
        task.resume()
    }
}
