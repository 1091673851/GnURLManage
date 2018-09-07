//
//  GnURLManage.swift
//  ZhiRenGu
//
//  Created by 梁琪琛 on 2018/8/3.
//  Copyright © 2018年 sxw. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON
import SVProgressHUD

class GnURLManage: NSObject {

   static let defaultCenter = GnURLManage()
    
    /// app域名
    var baseUrl = "https://www.baidu.com/"
    
    /// 初始化配置信息
    override init() {
        let manager = Alamofire.SessionManager.default
        // 10s超时
        manager.session.configuration.timeoutIntervalForRequest = 10
    }
    
    /// 默认请求头 根据自己需求切换
    func setHttpHeader()->[String: String]{
        let time = String(Int(NSDate().timeIntervalSince1970)*1000)
        let md5 = "\(time)1#j0ZAqg".getMd5()
        let header = ["key":md5,
                      "times":time,
                      "language":"CN"]
        return header
    }

    
}

class GnRequest<value:Any>{
    
    typealias valueClourse = ((GnNetWorkModel<value>)->())?
    typealias valueError = ((Error)->())?

    
    ///   Get请求 返回三心网所需要的模型 data = value
    ///
    /// - Parameters:
    ///   - url: 链接 如果没带http则自动补齐主页
    ///   - isObstruction : 请求时是否响应其他事件
    ///   - parameters:  参数
    ///   - value: 返回闭报
    ///   - error: 错误闭包
    /// - Returns: 返回请求
    @discardableResult
    static public func request(url:String,isObstruction:Bool,parameters:[String:Any]?,value:valueClourse,error:valueError)->DataRequest{
        var realUrl = url
        if url.contains("http") == false{
            realUrl = "\(AppURL)\(url)"
        }
        if isObstruction == true{
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
            SVProgressHUD.show(withStatus: "正在请求")
        }
        
     return  Alamofire.request(realUrl,
                method: HTTPMethod.get,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: GnURLManage.defaultCenter.setHttpHeader())
            .responeObject(queue: DispatchQueue.main)
            {(data:DataResponse<GnNetWorkModel<value>>) in
                if isObstruction == true{
                    SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
                    SVProgressHUD.dismiss()
                }
                if value != nil,data.value != nil{ 
                    value!(data.value!)
                }
                if error != nil,data.error != nil{
                    error!(data.error!)
                }
                if data.error != nil{
                    GnURLManage.configError(error: data.error!)
                }
        }
    }
    
    
    
    /// post 网络请求
    ///
    /// - Parameters:
    ///   - url: 域名
    ///   - isObstruction: 网络请求时是否中断其他操作
    ///   - parameters: 参数 可以为image,[UIImage]
    ///   - value:  成功时返回的
    ///   - error:  失败的时候返回
    static public func upload(url:String,isObstruction:Bool,parameters:[String:Any]?,value:valueClourse,error:valueError){
        var realUrl = url
        if url.contains("http") == false{
            realUrl = "\(GnURLManage.defaultCenter.baseUrl)\(url)"
        }
        if isObstruction == true{
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
            SVProgressHUD.show(withStatus: "正在请求")
        }
        Alamofire.upload(multipartFormData: { (formData) in
            guard parameters != nil else { return }
            for (key,objc) in parameters!{
                if objc is UIImage{
                    let image = objc as! UIImage
                    let data = UIImageJPEGRepresentation(image, 0.8)
                    formData.append(data!, withName: key, fileName: "ios.jpg", mimeType: "image/jpeg")
                }else if objc is Array<UIImage>{
                    for image in objc as! Array<UIImage>{
                        let data = UIImageJPEGRepresentation(image, 0.8)
                        formData.append(data!, withName: key, fileName: "ios.jpg", mimeType: "image/jpeg")
                    }
                }else{
                    let str = objc as! String
                    let strData = str.data(using:String.Encoding.utf8)!
                    formData.append(strData, withName: key)
                }
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
           to: realUrl,
           method: .post,
           headers: GnURLManage.defaultCenter.setHttpHeader()) { (result) in
            if isObstruction == true{
                SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
                SVProgressHUD.dismiss()
            }
            switch result{
                
            case .success(let request,  _,  _):
                request.responeObject(completionHandler: { (data:DataResponse<GnNetWorkModel<value>>) in
                    if value != nil,data.value != nil{
                        value!(data.value!)
                    }
                    if error != nil,data.error != nil{
                        error!(data.error!)
                    }
                    if data.error != nil{
                        GnURLManage.configError(error: data.error!)
                    }
                })
            case .failure(let error):
                GnURLManage.configError(error:error)
            }
        }
    }
    
    
    deinit {
        print("释放网络请求")
    }
}


