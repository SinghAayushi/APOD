//
//  NetworkManager.swift - This class is responsible for Network calls
//  AstronomyPictureOfTheDay
//
//  Created by Aayushi Singh on 13/05/22.
//

import Foundation
enum NetworkManagerError: Error {
  case badResponse(URLResponse?)
  case badData
  case badLocalUrl
}


class NetworkManager {
    
    private var downloadedData = NSCache<NSString, NSData>()
    init() {}
    func fetchPictureOfTheDay(completion: @escaping (APODDataModel?, Error?) -> (Void)) {
        
        let session = URLSession.shared
        let request = NetworkManager.RequestBuilder()
        let req = request.fetchPicOfTheDay()
      
      let task = session.dataTask(with: req) { data, response, error in
        if let error = error {
          completion(nil, error)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          completion(nil, NetworkManagerError.badResponse(response))
          return
        }
        
        guard let data = data else {
          completion(nil, NetworkManagerError.badData)
          return
        }
        
        do {
          let response = try JSONDecoder().decode(APODDataModel.self, from: data)
            completion(response, nil)
        } catch let error {
          completion(nil, error)
        }
      }
      
      task.resume()
    }
    
    
    
    private func download(imageURL: URL, completion: @escaping (Data?, Error?) -> (Void)) {

      let session = URLSession.shared
      let task = session.downloadTask(with: imageURL) { localUrl, response, error in
        if let error = error {
          completion(nil, error)
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
          completion(nil, NetworkManagerError.badResponse(response))
          return
        }
        
        guard let localUrl = localUrl else {
          completion(nil, NetworkManagerError.badLocalUrl)
          return
        }
        
        do {
          let data = try Data(contentsOf: localUrl)
          completion(data, nil)
        } catch let error {
          completion(nil, error)
        }
      }
      
      task.resume()
    }
    
    func image(apod: APODDataModel, completion: @escaping (Data?, Error?) -> (Void)) {
      let url = URL(string: apod.hdurl)!
      download(imageURL: url, completion: completion)
    }
}
