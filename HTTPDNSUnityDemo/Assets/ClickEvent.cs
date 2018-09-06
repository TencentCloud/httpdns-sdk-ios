using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using com.tencent.httpdns;

public class ClickEvent : MonoBehaviour {

    public InputField domain;
    public Text result;

    public void StartSyncClick() {
        // vip vport area
        print ("StartSyncClick");
        string domainStr = domain.text;
        print (domainStr);
        if (domainStr == null || domainStr.Equals("")) {
            domainStr = "www.qq.com";
            print("input is null, use the default domain: www.qq.com.");
            result.text = "input is null, use the default domain: www.qq.com.";
        }
        string ips = HttpDns.GetAddrByName(domainStr);
        print (ips);
        string[] sArray=ips.Split(new char[] {';'});
        if (sArray != null && sArray.Length > 1) {
            if (!sArray[1].Equals("0")) {
                //使用建议：当ipv6地址存在时，优先使用ipv6地址
                //TODO 使用ipv6地址进行连接，注意格式，ipv6需加方框号[ ]进行处理，例如：http://[64:ff9b::b6fe:7475]/
                result.text = "ipv6 address exist:" + sArray[1] + ", suggest to use ipv6 address.";
            } else if(!sArray [0].Equals ("0")) {
                //使用ipv4地址进行连接
                result.text = "ipv6 address not exist, use the ipv4 address:" + sArray[0] + " to connect.";
            } else {
                //异常情况返回为0,0，建议重试一次
                print ("ReStartSyncClick");
                print (domainStr);
                if (domainStr == null || domainStr.Equals("")) {
                    domainStr = "www.qq.com";
                    print("input is null, use the default domain:www.qq.com.");
                    result.text = "input is null, use the default domain:www.qq.com.";
                }
                HttpDns.GetAddrByName(domainStr);
            }
        }
    }

    public void StartAsyncClick() {
        // vip vport area
        print ("StartAsyncClick");
        string domainStr = domain.text;
        print (domainStr);
        if (domainStr == null || domainStr.Equals("")) {
            domainStr = "www.qq.com";
            print("input is null, use the default domain:www.qq.com.");
            result.text = "input is null, use the default domain:www.qq.com.";
        }
        HttpDns.GetAddrByNameAsync(domainStr);
    }

    public void onDnsNotify(string ipString) {
        print (ipString);
        string[] sArray=ipString.Split(new char[] {';'});
        if (sArray != null && sArray.Length > 1) {
            if (!sArray [1].Equals ("0")) {
                //使用建议：当ipv6地址存在时，优先使用ipv6地址
                //TODO 使用ipv6地址进行连接，注意格式，ipv6需加方框号[ ]进行处理，例如：http://[64:ff9b::b6fe:7475]/
                result.text = "ipv6 address exist:" + sArray [1] + ", suggest to use ipv6 address.";
            } else if(!sArray [0].Equals ("0")){
                //使用ipv4地址进行连接
                result.text = "ipv6 address not exist, use the ipv4 address:" + sArray [0] + " to connect.";
            } else {
                //异常情况返回为0,0，建议重试一次
                print("ReStartSyncClick");
                print(domainStr);
                if (domainStr == null || domainStr.Equals(""))
                {
                    domainStr = "www.qq.com";
                    print("input is null, use the default domain:www.qq.com.");
                    result.text = "input is null, use the default domain:www.qq.com.";
                }
                HttpDns.GetAddrByNameAsync(domainStr);
            }
        }
    }
}
