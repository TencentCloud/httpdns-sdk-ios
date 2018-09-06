using System.Threading;
using System.Runtime.InteropServices;
using UnityEngine;

namespace com.tencent.httpdns
{
    class HttpDns
    {
#if UNITY_ANDROID
        private static Thread mMainThread = Thread.CurrentThread;
        private static bool mIsMainThread
        {
            get
            {
                return Thread.CurrentThread == mMainThread;
            }
        }

        private static AndroidJavaObject mHttpDnsObj = null;
#endif

#if UNITY_IOS
        [DllImport("__Internal")]
        private static extern string WGGetHostByName(string domain);
        [DllImport("__Internal")]
        private static extern void WGGetHostByNameAsync(string domain);
        [DllImport("__Internal")]
        private static extern bool WGSetDnsOpenId(string dnsOpenId);
        [DllImport("__Internal")]
        private static extern bool WGSetInitInnerParams(string appkey, bool debug, int timeout);
        [DllImport("__Internal")]
        private static extern bool WGSetInitParams(string appkey, int dnsid, string dnskey, bool debug, int timeout);
#endif

        public static void Init(string appId, bool debug, int timeout)
        {
#if UNITY_ANDROID
            AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            if (unityPlayerClass == null)
            {
                Debug.Log("unityPlayerClass == null");
                return;
            }
            AndroidJavaObject currentActivityObj = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");
            if (currentActivityObj == null)
            {
                Debug.Log("currentActivityObj == null");
                return;
            }
            AndroidJavaClass httpDnsClass = new AndroidJavaClass("com.tencent.msdk.dns.MSDKDnsResolver");
            if (httpDnsClass == null)
            {
                Debug.Log("httpDnsClass == null");
                return;
            }
            mHttpDnsObj = httpDnsClass.CallStatic<AndroidJavaObject>("getInstance");
            if (mHttpDnsObj == null)
            {
                Debug.Log("mHttpDnsObj == null");
                return;
            }
            mHttpDnsObj.Call("init", currentActivityObj, appId, debug, timeout);
#endif
#if UNITY_IOS
            WGSetInitInnerParams(appId, debug, timeout);
#endif
        }

        public static void Init(string appId, int dnsid, string dnskey, bool debug, int timeout)
        {
#if UNITY_ANDROID
            AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
            if (unityPlayerClass == null)
            {
                Debug.Log("unityPlayerClass == null");
                return;
            }
            AndroidJavaObject currentActivityObj = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");
            if (currentActivityObj == null)
            {
                Debug.Log("currentActivityObj == null");
                return;
            }
            AndroidJavaClass httpDnsClass = new AndroidJavaClass("com.tencent.msdk.dns.MSDKDnsResolver");
            if (httpDnsClass == null)
            {
                Debug.Log("httpDnsClass == null");
                return;
            }
            mHttpDnsObj = httpDnsClass.CallStatic<AndroidJavaObject>("getInstance");
            if (mHttpDnsObj == null)
            {
                Debug.Log("mHttpDnsObj == null");
                return;
            }
            mHttpDnsObj.Call("init", currentActivityObj, appId, dnsid, dnskey, debug, timeout);
#endif
#if UNITY_IOS
            WGSetInitParams(appId, dnsid, dnskey, debug, timeout);
#endif
        }

        public static bool SetOpenId(string openId)
        {
#if UNITY_ANDROID
            return mHttpDnsObj.Call<bool>("WGSetDnsOpenId", openId);
#else
#if UNITY_IOS
            return WGSetDnsOpenId (openId);
#endif
            return false;
#endif
        }

        public static string GetAddrByName(string domain)
        {
#if UNITY_ANDROID
            if (!mIsMainThread && AndroidJNI.AttachCurrentThread() != 0)
            {
                return null;
            }
            string ips = mHttpDnsObj.Call<string>("getAddrByName", domain);
            if (!mIsMainThread)
            {
                AndroidJNI.DetachCurrentThread();
            }
            return ips;
#else
#if UNITY_IOS
            return WGGetHostByName (domain);
#endif
            return null;
#endif
        }

        public static void GetAddrByNameAsync(string domain)
        {
#if UNITY_IOS
            WGGetHostByNameAsync (domain);
#endif
        }
    }
}
