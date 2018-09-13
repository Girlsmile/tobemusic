//
//  showMoreController.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/1.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

//import Foundation
//import UIKit
//import CoreData
//import RealmSwift
//class Pratice:UIViewController{
//    
//    lazy var  button = UIButton(frame: CGRect(x: 150, y: 120, width: 100, height: 100))
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        button.backgroundColor=UIColor.blue
//        button.setTitle("本地音乐", for: UIControlState.normal)
//        button.addTarget(self,action: #selector(onclick_button), for: .touchUpInside)
//        self.view.addSubview(button)
//    }
//    
//    @objc func onclick_button() {
//        
//        func com(_ c:Int) -> (Int)->Bool {
//            return { b in return c>b}
//        }
//        
//        func closedBag(  _ a: @escaping (Int)->Bool) ->String {
//            DispatchQueue.main.async {
//                if a(6) {
//                } else {
//                    sleep(2)
//                    print("555555")
//                }
//            }
//            return "1"
//        }
//        
//        let s = closedBag { b in
//            return (b>6)&&(b==6)
//        }
//        print(s)
//        
//        let com10 = com(10)
//        print(com10(13))
//        
//        
//        return
//        //初始化第二页的控制器
//        let nextVC = TimerChangeController()
//        //显示第二页的控制器
//        self.navigationController?.pushViewController(nextVC, animated: true)
//        let plistPath = Bundle.main.path(forResource: "listDemo", ofType: "plist")
//        let data:NSMutableArray = NSMutableArray.init(contentsOfFile:plistPath!)!
//        print(plistPath!)
//        print(data)
//        let userDefault = UserDefaults.standard
//        
//        //sharePreference
//        //set 数据
//        userDefault.set("我是preference的值", forKey:"key")
//        userDefault.synchronize()
//        //读数据
//        let value1 = userDefault.string(forKey: "key")!
//        print(value1)
//        
//        //自定义类的存储
//        let father:Father = Father()
//        father.name = "baba"
//        father.son = "son"
//        //自定义类序列化
//        let data2 = NSKeyedArchiver.archivedData(withRootObject: father)
//        userDefault.set(data2, forKey: "a")
//        userDefault.synchronize()
//        print(userDefault.data(forKey: "a"))
//        
//        //字节文件转自定义类
//        let father2 = NSKeyedUnarchiver.unarchiveObject(with: data2) as! Father
//        print(father2.name)
//        print(father2.son)
//        
//        //Coredata
//        //操作数
//        let myContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let myEntityName = "Her"
//        let student = NSEntityDescription.insertNewObject(forEntityName: myEntityName, into: myContext)
//        //instert
//        student.setValue(1, forKey: "id")
//        student.setValue("Jesse", forKey: "name")
//        student.setValue(176.2, forKey: "height")
//        
//        do {
//            try myContext.save()
//        } catch {
//            fatalError("\(error)")
//        }
//        
//        //read
//        let request = NSFetchRequest<NSFetchRequestResult>(
//            entityName: myEntityName)
//        
//        do {
//            let results =
//                try myContext.fetch(request) as! [NSManagedObject]
//            
//            for result in results {
//                print("\(result.value(forKey: "id")!). \(result.value(forKey: "name")!)")
//                print("身高： \(result.value(forKey: "height")!)")
//            }
//            
//        } catch {
//            fatalError("\(error)")
//        }
//        
//        //update
//        //        let request = NSFetchRequest<NSFetchRequestResult>(
//        //                entityName: myEntityName)
//        request.predicate = nil
//        let updateID = 1
//        request.predicate = NSPredicate(format: "name = 'Jesse'")
//        
//        do {
//            let results =
//                try myContext.fetch(request) as! [NSManagedObject]
//            
//            if results.count > 0 {
//                results[0].setValue( 156.5, forKey: "height")
//                try myContext.save()
//            }
//            
//        } catch {
//            fatalError("\(error)")
//        }
//        
//        // delete
//        //        let request =
//        //            NSFetchRequest<NSFetchRequestResult>(
//        //                entityName: myEntityName)
//        request.predicate = nil
//        let deleteID = 3
//        request.predicate = NSPredicate(format: "id = \(deleteID)")
//        do {
//            let results =
//                try myContext.fetch(request) as! [NSManagedObject]
//            
//            for result in results {
//                myContext.delete(result)
//            }
//            try myContext.save()
//            
//        } catch {
//            fatalError("\(error)")
//        }
//        
//        //SQlite
//        //链接sqlite的变数
//        var db: OpaquePointer? = nil
//        //资料库的档案路径
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let sqlitePath = (urls.last?.absoluteString)!+"sqlite3.db"
//        print(sqlitePath)
//        let sql = "create table if not exists students " + "( id integer primary key autoincrement, " + "name text, height double)" as NSString
//        if sqlite3_open(sqlitePath, &db) == SQLITE_OK {
//            print ( "資料庫連線成功" )
//        } else {
//            print ( "資料庫連線失敗" )
//        }
//        
//        if sqlite3_exec(db, sql.utf8String , nil , nil , nil ) == SQLITE_OK {
//            print ( "建立資料表成功" )
//        }
//        
//        //Realm
//        let myDog = Dog()
//        myDog.name = "Rex"
//        myDog.age = 1
//        print("name of dog: \(myDog.name)")
//        
//        //初始化一个realm
//        let realm = try!Realm()
//        let puppies = realm.objects(Dog.self).filter("age<2")
//        var i = 1
//        repeat {
//            try! realm.write {
//                realm.add(myDog)
//                i+=1
//            }
//        }  while i<10
//        
//        
//        
//        // Query and update from any thread
//        DispatchQueue(label: "background").async {
//            autoreleasepool {
//                let realm = try! Realm()
//                let theDog = realm.objects(Dog.self).filter("age == 1").first
//                try! realm.write {
//                    theDog!.age = 3
//                }
//            }
//        }
//        print(realm.objects(Dog.self))
//        
//    }
//}
