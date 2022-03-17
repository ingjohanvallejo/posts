//
//  PostViewController.swift
//  Posts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 15/03/22.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var posts: [Post] = [Post]()
    let refresh = UIRefreshControl()
    let dataProvider = LocalCoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        refresh.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        tableView.refreshControl?.tintColor = UIColor.white
        tableView.refreshControl = refresh
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell else {
            return UITableViewCell()
        }
        
        let post = posts[indexPath.row]
        cell.postViewController = self
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
        }
    }
}

extension PostViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postDetail" {
            if let indexPathSelected = tableView.indexPathsForSelectedRows?.last {
                let selectedPost = posts[indexPathSelected.row]
                let detailViewController = segue.destination as! PostDetailViewController
                detailViewController.post = selectedPost
            }
        }
    }
}

extension PostViewController {
    @objc func loadData() {
        LocalCoreData.shared.getPost { localPosts in
            if let tempPosts = localPosts {
                self.posts = tempPosts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("error")
            }
        } remotePosts: { remotePosts in
            if let tempPosts = remotePosts {
                self.posts = tempPosts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refresh.endRefreshing()
                }
            }
        }
    }
    
    func markAsfavorite(cell: UITableViewCell) {
        guard let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        
        dataProvider.markUnmarkFavorite(post: self.posts[indexPathTapped.row])
        tableView.reloadRows(at: [indexPathTapped], with: .fade)
    }
}
