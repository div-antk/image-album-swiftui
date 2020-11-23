//
//  AppDelegate.swift
//  ImageAlbum
//
//  Created by Takuya Ando on 2020/11/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask,
                                                            true)[0]
    print(documentsPath)
    
    // お気に入り情報のデフォルト値として空配列を設定
    let userDefaults = UserDefaults.standard
    
    // すべてのUserDefaults値を初期化
    // UserDefaultsのキーにAppInitを指定して初期化判定値を取得
    let isAppInit = userDefaults.bool(forKey: UserDefaultsKey.isAppInit)
    if isAppInit {
      
      // バンドルID（アプリ固有のID）を取得してremovePersistentDomainに渡すとUserDefaultsのすべての値が削除されて初期値に置き換わる
      // つまり設定アプリにて初期化スイッチ（AppInit）をONにすると以下の処理で値が初期化する
      if let bundleId = Bundle.main.bundleIdentifier {
        userDefaults.removePersistentDomain(forName: bundleId)
      }
    }
    
    // アプリバージョンを取得してUserDefaults（appVersion）に保存
    // ここで保存したアプリバージョンが設定アプリで表示されるß
    if let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
      userDefaults.set(appVersion, forKey: UserDefaultsKey.appVersion)
    }
    
    userDefaults.register(defaults: [UserDefaultsKey.arrayFavorite: []])
    
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

