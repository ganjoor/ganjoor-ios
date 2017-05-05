//
//  AppDelegate.swift
//  Ganjoor
//
//  Created by Farzad Nazifi on 2/27/17.
//  Copyright © 2017 boon. All rights reserved.
//

import UIKit
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        return window
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = ASNavigationController(rootViewController: PoetsVS())
        window?.makeKeyAndVisible()
        return true
    }
}
