//
//  HttpEngine.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/16.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import Alamofire
class HttpEngine {
    static let shareInstance = HttpEngine()
    private init(){}
}
extension HttpEngine {
    // get请求
    func getRequest(url:String, parameters:[String : Any]?,success:@escaping (_ response : NSDictionary)->(), failure: @escaping (_ error : Error)->()) {
        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{ (response) in
            switch response.result {
            case .success:
            if let value = response.result.value {
                   let jsonDic:NSDictionary = value as! NSDictionary
                   success(jsonDic)
                }
            case .failure(let error):
                  failure(error)
            }
        }
    }
    
    func getDuration(id: String,success:@escaping (_ duration : String)->() ,failure: @escaping (_ error : Error)->()) {
            let url="https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails&id=\(id)&key=AIzaSyBNn6edhT1sUExOwIorB3dFXeiZnwRGYGk"
            Thread.detachNewThread {
                Alamofire.request(url).responseJSON{ response in
                    switch response.result{
                    case .success:
                        let json=response.result.value
                        //print(json!)
                        let jsonDic:NSDictionary=json! as! NSDictionary
                        if let modle:VideoRootClass = VideoRootClass.deserialize(from: jsonDic){
                            for item in modle.items
                            {
                                //item.contentDetails.duration="PT1H24M"
                                if item.contentDetails.duration != nil {
                                    print(item.contentDetails.duration)
                                    let  ishaveHours:[Substring]=item.contentDetails.duration.split(separator: "H", maxSplits: 1, omittingEmptySubsequences: false)
                                    let   ishaveSed:[Substring]=item.contentDetails.duration.split(separator: "S", maxSplits: 1, omittingEmptySubsequences: false)
                                    let   ishaveMin:[Substring]=item.contentDetails.duration.split(separator: "M", maxSplits: 1, omittingEmptySubsequences: false)
                                    //print(ishaveHours)
                                    if ishaveHours.count<=1&&ishaveSed.count>=2&&ishaveMin.count>=2{
                                        var text:[Substring]=item.contentDetails.duration.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: false)
                                        text=text[1].split(separator: "M", maxSplits: 1, omittingEmptySubsequences: true)
                                        let min=text[0]
                                        var sed=text[1].split(separator: "S", maxSplits: 1, omittingEmptySubsequences: true)[0]
                                        if sed.count==1{
                                            let n = sed.removeLast()
                                            sed.append("0")
                                            sed.append(n)
                                        }
                                        print(min+":"+sed)
                                        
                                        DispatchQueue.main.async(execute: {
                                            
                                            success(min+":"+sed)
                                        })
                                    }
                                    else
                                        if ishaveHours.count>=2&&ishaveMin.count>=2&&ishaveSed.count>=2{
                                            var text:[Substring]=item.contentDetails.duration.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: false)
                                            text=text[1].split(separator: "H", maxSplits: 1, omittingEmptySubsequences: true)
                                            let hou=text[0]
                                            text=text[1].split(separator: "M", maxSplits: 1, omittingEmptySubsequences: true)
                                            let min=text[0]
                                            var sed=text[1].split(separator: "S", maxSplits: 1, omittingEmptySubsequences: true)[0]
                                            if sed.count==1{
                                                let n = sed.removeLast()
                                                sed.append("0")
                                                sed.append(n)
                                            }
                                            
                                            DispatchQueue.main.async(execute: {
                                                success(hou+":"+min+":"+sed)
                                            })
                                            
                                        }
                                        else if ishaveMin.count<=1
                                        {
                                            var text:[Substring]=item.contentDetails.duration.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: false)
                                            let sed=text[1].split(separator: "S", maxSplits: 1, omittingEmptySubsequences: true)[0]
                                            DispatchQueue.main.async(execute: {
                                                success("00"+":"+sed)
                                            })
                                        }
                                        else if ishaveSed.count>=2
                                        {
                                            var text:[Substring]=item.contentDetails.duration.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: false)
                                            text=text[1].split(separator: "H", maxSplits: 1, omittingEmptySubsequences: true)
                                            let hou=text[0]
                                            let sed=text[1].split(separator: "S", maxSplits: 1, omittingEmptySubsequences: true)[0]
                                            DispatchQueue.main.async(execute: {
                                                
                                               success( hou+":"+"00:"+sed )
                                            })
                                        }
                                        else if ishaveSed.count>=2 {
                                            var text:[Substring]=item.contentDetails.duration.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: false)
                                            text=text[1].split(separator: "H", maxSplits: 1, omittingEmptySubsequences: true)
                                            let hou=text[0]
                                            let min=text[1].split(separator: "M", maxSplits: 1, omittingEmptySubsequences: true)[0]
                                            DispatchQueue.main.async(execute: {
                                                success( hou+":"+min+":00" )
                                            })
                                        }
                                        else {
                                            var text:[Substring]=item.contentDetails.duration.split(separator: "T", maxSplits: 1, omittingEmptySubsequences: false)
                                            let min=text[1].split(separator: "M", maxSplits: 1, omittingEmptySubsequences: true)[0]
                                            DispatchQueue.main.async(execute: {
                                               success( min+":00" )
                                            })
                                            
                                    }
                                    
                                    
                                }
                            }
                        }
                    case .failure(let error):
                        print("加载有问题")
                        failure(error)
                    }
                }
            }
            
        }
        
    }
