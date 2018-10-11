//
//  UserListCell.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/6/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMViewModel
import UIKit

/// Represents a user list table view cell.
internal class UserListCell: UITableViewCell {
    
    /// The reuse identifier.
    static let identifier = "UserListCell"
    
    /// The profile picture image view.
    private let profilePictureImageView = UIImageView()
    
    /// The username label.
    private let usernameLabel = UILabel()
    
    /// KVO observations.
    private var observations = [NSKeyValueObservation]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none
        
        usernameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        usernameLabel.numberOfLines = 0
        profilePictureImageView.contentMode = .scaleAspectFill
        
        // simple way to do circular profile pics
        // comment for square profile pics
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.cornerRadius = 24
        
        profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(usernameLabel)
        
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configures autolayout constraints.
    private func configureConstraints() {
        profilePictureImageView.widthAnchor
            .constraint(equalToConstant: 48).isActive = true
        profilePictureImageView.heightAnchor
            .constraint(equalToConstant: 48).isActive = true
        profilePictureImageView.centerYAnchor
            .constraint(equalTo: contentView.centerYAnchor).isActive = true
        profilePictureImageView.leadingAnchor
            .constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        
        usernameLabel.leadingAnchor
            .constraint(equalTo: profilePictureImageView.trailingAnchor, constant: 16).isActive = true
        usernameLabel.topAnchor
            .constraint(equalTo: contentView.topAnchor).isActive = true
        usernameLabel.bottomAnchor
            .constraint(equalTo: contentView.bottomAnchor).isActive = true
        usernameLabel.trailingAnchor
            .constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    }
    
    /// Configures the cell for the specified view model.
    /// - Parameters:
    ///     - viewModel: The user view model.
    internal func configure(for viewModel: UserViewModel) {
        usernameLabel.text = viewModel.username
        usernameLabel.textColor = viewModel.colorTheme.primaryTextColor
        profilePictureImageView.setImage(from: viewModel.avatarURL, with: viewModel.imageCache)
    }

    /// Configures the cell for empty user information.
    internal func configureForEmptyCell() {
        usernameLabel.text = " "
        profilePictureImageView.image = nil
    }

    
}
