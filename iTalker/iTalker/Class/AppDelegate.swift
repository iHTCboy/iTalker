//
//  AppDelegate.swift
//  iTalker
//
//  Created by HTC on 2017/4/8.
//  Copyright © 2017年 iHTCboy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        startBaiduMobStat()
        
        setupBaseUI()
        
        ITCommonAPI.sharedInstance.checkAppUpdate(newHandler: nil)
        
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        if shortcutItem.type.contains("iTer://search") {
            let vc = IHTCSearchViewController()
            let navi = UINavigationController.init(rootViewController: vc)
            navi.navigationBar.isHidden = true
            UIApplication.shared.keyWindow?.rootViewController!.present(navi, animated: true, completion: nil)
        }
        
        if shortcutItem.type.contains("iTer://star") {
            IAppleServiceUtil.inAppRating(url: kAppDownloadURl)
        }
        
        if shortcutItem.type.contains("iTer://love") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                IAppleServiceUtil.openAppstore(url: kAppDownloadURl, isAssessment: false)
            })
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

// MARK: Prive method
extension AppDelegate {
    
    func startBaiduMobStat() {
        
        #if DEBUG
            print("Debug modle")
            //statTracker?.channelId = "Debug"
        #else
            let statTracker = BaiduMobStat.default()
            statTracker?.channelId = "AppStore"
            statTracker?.shortAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            statTracker?.start(withAppId: "0f4db57bb7")
            
            let formatter = DateFormatter()
            formatter.locale = Locale.current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let currentDate = formatter.string(from: Date())
        
            // 自定义事件
            statTracker?.logEvent("usermodelName", eventLabel: UIDevice.init().modelName)
            statTracker?.logEvent("systemVersion", eventLabel: UIDevice.current.systemVersion)
            statTracker?.logEvent("DateSystemVersion", eventLabel: currentDate + " " + UIDevice.current.systemVersion)
            statTracker?.logEvent("DateAndDeviceName", eventLabel: currentDate + " " + UIDevice.current.name)
            statTracker?.logEvent("Devices", eventLabel:UIDevice.current.name)
            statTracker?.logEvent("AppName", eventLabel:( Bundle.main.infoDictionary?["CFBundleName"] as! String))
        #endif
        //         statTracker.enableDebugOn = true;
        
    }
    
    func setupBaseUI() {
        let ui = UINavigationBar.appearance()
        ui.tintColor = UIColor.white
        ui.barTintColor = kColorAppBlue
        
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
}


