//
//  GnResponSerialization.swift
//  ZhiRenGu
//
//  Created by 梁琪琛 on 2018/8/3.
//  Copyright © 2018年 sxw. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class GnResponSerialization: NSObject {

}


extension DataRequest{
    @discardableResult 
    public func responeObject<T:Any>(queue:DispatchQueue? = nil,completionHandler:@escaping ((DataResponse<GnNetWorkModel<T>>)->()))->Self{
        
       let serializer = DataResponseSerializer<GnNetWorkModel<T>> { (request, response, data, error) -> Result<GnNetWorkModel<T>> in
        
            guard error == nil else { return .failure(error!) }
            
            if let response = response, emptyDataStatusCodes.contains(response.statusCode) { return .success(GnNetWorkModel<T>()) }
            
            guard let validData = data else {
                
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: validData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                let model = GnNetWorkModel<T>.deserialize(from: json)
                if model != nil {
                    if model?.status == true{
                        return .success(model!)
                    }else{
                        return .failure(GnError.statueEroor(desc: (model?.desc) ?? ""))
                    }
                    
                }else{
                    return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
                }
            } catch {
                return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
            }
        }
        
        return response(queue: queue,
                        responseSerializer: serializer,
                        completionHandler: completionHandler)
    
    }
    
  
}

public enum GnError : Error {
    case statueEroor(desc:String)
}

open class GnNetWorkModel<T:Any>: HandyJSON {
    var data:T?
    var flag = ""
    var desc = ""
    var status = false

    required public init() {}
}


private let emptyDataStatusCodes: Set<Int> = [204, 205]


