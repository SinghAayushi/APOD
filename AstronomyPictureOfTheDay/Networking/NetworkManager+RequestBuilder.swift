//
//  NetworkManager+RequestBuilder.swift - class to form Network requests
//  AstronomyPictureOfTheDay
//
//  Created by Aayushi Singh on 13/05/22.
//

import Foundation
extension NetworkManager {
    struct RequestBuilder {
        let apiRoot: String = "https://api.nasa.gov/"
    }
    
}

private extension NetworkManager.RequestBuilder {
    
    func requestTemplate(path: String, httpMethod: String) -> URLRequest {
        
      let url = URL(string: path)!
      
      var request = URLRequest(url: url)
      request.httpMethod = httpMethod
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("application/json", forHTTPHeaderField: "Accept")
      return request
    }
    
}
extension NetworkManager.RequestBuilder {
    func fetchPicOfTheDay() -> URLRequest {
      let raw = "\(apiRoot)planetary/apod?api_key=\(API_KEY)"
      let request = requestTemplate(path: raw, httpMethod: "GET")
      
      return request
    }

    
}
