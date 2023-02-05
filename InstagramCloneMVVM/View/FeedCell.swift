//
//  FeedCell.swift
//  InstagramCloneMVVM
//
//  Created by M. Can Devecioğlu on 20.11.2022.
//

import UIKit

protocol FeedCellDelegate: class {
    func cell(_ cell: FeedCell, wantsToCommentsFor post: Post)
    func cell(_ cell: FeedCell, didLike post: Post)
    func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String)
}

class FeedCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: PostViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: FeedCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    private lazy var postImageView: UIImageView = {
        let iv = UIImageView()
         iv.contentMode = .scaleAspectFill
         iv.clipsToBounds = true
         iv.isUserInteractionEnabled = true
        
         return iv
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapComments), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likesLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let postTimeLabel: UILabel = {
       let label = UILabel()
        label.text = "2 days ago"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        addSubview(usernameButton)
        usernameButton.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        
        addSubview(postImageView)
        postImageView.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8)
        
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        configureActionButtons()
        
        addSubview(likesLabel)
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: safeAreaLayoutGuide.leftAnchor, right: safeAreaLayoutGuide.rightAnchor, paddingTop: 8, paddingLeft: 8)
        
        addSubview(postTimeLabel)
        postTimeLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func didTapLike() {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, didLike: viewModel.post)
    }
    
    @objc func showUserProfile () {
        guard let viewModel = viewModel else { return }
        delegate.self?.cell(self, wantsToShowProfileFor: viewModel.post.ownerUID)
    }
    
    @objc func didTapComments () {
        
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, wantsToCommentsFor: viewModel.post)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        captionLabel.text = viewModel.caption
        postImageView.sd_setImage(with: viewModel.imageURL)
        profileImageView.sd_setImage(with: viewModel.userProfileImageURL)
        usernameButton.setTitle(viewModel.username, for: .normal)
        
        likesLabel.text = viewModel.likesLabelText
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    }
    
    func configureActionButtons () {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, shareButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
    
    
}
