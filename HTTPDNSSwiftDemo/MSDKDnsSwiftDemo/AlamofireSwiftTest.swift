//
//  AlamofireSwiftTest.swift
//  MSDKDnsSwiftDemo
//
//  Created by xinjie wen on 2025/1/7.
//

import UIKit
import Alamofire

final class AlamofireSwiftTest : NSObject {
    
    var tool : MSDKDnsHttpMessageTools?;
    let sessionManager: Session
    static let shared = AlamofireSwiftTest()
    
    let session: URLSession
    
    private override init() {
        // Alamofire init
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses?.insert(MSDKDnsHttpMessageTools.self, at: 0)
        
        sessionManager = Alamofire.Session(configuration: configuration)
        
        // URLSession init
        let config = URLSessionConfiguration.default
        config.protocolClasses?.insert(MSDKDnsHttpMessageTools.self, at: 0)
                
        session = URLSession(configuration: config)
        
    }
    
    @objc static func sendAlamofireRequest(resultView: UITextView?) {
        resultView?.text = ""
            AlamofireSwiftTest.shared.sessionManager.request("https://www.qq.com").response { response in
                switch response.result {
                case .success(let data):
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                        resultView?.insertText("\n解析结果为：\n\(jsonString)\n\n")
                    } else {
                        resultView?.insertText("\n无法解析响应数据。\n\n")
                    }
                case .failure(let error):
                    resultView?.insertText("\n请求失败：\(error.localizedDescription)\n\n")
                }
            }
        }

}



