//
//  Restaurant.swift
//  MealMemo
//
//  Created by Vincent Hunter on 2/25/25.
//

import Foundation

struct Restaurant: Hashable {
    enum Rating:String {
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
                case . bad: return "sad"
                case .terrible: return "angry"
            
            
            }
        }
    }
    var name = ""
    var type = ""
    var location = ""
    var phone = ""
    var description = ""
    var image = ""
    var isFavorite = false
    var rating: Rating?
    
    init(name: String, type: String, location: String, phone: String, description: String, image: String, isFavorite: Bool) {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.description = description
        self.image = image
        self.isFavorite = isFavorite
    }
    
    init()
    {
        self.init(name: "", type: "", location: "", phone: "", description: "", image: "", isFavorite: false)
    }
}
