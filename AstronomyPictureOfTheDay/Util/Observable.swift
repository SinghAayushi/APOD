//
//  Observable.swift - Simple observable class
//  AstronomyPictureOfTheDay
//
//  Created by Aayushi Singh on 13/05/22.
//

import Foundation
public final class Observable<T> {
    var value: T? {
        didSet {
            listener?(value)
        }
    }
    
    var listener: ((T?) -> Void)?
    
    init(_ value:T?) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T?) -> Void) {
        self.listener = listener
    }
    
}
