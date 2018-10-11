//
//  MessageCell.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMViewModel
import UIKit

/// Represents a chat message table view cell.
/// This includes both the chat bubble background and the message text.
internal class MessageCell: UITableViewCell {

    /// The reuse identifier.
    internal static let identifier = "MessageCell"
    
    /// The chat bubble background image view.
    private let bubbleImageView = UIImageView()
    
    /// The text view.
    private let messageTextView = UITextView()
    
    /// Right bubble (messages sent by the current user of the app) leading constraint.
    private var rightBubbleLeadingConstraint: NSLayoutConstraint?
    
    /// Right bubble (messages sent by the current user of the app) trailing constraint.
    private var rightBubbleTrailingConstraint: NSLayoutConstraint?
    
    /// Left bubble (messages sent by the other user) leading constraint.
    private var leftBubbleLeadingConstraint: NSLayoutConstraint?
    
    /// Left bubble (messages sent by the other user) trailing constraint.
    private var leftBubbleTrailingConstraint: NSLayoutConstraint?
    
    internal override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        messageTextView.isEditable = false
        messageTextView.isScrollEnabled = false
        messageTextView.backgroundColor = .clear
        messageTextView.font = UIFont.preferredFont(forTextStyle: .body)
        messageTextView.textColor = .white
        
        bubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bubbleImageView)
        contentView.addSubview(messageTextView)
        
        configureConstraints()
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Configures autolayout constraints.
    private func configureConstraints() {
        rightBubbleLeadingConstraint = bubbleImageView.leadingAnchor
            .constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 50)
        
        rightBubbleTrailingConstraint = bubbleImageView.trailingAnchor
            .constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        
        leftBubbleLeadingConstraint = bubbleImageView.leadingAnchor
            .constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        
        leftBubbleTrailingConstraint = bubbleImageView.trailingAnchor
            .constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -50)
        
        bubbleImageView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: 45).isActive = true
        bubbleImageView.topAnchor
            .constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
        bubbleImageView.bottomAnchor
            .constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
        
        messageTextView.topAnchor
            .constraint(equalTo: bubbleImageView.topAnchor, constant: 11).isActive = true
        messageTextView.leadingAnchor
            .constraint(equalTo: bubbleImageView.leadingAnchor, constant: 22).isActive = true
        messageTextView.bottomAnchor
            .constraint(equalTo: bubbleImageView.bottomAnchor, constant: -11).isActive = true
        messageTextView.trailingAnchor
            .constraint(equalTo: bubbleImageView.trailingAnchor, constant: -22).isActive = true
        messageTextView.heightAnchor
            .constraint(greaterThanOrEqualToConstant: 25).isActive = true
    }

    /// Configures the cell for the specified view model.
    /// - Parameters:
    ///     - viewModel: The message view model.
    internal func configure(for viewModel: MessageViewModel) {
        updateBubble(viewModel)
        messageTextView.text = viewModel.text
        messageTextView.textColor = viewModel.colorTheme.messageTextColor
    }
    
    /// Updates the chat bubble for the specified message type.
    /// - Parameters:
    ///     - messageType: The message type (sent / received).
    private func updateBubble(_ viewModel: MessageViewModel) {
        let image: UIImage?
        if viewModel.messageType == .received {
            image = UIImage(named: "left_bubble")
        } else {
            image = UIImage(named: "right_bubble")
        }
        bubbleImageView.image = image?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 16, left: 21, bottom: 16, right: 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        
        if viewModel.messageType == .received {
            rightBubbleLeadingConstraint?.isActive = false
            rightBubbleTrailingConstraint?.isActive = false
            leftBubbleLeadingConstraint?.isActive = true
            leftBubbleTrailingConstraint?.isActive = true
            bubbleImageView.tintColor = viewModel.colorTheme.leftBubbleBackgroundColor
        } else {
            leftBubbleLeadingConstraint?.isActive = false
            leftBubbleTrailingConstraint?.isActive = false
            rightBubbleLeadingConstraint?.isActive = true
            rightBubbleTrailingConstraint?.isActive = true
            bubbleImageView.tintColor = viewModel.colorTheme.rightBubbleBackgroundColor
        }
        
        setNeedsUpdateConstraints()
    }
    
}
