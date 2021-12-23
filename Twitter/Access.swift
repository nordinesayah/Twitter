//
//  Acess.swift
//  Twitter
//
//  Created by Nordine Sayah on 27/09/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import Foundation

final class Access {
    static let CUSTOMER_KEY = "EGC1w1Jf8SbQiQXAUGSCtdTtx"
    static let CUSTOMER_SECRET = "SpxEjQXP5Vvup1QfToqOfryGB31PNeXJB7TpIyYun1haWgWvCN"
    static let BEARER = ((CUSTOMER_KEY + ":" + CUSTOMER_SECRET).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue : 0))
    
    static var accessToken = String()
}
