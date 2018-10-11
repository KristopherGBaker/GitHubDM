//
//  MessageInputView.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import UIKit

public protocol MessageInputViewDelegate: class {
    
    func messageInputViewSizeDidChange(_ messageInputView: MessageInputView, _ heightDifference: CGFloat)
    
    func messageInputViewPostButtonTouched(_ messageInputView: MessageInputView, _ text: String)
    
}

/// Represents the message input view (text entry and post button).
public class MessageInputView: UIView {
    
    /// The delegate.
    public weak var delegate: MessageInputViewDelegate?
    
    private let textView = UITextView()
    private let postButton = UIButton()
    private var textHeightConstraint: NSLayoutConstraint?
    
    public var postTitle: String = "" {
        didSet {
            updatePostTitle()
        }
    }
    
    public var postTitleColor: UIColor = .blue {
        didSet {
            updatePostTitle()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        
        postButton.addTarget(self, action: #selector(postButtonTouched), for: .touchUpInside)
        postButton.isEnabled = false
        
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor(white: 218.0 / 255.0, alpha: 1.0).cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 18.5
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.clipsToBounds = true
        textView.accessibilityIdentifier = "MessageInput"
        textView.isEditable = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        postButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        addSubview(postButton)
        
        configureConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePostTitle() {
        let postAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: postTitleColor,
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ]
        let postAttributed = NSAttributedString(string: postTitle,
                                                attributes: postAttributes)
        
        let postAttributesHighlighted: [NSAttributedString.Key: Any] = [
            .foregroundColor: postTitleColor.withAlphaComponent(0.7),
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ]
        let postAttributedHighlighted = NSAttributedString(string: postTitle,
                                                           attributes: postAttributesHighlighted)
        
        let postAttributesDisabled: [NSAttributedString.Key: Any] = [
            .foregroundColor: postTitleColor.withAlphaComponent(0.3),
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ]
        let postAttributedDisabled = NSAttributedString(string: postTitle,
                                                        attributes: postAttributesDisabled)
        
        postButton.setAttributedTitle(postAttributed, for: .normal)
        postButton.setAttributedTitle(postAttributedHighlighted, for: .highlighted)
        postButton.setAttributedTitle(postAttributedDisabled, for: .disabled)
    }
    
    @objc public func postButtonTouched() {
        let text = textView.text ?? ""
        textView.text = ""
        delegate?.messageInputViewPostButtonTouched(self, text)
        textViewDidChange(textView)
    }
    
    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textView.becomeFirstResponder()
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textView.resignFirstResponder()
    }
    
    private func configureConstraints() {
        textView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor, constant: 15)
            .isActive = true
        textView
            .topAnchor
            .constraint(equalTo: topAnchor, constant: 13)
            .isActive = true
        textHeightConstraint = textView
            .heightAnchor
            .constraint(equalToConstant: 37)
        textHeightConstraint?.isActive = true
        textView
            .trailingAnchor
            .constraint(equalTo: postButton.leadingAnchor)
            .isActive = true
        
        postButton
            .trailingAnchor
            .constraint(equalTo: trailingAnchor, constant: -15)
            .isActive = true
        postButton
            .heightAnchor
            .constraint(equalToConstant: 45)
            .isActive = true
        postButton
            .widthAnchor
            .constraint(equalToConstant: 55)
            .isActive = true
        postButton
            .centerYAnchor
            .constraint(equalTo: textView.centerYAnchor)
            .isActive = true
    }
    
}

extension MessageInputView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        postButton.isEnabled = textView.text != nil && !textView.text!.isEmpty
        
        let width = textView.frame.width
        let originalHeight = textView.frame.height
        let updatedHeight = max(37, textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height)
        
        guard abs(originalHeight - updatedHeight) > 0.1 else {
            return
        }
        
        textHeightConstraint?.constant = updatedHeight
        layoutIfNeeded()
        delegate?.messageInputViewSizeDidChange(self, updatedHeight - originalHeight)
    }
}
