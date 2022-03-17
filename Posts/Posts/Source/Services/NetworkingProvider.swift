//
//  NetworkingProvider.swift
//  ListPosts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 15/03/22.
//

import Foundation

class NetworkingProvider {
    static let shared = NetworkingProvider()
    
    func getPosts(success: @escaping (_ posts:[Post]?) -> (), failure: @escaping (_ error:Error?) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/posts"
        guard let url = URL(string: urlString) else { return }
    
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil  else {
                print("There was an error!")
                failure(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                var result = [Post]()
                
                for post in posts {
                    result.append(post)
                }
                
                success(result)
            } catch let error {
                print("There was an error finding the data!")
                failure(error)
            }
        }.resume()
    }
    
    func getUser(byId: Int, success: @escaping (_ user: User?) -> (), failure: @escaping (_ error:Error?) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/users/\(byId)"
        guard let url = URL(string: urlString) else { return }
    
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil  else {
                print("There was an error!")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                
                success(user)
            } catch let error {
                print("There was an error finding the data!")
                failure(error)
            }
        }.resume()
    }
    
    func getComments(byPost: Int, success: @escaping (_ comments:[Comment]?) -> (), failure: @escaping (_ error:Error?) -> ()) {
        let urlString = "https://jsonplaceholder.typicode.com/comments?postId=\(byPost)"
        guard let url = URL(string: urlString) else { return }
            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil  else {
                print("There was an error!")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let comments = try JSONDecoder().decode([Comment].self, from: data)
                var result = [Comment]()
                
                for comment in comments {
                    result.append(comment)
                }
                
                success(result)
            } catch let error {
                print("There was an error finding the data!")
                failure(error)
            }
        }.resume()
    }
}
