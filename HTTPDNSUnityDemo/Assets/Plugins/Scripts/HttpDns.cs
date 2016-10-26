using UnityEngine;
using System.Runtime.InteropServices;

namespace com.tencent.httpdns {
    public class HttpDns {
#if UNITY_ANDROID
		private static AndroidJavaClass sGSDKPlatformClass;
#endif

#if UNITY_IOS
        [DllImport("__Internal")]
		private static extern string WGGetHostByName(string domain);
#endif

        // 解析域名
		public static string GetHostByName(string domain) {
#if UNITY_EDITOR
			return "1.2.3.4;0";
#endif

#if UNITY_IOS
			return WGGetHostByName (domain);

#endif
				
#if UNITY_ANDROID
			return null;
#endif
		}
	}
}