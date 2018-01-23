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
    typealias QueryResult = (GitHubUser?, String) -> ()
    typealias QueryResultRepos = ([GitUserRepos]?,String)-> ()
    
    var user: GitHubUser?
    var errorMessage = ""
    var repos: [GitUserRepos] = []
    
    let urlSession = URLSession(configuration: .default)
    var dataTask:URLSessionDataTask?
    
    ///fetches git user over the network. using URLSession
    func fetchGithubUser(searchTerm: String, completion: @escaping QueryResult) {
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://api.github.com/users/\(searchTerm)"){
            //urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else {return}
            
            dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                defer {self.dataTask = nil}
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                }else if let data = data,let response = response as? HTTPURLResponse, response.statusCode == 200{
                    self.updateSearchResults(data)
                    
                    DispatchQueue.main.async {
                        completion(self.user, self.errorMessage)
                    }
                }else{
                    completion(nil,"No user found")
                }
            })
            dataTask?.resume()
        }else{
            completion(nil,"No user")
        }
    }
    
    ///Parses the pulled data to form a Git user
    fileprivate func updateSearchResults(_ data: Data) {
        var response: [String:Any]?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let data = response,data.count>0 else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        
        let name = data["name"] as? String
        let login = data["login"] as? String
        let location = data["location"] as? String
        let followers_url = data["followers_url"] as? String
        let avatar_url = data["avatar_url"] as? String
        let public_repos = data["public_repos"] as? Int
        let public_gists = data["public_gists"] as? Int
        let followers = data["followers"] as? Int
        let updated_at = data["updated_at"] as? String
        
        user = GitHubUser(name: name, login: login, location: location, followers_url: followers_url, avatar_url: avatar_url, public_repos: public_repos, public_gists: public_gists, followers: followers, updated_at: updated_at)
    }
    
    func fetchGithubUserRepos(searchTerm: String, completion: @escaping QueryResultRepos) {
        
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://api.github.com/users/\(searchTerm)/repos"){
            //urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            
            guard let url = urlComponents.url else {return}
            
            dataTask = urlSession.dataTask(with: url, completionHandler: { (data, response, error) in
                defer {self.dataTask = nil}
                
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                }else if let data = data,let response = response as? HTTPURLResponse, response.statusCode == 200{
                    self.formGitUserRepos(data)
                    
                    DispatchQueue.main.async {
                        completion(self.repos, self.errorMessage)
                    }
                }
            })
            dataTask?.resume()
        }
    }
    
    fileprivate func formGitUserRepos(_ data: Data) {
        var response: [Any]?
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let allData = response else {
            errorMessage += "Response could not be parsed\n"
            return
        }
        
        for item in allData{
            if let dict = item as? [String:Any]{
                let name = dict["name"] as? String
                let description = dict["login"] as? String
                let language = dict["language"] as? String
                
                let repo = GitUserRepos(name: name, description: description, language: language)
                self.repos.append(repo)
            }
        }
        
        
        //user = GitHubUser(name: name, login: login, location: location, followers_url: followers_url, avatar_url: avatar_url, public_repos: public_repos, public_gists: public_gists, followers: followers, updated_at: updated_at)
    }
    
    
}
