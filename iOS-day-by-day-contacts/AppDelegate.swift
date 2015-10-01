//
//  AppDelegate.swift
//  iOS-day-by-day-contacts
//
//  Created by 好采猫 on 15/9/29.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,UISplitViewControllerDelegate{

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /**
            拿到 window 的 rootViewController 类型检查 必须 转换为目标类型  ！强制解绑
            通过 rootViewController 拿到 UINavigationController
            设置 UINavigationController 的 leftBarButtonItem 为 displayModeButtonItem
            设置 成为 UISplitViewController 的代理
        displayModeButtonItem 详解 ⬇️
            一个用来触发 displayView 的按钮， 点击出现另一个窗口
            如果设备不支持UISplitViewController 此按键默认不存在
        
        */
        
        let splitVC = self.window!.rootViewController as! UISplitViewController
        
        /**
            splitVC.preferredDisplayMode = .PrimaryOverlay
                这个属性可以设置拆分视图的布局形式
              .Automatic  系统默认  竖屏 隐藏master视图 反之
              .AllVisible 显示全部内容 点击detail区域 master视图不会回缩
              .PrimaryHidden 隐藏 master视图 不管横屏 竖屏
              .PrimaryOverlay 初始时 master&detail 视图可见， 其余跟.PrimaryHidden一样
        */
        
        let navC = splitVC.viewControllers[splitVC.viewControllers.count-1] as! UINavigationController
        navC.topViewController!.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem()
        splitVC.delegate = self
        
        return true
    }
    
    // MARK - Split View
    /**
        UISplitViewController 左侧的拆分视图 再竖屏时候 默认为隐藏 通过创建的item点击
                                            横屏时候 默认为显示
        
        如果设置了 UISplitViewController 的 preferredDisplayMode 属性 这个方法就没会失效
    */
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        
        /**
            Swift 2.0 新语法 
            guard
            简洁的判断语句
            只能携带 一个 else 判断语句块
        
            举个🌰
            guard let str = "🌰" as? String else{
                return false
            }  ---- ✅
            
            guard let str = "🌰" as? String else{
            
            if ( 1 == 1){
            return true
            }
            }  ---- ✅
        
            guard let str = "🌰" as? String else{
                    return false
                }else{
                    return true
            }  ---- ❎
        */
        
        guard let secondearyAsNavC = secondaryViewController as? UINavigationController else { return false }
        
        guard let topAsDetailC = secondearyAsNavC.topViewController as? DetailViewController else { return false }
        
        if topAsDetailC.contact == nil {
            return true
        }
        return false
       
    }
}

