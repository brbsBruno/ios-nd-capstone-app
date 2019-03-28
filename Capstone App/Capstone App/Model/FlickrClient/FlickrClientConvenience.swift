//
//  FlickrClientConvenience.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 27/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation

extension FlickrClient {
    
    // MARK: Convenience
    
    func searchPhotos(text: String, page: Int = 1, completion: @escaping (_ result: FlickrPhotos?, _ error: NSError?) -> Void) -> URLSessionDataTask? {
        
        let parameters: [String: Any] = [Constants.FlickrParameterKeys.APIKey : Constants.APIKey,
                                         Constants.FlickrParameterKeys.Method : Constants.Methods.search,
                                         Constants.FlickrParameterKeys.SafeSearch : Constants.FlickrParameterValues.UseSafeSearch,
                                         Constants.FlickrParameterKeys.Extras : Constants.FlickrParameterValues.MediumURL,
                                         Constants.FlickrParameterKeys.Format : Constants.FlickrParameterValues.ResponseFormat,
                                         Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback,
                                         Constants.FlickrParameterKeys.PerPage : Constants.FlickrParameterValues.PerPage,
                                         Constants.FlickrParameterKeys.Page : page,
                                         Constants.FlickrParameterKeys.Text:text]
        
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath
        components.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        let request = URLRequest(url: components.url!)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "searchPhotos", code: 1, userInfo: userInfo))
            }
            
            guard error == nil else {
                let errorMessage = NSLocalizedString("Request failed with error", comment: "")
                sendError(errorMessage)
                return
            }
            
            guard let data = data else {
                let errorMessage = NSLocalizedString("Request failed without response data", comment: "")
                sendError(errorMessage)
                return
            }
            
            let unexpectedErrorMessage = NSLocalizedString("Request failed with an unexpected error", comment: "")
            guard let response = response as? HTTPURLResponse, 200 ... 299 ~= response.statusCode else {
                sendError(unexpectedErrorMessage)
                return
            }
            
            struct FlickrPhotosResult: Decodable {
                var photos: FlickrPhotos
            }
            
            do {
                let decoder = JSONDecoder()
                let flickrPhotosResult = try decoder.decode(FlickrPhotosResult.self, from: data)
                completion(flickrPhotosResult.photos, nil)
                
            } catch {
                sendError(unexpectedErrorMessage)
            }
        }
        
        return task
    }
}

