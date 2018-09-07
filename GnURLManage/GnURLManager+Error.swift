//
//  GnURLManager+Error.swift
//  ZhiRenGu
//
//  Created by 梁琪琛 on 2018/8/6.
//  Copyright © 2018年 sxw. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

extension GnURLManage{
    
    static func configError(error:Error){
        if let newerror:AFError = error as? AFError{
            GnURLManage.configAFError(error: newerror)
        }
        if let newerror:GnError = error as? GnError{
            GnURLManage.configGnError(error: newerror)
        }
        GnURLManage.configNSError(error: error)
    }
    
    static func configAFError(error:AFError){
        switch error {
        case .invalidURL(let url):
            SVProgressHUD.showError(error: "请求接口失败")
        case .parameterEncodingFailed:break
        case .multipartEncodingFailed:break
        case .responseValidationFailed:break
        case .responseSerializationFailed(let reason):
            SVProgressHUD.showError(error: "网络请求失败-404")
        }
    }
    
    
    
    static func configGnError(error:GnError){
        switch error {
        case .statueEroor(let desc):
            print(desc)
            SVProgressHUD.showError(error:desc)
        }
    }
    
    static func configNSError(error:Error){
        print(error.localizedDescription)
    }
    
    
}
