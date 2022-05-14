//
//  APODDataModel.swift
//  AstronomyPictureOfTheDay
//
//  Created by Aayushi Singh on 13/05/22.
//

import Foundation
struct APODDataModel: Decodable {
    let date, explanation: String
       let hdurl: String
       let mediaType, serviceVersion, title: String
       let url: String

       enum CodingKeys: String, CodingKey {
           case date, explanation, hdurl
           case mediaType = "media_type"
           case serviceVersion = "service_version"
           case title, url
       }
}
