//
//  PostManaged.swift
//  Posts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 16/03/22.
//

import Foundation

extension PostEntity {
    
    func mappedObject() -> Post {
        return Post(id: Int(self.id), userId: Int(self.userId), title: self.title ?? "Default title", body: self.body ?? "Default Body")
    }
}
