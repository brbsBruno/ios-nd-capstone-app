//
//  AppDelegate.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 28/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let dataController = DataController(modelName: "Model")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        dataController.load()
        
        let navigationController = window?.rootViewController as! UINavigationController
        let questsViewController = navigationController.topViewController as! QuestsViewController
        questsViewController.dataController = dataController
        
        return true
    }

}

