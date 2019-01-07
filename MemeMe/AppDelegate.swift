//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Abdulaziz AlObaili on 22/11/2018.
//  Copyright © 2018 Abdulaziz Alobaili. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
}

