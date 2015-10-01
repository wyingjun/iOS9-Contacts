//
//  MasterViewController.swift
//  iOS-day-by-day-contacts
//
//  Created by 好采猫 on 15/9/29.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

import UIKit
import Contacts  // 访问系统通讯录 进行 读取操作 iOS9 新特性
import ContactsUI  // 询问用户是否接受访问通讯录 iOS9 新特性

class MasterViewController: UITableViewController ,CNContactPickerDelegate{
    
//    var detailVC: DetailViewController? = nil
    
    var contacts = [CNContact]() //存放通讯录的数组
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let split = self.splitViewController {
//             let controllers = split.viewControllers
//            self.detailVC = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
        
        /**
            获得全局队列 在子线程中 获取通讯录 再回到主线程 更新
        */
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.contacts = self.findContacts()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView!.reloadData()
            }
        }
        
    }
  
    override func viewWillAppear(animated: Bool) {
        // 是否 清除选中标志
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }
    
    // 获取 通讯录 返回一个数组
    func findContacts() -> [CNContact]{
        let store = CNContactStore() // 声明一个 读取保存 通讯录的 不可变对象
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
            CNContactImageDataKey,
            CNContactPhoneNumbersKey] // 声明一个 作为初始化 通讯录请求 的参数体  ps:有很多别的属性 自己可以点进去看看
        /**
            CNContactFormatter           名字
            CNContactImageDataKey        图片
            CNContactPhoneNumbersKey     电话
        */
        
        // 通过刚才创建的 参数对象  创建请求对象
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        
        // 创建存储 通讯录 对象的数组
        var contacts = [CNContact]()
        
        
        /**
            do{
            try{}
        }catch{
        }
        
        处理异常语法  如果try 出现异常
        进入catch 语句  补抓程序崩溃
        */
        
        do{
            // 通过刚才创建的 CNContactStore 对象 调用该方法 传入请求对象  通过block 遍历所有联系人。添加到准备好的数组 。 此方法会返回一个bool 通过bool 异常机制可以补抓失败 防止程序崩溃
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: {
                (let contact, let stop) -> Void in
                // 遍历时 把每一个对象添加到数组中
                contacts.append(contact)
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // 把数组返回出去
        return contacts
    }
    
    // MARK: - Segues
    /**
        补抓跳转事件 完成传值 顺手设置一下leftBarButtonItem 没什么好说的。
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let contact = contacts[indexPath.row] as CNContact
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.contact = contact
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    // 这个更加没什么好说的了
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let contact = contacts[indexPath.row] as CNContact
        cell.textLabel!.text = "\(contact.givenName) \(contact.familyName)"
        return cell
    }
    
    // MARK: - UIBarButtonItem
    
    @IBAction func showContactsPicker(sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
        // 不设置 默认显示联系人的所有个人信息
        // 注意这个属性 这个属性的设置 跟下面的协议方法 所点击的获取的类型 必须一样 否则会崩溃。
         contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    // MARK: - Contacts Picker
    
    /**
    点击通讯录个人的某个信息时 调用
    */
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        
        let contact = contactProperty.contact
                        // 就是这个 这里获取了点击的key 类型必须和上面的一致
                        // 注意这个属性 返回的类型有3种 如果上面的属性不设置 默认打开全部个人信息 那在这里就必须判断 是哪个类型 然后进行强制转换
                        //  你也可以不转换 直接打印 contactProperty.value 查看都是什么类型
                        //  ps: 点击生日 有时候会出现 nil
        let phoneNumber = contactProperty.value as! CNPhoneNumber
        
        print(contact.givenName)
        print(phoneNumber.stringValue)
    }

}
