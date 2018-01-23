//
//  NetworkQueries.swift
//  Git-it
//
//  Created by Sayantan Chakraborty on 24/11/17.
//  Copyright © 2017 Sayantan Chakraborty. All rights reserved.
//

import Foundation

// Runs query data task, and stores results in array of Tracks
class NetworkQueries {
    
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([String:[Receipe]]?, String) -> ()
    
    var errorMessage = ""
    var receipes: [String:[Receipe]] = [:]
    
    let urlSession = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    
    ///fetches and forms the receipes in a data structure to be used in the view controller
    func fetchCookbook(completion: @escaping QueryResult) {
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://chefling.herokuapp.com/cookbook"){
            
            guard let url = urlComponents.url else {return}
            
            dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                defer {self.dataTask = nil}
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                }else if let data = data,let response = response as? HTTPURLResponse, response.statusCode == 200{
                    self.formReceipes(data)
                    
                    DispatchQueue.main.async {
                        completion(self.receipes, self.errorMessage)
                    }
                }
            })
            dataTask?.resume()
        }
    }
    
    ///Parses the fetched data to form the data model
    fileprivate func formReceipes(_ data: Data) {
        var response: [String:Any]?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let allData = response?["data"] as? [String:Any] else {
            errorMessage += "Response could not be parsed\n"
            return
        }
        
        for (key,value) in allData{
            var recpes: [Receipe] = []
            print(key,value)
            
            guard let val = value as? [String:Any] else {
                errorMessage += "Response could not be parsed\n"
                return
            }
            guard let recps = val["recipes"] as? [Any] else {
                errorMessage += "Response could not be parsed\n"
                return
            }
            
            for item in recps{
                
                guard let it = item as? [String:Any] else{
                    errorMessage += "Response could not be parsed\n"
                    return
                }
                let rName = it["recipename"] as? String
                let rPhoto = it["recipephoto"] as? String
                let rid = it["rid"] as? Int
                let rType = it["recipetype"] as? Int
                
                let receipe = Receipe(recipename: rName, recipephoto: rPhoto, rid: rid, recipetype: rType, category: key)
                recpes.append(receipe)
            }
            self.receipes[key] = recpes
        }
        
    }
    
    
}
