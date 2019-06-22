//
//  AppDelegate.swift
//  Cloud Test Video Player
//
//  Created by Emil on 22/06/19.
//  Copyright © 2019 Oztra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.isIdleTimerDisabled = true // So our phone doesn't sleep during the test
        return true
    }

}

