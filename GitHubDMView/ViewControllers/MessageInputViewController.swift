//
//  MessageInputViewController.swift
//  GitHubDMView
//
//  Created by Kris Baker on 9/9/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMViewModel
import UIKit

/// Encapsulates a `MessageInputView` in a view controller.
public class MessageInputViewController: UIViewController {
    
    /// The message input view.
    private let messageInputView = MessageInputView(frame: .zero)
    
    /// The view model.
    private let viewModel: MessageInputViewModel
    
    /// Proxy for the message input view's delegate.
    public weak var delegate: MessageInputViewDelegate? {
        get {
            return messageInputView.delegate
        }
        set {
            messageInputView.delegate = newValue
        }
    }
    
    /// Initializes a `MessageInputViewController`.
    /// - Parameters:
    ///     - viewModel: The view model.
    /// - Returns:
    ///     The initialized `MessageInputViewController`.
    public init(viewModel: MessageInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = messageInputView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        messageInputView.postTitle = viewModel.postTitle
        messageInputView.postTitleColor = viewModel.colorTheme.postTitleColor
    }
    
    @discardableResult
    public override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return messageInputView.resignFirstResponder()
    }
    
}
