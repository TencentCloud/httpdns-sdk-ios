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
        let result = self.msdkDns?.wgGetHosts(byNames: ["qq.com", "dnspod.com"]);
        let data = try? JSONSerialization.data(withJSONObject: result ?? [], options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8) ?? "";
        resultView?.insertText(str + "\n\n");
    }


}

 
