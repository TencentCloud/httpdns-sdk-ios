using UnityEngine;
using System.Runtime.InteropServices;

namespace com.tencent.httpdns {
    public class HttpDns {
#if UNITY_IOS
        [DllImport("__Internal")]
		private static extern string WGGetHostByName(string domain);
		[DllImport("__Internal")]
		private static extern void WGGetHostByNameAsync(string domain);
#endif

        // 解析域名
		public static string GetHostByName(string domain) {
#if UNITY_EDITOR
			return "1.2.3.4;0";
#endif

#if UNITY_IOS
			return WGGetHostByName (domain);

#endif
		}

		public static void GetHostByNameAsync(string domain) {
#if UNITY_IOS
			WGGetHostByNameAsync (domain);	
#endif
		}
	}
}