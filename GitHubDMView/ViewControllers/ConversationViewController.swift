//
//  ConversationViewController.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/7/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMViewModel
import UIKit

/// The `ConversationDelegate` protocol is adopted by an object
/// that responds to conversation actions.
public protocol ConversationDelegate: class {
    
    /// Tells the delegate the user info button was touched.
    /// - Parameters:
    ///     - user: The user view model.
    func conversationUserInfoTouched(user: UserViewModel)
    
}

/// Represents the main view controller for a conversation.
/// `ConversationViewController` is a container view controller
/// that includes `MessageListViewController` and `MessageInputViewController`
/// as child view controllers.
public final class ConversationViewController: UIViewController {
    
    /// The delegate.
    public weak var delegate: ConversationDelegate?
    
    /// The message list view controller.
    private let messageListViewController: MessageListViewController
    
    /// The message input view controller.
    private let messageInputViewController: MessageInputViewController
    
    /// Message input bottom constraint.
    private var messageInputBottomConstraint: NSLayoutConstraint?
    
    /// Message input height constraint.
    private var messageInputHeightConstraint: NSLayoutConstraint?
    
    /// Message input height offset.
    private var messageInputHeightOffset: CGFloat = 0.0

    /// The view model.
    private let viewModel: ConversationViewModel
    
    /// Initializes a `ConversationViewController`.
    /// - Parameters:
    ///     - viewModel: The view model.
    /// - Returns:
    ///     The initialized `ConversationViewController`.
    public init(viewModel: ConversationViewModel) {
        self.viewModel = viewModel
        messageListViewController = MessageListViewController(viewModel: viewModel.messageList)
        messageInputViewController = MessageInputViewController(viewModel: viewModel.messageInputViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(white: 247.0 / 255.0, alpha: 1.0)
        navigationItem.title = viewModel.navigationTitle
        navigationItem.largeTitleDisplayMode = .never
        
        messageListViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController: messageListViewController)
        
        messageInputViewController.delegate = self
        messageInputViewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController: messageInputViewController)
        
        setupInfoButton()
        configureConstraints()
        observeKeyboardChanges()
        setupViewToDismissKeyboard()
        viewModel.loadMessages()
    }
    
    /// Performs setup of the info button.
    private func setupInfoButton() {
        let infoButton = UIButton(type: .infoLight)
        infoButton.addTarget(self, action: #selector(infoButtonTouched), for: .touchUpInside)
        let infoBarButtonItem = UIBarButtonItem(customView: infoButton)
        navigationItem.rightBarButtonItem = infoBarButtonItem
    }
    
    /// Performs setup to allow dismissing the keyboard when tapping outside of the
    /// message input view.
    private func setupViewToDismissKeyboard() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    /// Called when the view is tapped, dismisses the keyboard if the tap was outside of the
    /// message input view.
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else {
            return
        }
        
        let location = sender.location(in: view)
        
        // Dismiss keyboard if the view is tapped anywhere outside of the message input view
        if !messageInputViewController.view.frame.contains(location) {
            messageInputViewController.resignFirstResponder()
        }
    }
    
    /// Configures autolayout constraints.
    private func configureConstraints() {
        messageListViewController.view.topAnchor
            .constraint(equalTo: view.topAnchor).isActive = true
        messageListViewController.view.leadingAnchor
            .constraint(equalTo: view.leadingAnchor).isActive = true
        messageListViewController.view.trailingAnchor
            .constraint(equalTo: view.trailingAnchor).isActive = true
        messageListViewController.view.bottomAnchor
            .constraint(equalTo: messageInputViewController.view.topAnchor).isActive = true
        
        messageInputViewController.view.leadingAnchor
            .constraint(equalTo: view.leadingAnchor).isActive = true
        messageInputViewController.view.trailingAnchor
            .constraint(equalTo: view.trailingAnchor).isActive = true
        messageInputBottomConstraint = messageInputViewController.view.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
        messageInputBottomConstraint?.isActive = true
        messageInputHeightConstraint = messageInputViewController.view.heightAnchor
            .constraint(equalToConstant: 63)
        messageInputHeightConstraint?.isActive = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.safeAreaInsets.bottom > 0 && messageInputBottomConstraint?.constant == 0 {
            messageInputBottomConstraint?.constant = -view.safeAreaInsets.bottom
        }
    }
    
    /// Called when the info button is touched.
    /// Calls the delegate's `conversationUserInfoTouched`.
    @objc func infoButtonTouched() {
        delegate?.conversationUserInfoTouched(user: viewModel.user)
    }

}

extension ConversationViewController: KeyboardObserving {
    
    public func keyboardChanged(to height: CGFloat,
                                  with animationCurve: UIView.AnimationOptions,
                                  duration: TimeInterval) {
        /// Updates constraints to adjust for keyboard changes.
        
        var shouldScrollToBottom = false
        
        if height < 1.0 {
            messageInputBottomConstraint?.constant = -view.safeAreaInsets.bottom
        } else {
            shouldScrollToBottom = true
            messageInputBottomConstraint?.constant = -height
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: animationCurve, animations: {
            self.view.layoutIfNeeded()
        }, completion: { _ in
            if shouldScrollToBottom {
                self.messageListViewController.scrollToBottom()
            }
        })
    }
}

extension ConversationViewController: MessageInputViewDelegate {
    
    public func messageInputViewSizeDidChange(_ messageInputView: MessageInputView,
                                                _ heightDifference: CGFloat) {
        /// Updates constraints for changes in the message input view's text view.
        messageInputHeightConstraint?.constant += heightDifference
        view.layoutIfNeeded()
    }
    
    public func messageInputViewPostButtonTouched(_ messageInputView: MessageInputView,
                                                    _ text: String) {
        /// Sends a new message to the view model.
        viewModel.sendMessage(with: text)
    }
    
}
