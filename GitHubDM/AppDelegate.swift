//
//  AppDelegate.swift
//  GitHubDM
//
//  Created by Kris Baker on 9/5/18.
//  Copyright © 2018 Kristopher Baker. All rights reserved.
//

import GitHubDMModel
import GitHubDMView
import GitHubDMViewModel
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var coordinator: Coordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        #if MOCK
        let client: APIClient = MockAPIClient()
        #else
        let client: APIClient = GitHubAPIClient(network: Network())
        #endif
        
        let imageCacheNetwork = Network(configuration: SimpleImageCache.defaultSessionConfiguration)
        let imageCache = SimpleImageCache(network: imageCacheNetwork)
        let persistence: Persisting = Persistence()
        let theme: ColorTheme = LightTheme()
        
        coordinator = Coordinator(client: client,
                                  imageCache: imageCache,
                                  persistence: persistence,
                                  colorTheme: theme)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = theme.windowBackgroundColor
        window.rootViewController = coordinator
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        coordinator?.save()
    }

}

