//
//  PostModel.swift
//  Posts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 15/03/22.
//

import Foundation

struct Post: Decodable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
    
    enum CodingKeys: String, CodingKey {
        case id, userId, title, body
    }
}
