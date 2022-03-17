//
//  PostCell.swift
//  Posts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 15/03/22.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var titlePost: UILabel!
    @IBOutlet weak var bodyPost: UILabel!
    @IBOutlet weak var favoritePost: UIButton!
    let dataProvider = LocalCoreData()
    var postViewController: PostViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        favoritePost.addTarget(self, action: #selector(handleMarkAsFavorite), for: .touchUpInside)
    }
    
    @objc func handleMarkAsFavorite() {
        postViewController?.markAsfavorite(cell: self)
    }
}
