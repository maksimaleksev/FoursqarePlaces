//
//  AppDelegate.swift
//  FoursqarePlaces
//
//  Created by Maxim Alekseev on 25.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var didBecomeActive: BehaviorRelay<Bool> = BehaviorRelay(value: false)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppSettings.shared.getSettingsDataFromStorage()
        
        return true
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        didBecomeActive.accept(true)
    }
    
    
}

