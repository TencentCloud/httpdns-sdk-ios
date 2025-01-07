//
//  ViewController.swift
//  MSDKDnsSwiftDemo
//
//  Created by vastlhli(李浩) on 2021/6/5.
//

import UIKit

class ViewController: UIViewController {
    
    var msdkDns: MSDKDns?;
    @IBOutlet var resultView : UITextView?;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 调用SDK解析接口之前必须初始化配置
        self.msdkDns = MSDKDns.sharedInstance() as? MSDKDns;
        self.msdkDns?.initConfig(with: [
            "debug": true,
            "dnsId": "your dnsId",
            "dnsKey": "your dnsKey",
            "encryptType": 0, // 0 -> des，1 -> aes，2 -> https
        ]);
        resultView?.isEditable = false;
    }
    
    @IBAction func clickButton () {
        resultView?.text = ""
        let domains = ["qq.com", "dnspod.com"]
        let startTime = Date().timeIntervalSince1970
        if let result = msdkDns?.wgGetAllHosts(byNames: domains) {
            let endTime = Date().timeIntervalSince1970
            let duration = (endTime - startTime) * 1000
            print("=====本次耗时=====：\(duration)ms")
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                resultView?.insertText("\n解析结果为：\n\(jsonString)\n\n")
            }
        } else {
            resultView?.insertText("\n本次解析失败，请再次请求一次。\n\n")
        }
    }

    @IBAction func clickSniBtn(_ sender: Any) {
        AlamofireSwiftTest.sendAlamofireRequest(resultView: resultView);
    }
}
