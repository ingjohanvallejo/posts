//
//  FavoritesPostViewController.swift
//  Posts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 16/03/22.
//

import UIKit

class FavoritesPostViewController: UIViewController {
    
    @IBOutlet private weak var favoriteTableView: UITableView!
    @IBOutlet private weak var unmaskFavoritePost: UIBarButtonItem!
    
    var posts: [Post] = [Post]()
    let dataProvider = LocalCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        unmaskFavoritePost.target = self
        unmaskFavoritePost.action = #selector(unmaskFavoriteAllPost)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func configureTableView() {
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
    }
}

extension FavoritesPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count > 0 {
            self.favoriteTableView.backgroundColor = nil
        } else {
            self.favoriteTableView.backgroundColor = .green
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favoriteTableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        self.configureCell(cell, withPost: post)
        return cell
    }
    
    func configureCell(_ cell: PostCell, withPost post: Post) {
        cell.titlePost.text = post.title
        cell.bodyPost.text = post.body
        
        if dataProvider.isPostFavorite(post: post) {
            cell.favoritePost.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            cell.favoritePost.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteTableView.reloadData()
        }
    }
}

extension FavoritesPostViewController {
    func loadData() {
        if let posts = dataProvider.getFavoritePost() {
            self.posts = posts
            self.favoriteTableView.reloadData()
        }
    }
    
    @objc func unmaskFavoriteAllPost() {
        dataProvider.markAllPostAsUnfavorites()
        favoriteTableView.reloadData()
    }
}

extension FavoritesPostViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetail" {
            if let indexPathSelected = favoriteTableView.indexPathsForSelectedRows?.last {
                let selectedPost = posts[indexPathSelected.row]
                let detailViewController = segue.destination as! PostDetailViewController
                detailViewController.post = selectedPost
            }
        }
    }
}
