//
//  DetailViewController.swift
//  iOS-day-by-day-contacts
//
//  Created by 好采猫 on 15/9/29.
//  Copyright © 2015年 haocaimao. All rights reserved.
//

import UIKit
import Contacts // 通讯录信息 iOS9 新特性

class DetailViewController: UIViewController {
    
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactPhoneNumberLabel: UILabel!
    
    var contact: CNContact? {
        didSet {
            self.configureView()
        }// 计算属性 通过set方法 赋值
    }
    
    func configureView(){
        
        /**
            取出类里面的属性 一一赋值
        */
        if let contact = self.contact{
            if let label = self.contactNameLabel {
                // 调用类方法 初始化一个通讯录个人信息的名字 并按照指定的格式.FullName
                label.text = CNContactFormatter.stringFromContact(contact, style: .FullName)
            }
            
        if let imageView = self.contactImageView{
            // 如果用户没有设置图片默认 应该 这是为 nil
            if contact.imageData != nil{
                // 这里是设置图片圆角 然并卵
                imageView.layer.cornerRadius = self.contactImageView.frame.size.width / 2
                imageView.clipsToBounds = true
                            
                // 通讯录的图片 存在系统文件是以data的形式存储数据
                imageView.image = UIImage(data: contact.imageData!)
            }else{
                imageView.image = nil;
            }
        }
            
        if let phoneNumberLabel = self.contactPhoneNumberLabel {
            // 用户的电话是用一个数组保存的 因为一个用户可以有多个电话
                var numberArray = [String]()
                for number in contact.phoneNumbers {
                    let phoneNumber = number.value as! CNPhoneNumber
                    numberArray.append(phoneNumber.stringValue)
                }
            // 将数组以 ，间隔形成字符串 返回出去
                phoneNumberLabel.text = numberArray.joinWithSeparator(",");
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
    }
    
    deinit{
        print("控制器销毁")
    }

}
