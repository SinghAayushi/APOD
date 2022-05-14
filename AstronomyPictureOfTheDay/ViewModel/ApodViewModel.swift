//
//  DefaultApodViewModel.swift - the class is responsible for view model and api call initialization for apod
//  AstronomyPictureOfTheDay
//
//  Created by Aayushi Singh on 13/05/22.
//

import Foundation
import UIKit

//Wrapper class for NSCache as struct can't be stored directly
class ApodDataForCaching {
    var data : ApodViewModel
    init(data : ApodViewModel) {
        self.data = data
    }
}

//ViewModel struct, acts as an output viewmodel
struct ApodViewModel {
    let image: UIImage
    let title: String
    let description: String
    let date: String
}

class DefaultApodViewModel  {
    //Caching of data
    private var downloadedData = NSCache<NSString, AnyObject>()
    
    let apodObservableData : Observable<ApodViewModel> = Observable(nil)
    var apodImageUrl: String
    var title: String
    var description : String
    var date: String
    
    init (data: APODDataModel?) {
        self.apodImageUrl = data?.hdurl ?? ""
        self.title = data?.title ?? ""
        self.description = data?.explanation ?? ""
        self.date = data?.date ?? ""
    }
}

extension DefaultApodViewModel {
    //API caller function for apod (astronomy pic of the day)
    func fetchApodData(requestedDate: String, errorHandler : @escaping (Error?)->()) {
        
        //Checks if the data is already cached for the today's date then fetches the data from the cache
        if let cachedData = downloadedData.object(forKey: requestedDate  as NSString) as? ApodDataForCaching {
            self.apodObservableData.value = cachedData.data
            
            return
        }

        //APOD network call
        let networkManager = NetworkManager()
        networkManager.fetchPictureOfTheDay() { [weak self] data, error in
            guard let data = data, error == nil else {
                errorHandler(error)
                return
            }
            
            self?.apodImageUrl = data.hdurl
            self?.description = data.explanation
            self?.title = data.title
            self?.date = data.date
            
            //Image download call
            networkManager.image(apod: data) { [weak self] data, error in
                guard let imageData = data, error == nil else {
                    return
                }
                
                //sending data to the view model, which is bound in the view controller
                self?.apodObservableData.value = ApodViewModel(image: (self?.image(data: imageData)!)!, title: self?.title ?? "", description: self?.description ?? "", date: (self?.date) ?? "")
                self?.cacheData()
            }
        }
    }
    /*
     * cacheData() - caches the data in NSCache
     */
    func cacheData() {
        self.downloadedData.removeAllObjects()
        let apodData = ApodDataForCaching(data: self.apodObservableData.value!)
        self.downloadedData.setObject(apodData, forKey: self.date as NSString)
    }
    
    /*
     * image() - UIImage convertor
     */
    func image(data: Data?) -> UIImage? {
      if let data = data {
        return UIImage(data: data)
      }
      return UIImage(systemName: "picture")
    }
    
    /*
     * currDate() -> String
     * returns today's date, useful in comparing cached data
     */
    func currDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date.now)
        
    }
    
}


