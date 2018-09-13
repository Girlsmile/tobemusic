//
//  mainViewController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/7/31.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import SDWebImage
import SnapKit
class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        super.viewDidLoad()
        self.creatSubviewController()
        self.navigationController?.navigationBar.isTranslucent = false
         self.navigationController?.hidesBottomBarWhenPushed = true
       
    }
    
   private func creatSubviewController(){
       let firstView = MusicListController()
       //添加View
       firstView.title = "Trending"
       //把子的控价加到nav中,nav导航页面，栈方式存储
       let nav0 = UINavigationController(rootViewController: firstView)
       firstView.tabBarItem.title = "Trending"
       firstView.tabBarItem.badgeColor = UIColor.black
       firstView.tabBarItem.image = #imageLiteral(resourceName: "Trending")
        
       let secondView=SearchViewController()
       secondView.title = "Search"
       let nav1=UINavigationController(rootViewController: secondView)
       secondView.tabBarItem.title = "Search"
       secondView.tabBarItem.badgeColor = UIColor.brown
       secondView.tabBarItem.image=#imageLiteral(resourceName: "Search")
        
       let thridView = SongController()
       thridView.title = "Songs"
       let nav2=UINavigationController(rootViewController: thridView)
       thridView.tabBarItem.title = "Songs"
       thridView.tabBarItem.badgeColor=UIColor.black
       thridView.tabBarItem.image = #imageLiteral(resourceName: "Headset")

       let fourthView = PlayListController()
       fourthView.title = "Playlist"
       let nav3 = UINavigationController(rootViewController: fourthView)
       fourthView.tabBarItem.title = "Playlist"
       //fourview.tabBarItem.badgeColor = UIColor.darkText
       fourthView.tabBarItem.image = #imageLiteral(resourceName: "Playlist")
    
       let fiveView = ShowMoreController()
       fiveView.title = "More"
       let nav4 = UINavigationController(rootViewController: fiveView)
       fiveView.tabBarItem.title = "More"
       fiveView.tabBarItem.badgeColor = UIColor.darkText
       fiveView.tabBarItem.image = #imageLiteral(resourceName: "More")
    
        tabBar.tintColor = UIColor.orange
        let tabs = [nav0,nav1,nav2,nav3,nav4]
        //加到自己的viewcontroller,这是uitoorbars是数组
        self.viewControllers = tabs
        //为每一个vc创建一个uinavigatecontroller
        tabBar.isTranslucent = false
    }
    
    @objc func listAllSorts() {
         let nextVC = SortList()
         self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
