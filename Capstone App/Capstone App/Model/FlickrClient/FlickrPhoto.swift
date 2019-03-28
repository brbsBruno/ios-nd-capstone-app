//
//  FlickrPhoto.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 27/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

class FlickrPhoto: Decodable {
    
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url_m"
    }
    
}
