//
//  CommentController.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 31.01.2023.
//

import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let post: Post
    private var comments = [Comment]()
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        
        return cv
    }()
    
    // MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchComments() {
        CommentService.fetchComment(forPost: post.postID) { comments in
            self.comments = comments
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = "Comments"
        collectionView.backgroundColor = .white
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CommentCell
        cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = CommentViewModel(comment: comments[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        
        return CGSize(width: view.frame.width, height: height)
    }
    
}

// MARK: - UICollectionViewDataSource

extension CommentController {
    
}

// MARK: - CommentInputAccesoryViewDelegate

extension CommentController: CommentInputAccesoryViewDelegate {
   
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        
        if comment.isEmpty {
            alertMessage(title: "", message: "You can not send empty comment. I pay each of your comment queries :(")
        } else {
            guard let tab = self.tabBarController as? MainTabController else { return }
            guard let user = tab.user else { return }
            self.showLoader(true)
            CommentService.uploadComment(comment: comment, postID: post.postID, user: user) { error in
                self.showLoader(false)
                inputView.clearCommentTextView()
            }
            
        }
    }
}

// MARK: - UICollectionViewDelegate

extension CommentController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid = comments[indexPath.row].uid
        UserService.fetchUser(withUID: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

// MARK: - Alert Message Func

extension CommentController {
    
    func alertMessage (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
         let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in }
             alert.addAction(okButton)
             self.present(alert, animated: true)
    }
    
}
