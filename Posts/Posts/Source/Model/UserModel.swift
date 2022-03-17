//
//  User.swift
//  ListPosts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 15/03/22.
//

import Foundation

struct User: Codable {
    let id: Int?
    let name: String?
    let email: String?
    let phone: String?
    
    init(id: Int?, name: String?, email: String?, phone: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}
