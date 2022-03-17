//
//  Comment.swift
//  ListPosts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 15/03/22.
//

import Foundation

struct Comment: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let body: String?
    
    init(id: Int?, name: String?, email: String?, body: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
