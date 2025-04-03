//
//  Restaurant.swift
//  MealMemo
//
//  Created by Vincent Hunter on 2/25/25.
//

import Foundation
import UIKit
import SwiftData

// Swift Data Implementation of Reataurant Model

//Changed the struct into a model class, annotated with the @Model marcro
@Model class Restaurant {
    
    // Has become computed property
    enum Rating: String, CaseIterable {
        case awesome
        case good
        case okay
        case bad
        case terrible
        
        var image: String {
            switch self {
            case .awesome: return "love"
            case .good: return "cool"
            case .okay: return "happy"
            case .bad: return "sad"
            case .terrible: return "angry"
                
            }
        }
    }
    
    var name : String = ""
    var type: String = ""
    var location: String = ""
    var phone: String = ""
    var summary: String = ""
    
    //Converts original image property to imageData property. Instructs SwiftData to store the property in a different file from the database file
    @Attribute(.externalStorage) var imageData = Data()
    
    @Transient var image: UIImage {
        get {
            UIImage(data: imageData) ?? UIImage()
        }
        
        set {
            self.imageData = newValue.pngData() ?? Data()
        }
    }
    
    var isFavorite: Bool = false
    
    @Transient var rating: Rating? {
        get {
            guard let ratingText = ratingText else { return nil }
            
            return Rating(rawValue: ratingText)
        }
        
        set {
            self.ratingText = newValue?.rawValue
        }
    }
    
    @Attribute(originalName: "rating") var ratingText: Rating.RawValue?

    init(name: String = "", type: String = "", location: String = "", phone: String = "", description: String = "", image: UIImage = UIImage(), isFavorite: Bool = false, rating: Rating? = nil) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.summary = description
        self.image = image
        self.isFavorite = isFavorite
        self.rating = rating
        
        }
    
    
}




