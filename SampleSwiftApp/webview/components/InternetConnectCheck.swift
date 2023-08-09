//
//  InternetConnectCheck.swift
//  SampleSwiftApp
//
//  Created by 김정민 on 2023/08/09.
//

import Foundation
import SystemConfiguration

class InternetConnectCheck {
    // 인터넷 연결 확인
    // 솔직히 뭔말인지 모르겠어서 그냥 써야할듯
    class func networkConnect() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0,0,0,0,0,0,0,0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress){
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                zeroAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
}
