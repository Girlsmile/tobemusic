
//  AppDelegate.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/7/31.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import AVKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController:UINavigationController?
      func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //配置Realm更新
        let config = Realm.Configuration(
            // 设置新的架构版本。这个版本号必须高于之前所用的版本号
            // （如果您之前从未设置过架构版本，那么这个版本号设置为 0）
            schemaVersion: ConfigurationVersion.schemaVersion,
            
            // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
            migrationBlock: { migration, oldSchemaVersion in
                // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
                if (oldSchemaVersion < ConfigurationVersion.schemaVersion) {
                    // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
                }
        })
        
        
        
        //        //改变值
        //        Realm.Configuration.defaultConfiguration = Realm.Configuration(
        //            schemaVersion: 2,
        //            migrationBlock: { migration, oldSchemaVersion in
        //                if (oldSchemaVersion < 1) {
        //                    // enumerateObjects(ofType:_:) 方法遍历了存储在 Realm 文件中的每一个“Person”对象
        //                    migration.enumerateObjects(ofType: Song.className()) { oldObject, newObject in
        //                        // 将名字进行合并，存放在 fullName 域中
        ////                        let firstName = oldObject!["firstName"] as! String
        ////                        let lastName = oldObject!["lastName"] as! String
        ////                        newObject!["fullName"] = "\(firstName) \(lastName)"
        //                    }
        //                }
        //        })
        
        // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
        Realm.Configuration.defaultConfiguration = config
        // 现在我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移
        let realm = try! Realm()
        
        
        // Override point for customization after application launch.
        //指定RootTabController为根试图
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        //重点 //指定一个navigationController给uiwindows
        let root = MainViewController()
        //self.window?.rootViewController=root
        //navigationController=UINavigationController(rootViewController: root)
        window?.rootViewController=root
        self.window?.makeKeyAndVisible()
        //        if let window = window {
        //
        //            navigationController = UINavigationController(rootViewController: FourthViewController())
        //            window.rootViewController = navigationController
        //            window.makeKeyAndVisible()
        //        }
        
        //后台播放相关
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayback)
        try! session.setActive(true)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
      print("我是背景")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       print("我是前台")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
       
    }


    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "xcdCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

