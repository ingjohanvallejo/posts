//
//  PostDetailViewController.swift
//  Posts
//
//  Created by Johan Felipe Vallejo Saldarriaga on 16/03/22.
//

import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet private weak var titleDetail: UILabel!
    @IBOutlet private weak var bodyDetail: UILabel!
    @IBOutlet private weak var nameAuthor: UILabel!
    @IBOutlet private weak var emailAuthor: UILabel!
    @IBOutlet private weak var phoneAuthor: UILabel!
    @IBOutlet private weak var detailTableView: UITableView!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    var post: Post?
    var comments: [Comment] = [Comment]()
    let dataProvider = LocalCoreData()
    let remoteService = NetworkingProvider.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let post = post {
            titleDetail.text = post.title
            bodyDetail.text = post.body
            configureTableView()
            loadUserInformation()
            loadCommentInformation()
            configureFavorieButton()
        }
    }
    
    private func configureTableView() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    @IBAction func favoritePressed(_ sender: UIBarButtonItem) {
        if let post = self.post {
            dataProvider.markUnmarkFavorite(post: post)
            configureFavorieButton()
        }
    }
}

extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell else {
            return UITableViewCell()
        }
        
        let comment = comments[indexPath.row]
        self.configureCell(cell, withComment: comment)
        
        return cell
    }
    
    func configureCell(_ cell: CommentCell, withComment comment: Comment) {
        cell.titleComment.text = comment.name
        cell.bodyComment.text = comment.body
    }
}

extension PostDetailViewController {
    func configureFavorieButton() {
        if let post = self.post {
            if dataProvider.isPostFavorite(post: post) {
                rightBarButton.image = UIImage(systemName: "star.fill")
            } else {
                rightBarButton.image = UIImage(systemName: "star")
            }
        }
    }
}

extension PostDetailViewController {
    func loadUserInformation() {
        guard let userId = post?.userId else { return }
        
        remoteService.getUser(byId: userId) { user in
            guard let user = user else { return }
            DispatchQueue.main.async {
                self.nameAuthor.text = user.name
                self.emailAuthor.text = user.email
                self.phoneAuthor.text = user.phone
            }
        } failure: { error in
            print(error ?? "error")
        }

    }
    
    func loadCommentInformation() {
        guard let postId = post?.id else { return }
        
        remoteService.getComments(byPost: postId) { remoteComments in
            guard let remoteComments = remoteComments else { return }
            
            self.comments = remoteComments
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
            }
            
        } failure: { error in
            print(error ?? "error")
        }

    }
}
