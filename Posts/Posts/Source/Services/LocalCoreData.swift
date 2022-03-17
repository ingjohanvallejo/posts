//
//  LocalCoreData.swift
//  
//
//  Created by Johan Vallejo on 15/03/22.
//  Copyright © 2021 Johan Vallejo. All rights reserved.
//

import Foundation
import CoreData

class LocalCoreData {
    
    static let shared = LocalCoreData()
    let remoteService = NetworkingProvider.shared
    let stack = CoreDataStack.shared
    
    func getPost(localPosts: ([Post]?) -> (), remotePosts : @escaping ([Post]?) -> ()) {
        localPosts(self.queryPosts())
        
        remoteService.getPosts(success: { posts in
            if let posts = posts {
                //self.markAllPostAsUnsync()
                for postDictionary in posts {
                    if let post = self.getPostById(id: postDictionary.id, favorite: false){
                        self.updatePost(postDictionary: postDictionary, post: post)
                    } else {
                        self.insertPost(postDictionary: postDictionary)
                    }
                    
                    remotePosts(self.queryPosts())
                }
            }
        }) { error in
            print(error.debugDescription)
        }
    }
    
    func queryPosts() -> [Post]? {
        let context =  stack.persistentContainer.viewContext
        let request : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(false)")
        request.predicate = predicate
        
        do {
            let fetchedPosts = try context.fetch(request)
            var posts = [Post]()
            for managedPost in fetchedPosts {
                posts.append(managedPost.mappedObject())
            }
            return  posts
        } catch {
            print("error while getting posts from Core Data")
            return nil
        }
        
    }
    
//    func markAllPostAsUnsync() {
//        let context =  stack.persistentContainer.viewContext
//        let request : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
//
//        do {
//            let fetchedPosts = try context.fetch(request)
//            for managedPost in fetchedPosts {
//                managedPost.sync = false
//            }
//            try context.save()
//
//        } catch {
//            print("error while updating posts from Core Data")
//        }
//    }
    
    func getPostById(id: Int, favorite: Bool) -> PostEntity?{
        let context =  stack.persistentContainer.viewContext
        let request : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        let predicate = NSPredicate(format: "id= \(id) and favorite=\(favorite)")
        
        request.predicate = predicate
        
        do {
            let fetchedPosts = try context.fetch(request)
            if fetchedPosts.count > 0 {
                return fetchedPosts.last
            } else {
                return nil
            }
        } catch {
            print("error while getting posts from Core Data")
            return nil
        }
    }
    
    func insertPost(postDictionary: Post) {
        let context =  stack.persistentContainer.viewContext
        let post = PostEntity(context: context)
        
        post.id = Int32(postDictionary.id)
        updatePost(postDictionary: postDictionary, post: post)
    }
    
    func updatePost(postDictionary: Post, post: PostEntity) {
        let context =  stack.persistentContainer.viewContext
        post.title = postDictionary.title
        post.body = postDictionary.body
        post.userId = Int32(postDictionary.userId)
        post.sync = true
        
        do{
            try context.save()
        } catch {
            print("Error while updating Core Data")
        }
    }
    
    func getFavoritePost() -> [Post]? {
        let context =  stack.persistentContainer.viewContext
        let request : NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        
        let predicate = NSPredicate(format: "favorite = \(true)")
        request.predicate = predicate
        
        do{
            let fetchedPosts = try context.fetch(request)
            var posts = [Post]()
            
            for managedPost in fetchedPosts {
                posts.append(managedPost.mappedObject())
            }
            
            return posts
        } catch {
            print("Error while getting Favorites")
            return nil
        }
    }
    
    func isPostFavorite(post: Post) -> Bool {
        if let _ = getPostById(id: post.id, favorite: true) {
            return true
        }
        
        return false
    }
    
    func markUnmarkFavorite(post: Post) {
        let context =  stack.persistentContainer.viewContext
        
        if let exist = getPostById(id: post.id, favorite: true) {
            context.delete(exist)
        } else {
            let favorite = PostEntity(context: context)
            favorite.userId = Int32(post.userId)
            favorite.id = Int32(post.id)
            favorite.title = post.title
            favorite.body = post.body
            favorite.favorite = true
        }
        
        do {
            try context.save()
        } catch {
            print("Error while marking as Favorites")
        }
    }
}
