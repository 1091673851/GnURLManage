//
//  String+MD5.swift
//  ZhiRenGu
//
//  Created by 梁琪琛 on 2018/8/3.
//  Copyright © 2018年 sxw. All rights reserved.
//

import UIKit

extension String{
    //md5加密算法
    func getMd5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize(count: digestLen)
        return String(hash)
    }
}
