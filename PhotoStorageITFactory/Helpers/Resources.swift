
import Foundation
import UIKit

enum Resources {
    
    enum Url{
        static let urlJson = "https://jsonplaceholder.typicode.com/photos"
    }
    
    enum Errors {
        static let errorFetch = "Error fetching data:"
        static let errorDecod = "Error decoding data:"
        static let errorLoad = "Error loading image:"
    }
    
    enum KeyUserDefaults {
        static let favoritePhotoIDs = "favoritePhotoIDs"
    }
    
}