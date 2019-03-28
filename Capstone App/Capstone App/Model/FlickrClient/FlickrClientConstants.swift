//
//  FlickrClientConstants.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 27/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let APIKey = "f6319c7cd86d79e873a0498b17b8345b"
        
        // MARK: URLs
        static let APIScheme = "https"
        static let APIHost = "api.flickr.com"
        static let APIPath = "/services/rest"
        
        // MARK: Flickr Parameter Keys
        
        struct FlickrParameterKeys {
            static let Method = "method"
            static let APIKey = "api_key"
            static let Format = "format"
            static let Extras = "extras"
            static let NoJSONCallback = "nojsoncallback"
            static let SafeSearch = "safe_search"
            static let Text = "text"
            static let BoundingBox = "bbox"
            static let Page = "page"
            static let PerPage = "per_page"
        }
        
        // MARK: Flickr Parameter Values
        struct FlickrParameterValues {
            static let ResponseFormat = "json"
            static let DisableJSONCallback = "1"
            static let MediumURL = "url_m"
            static let UseSafeSearch = "1"
            static let PerPage = "21"
        }
        
        // MARK: Methods
        struct Methods {
            
            // MARK: Search
            static let search = "flickr.photos.search"
        }
    }
}

