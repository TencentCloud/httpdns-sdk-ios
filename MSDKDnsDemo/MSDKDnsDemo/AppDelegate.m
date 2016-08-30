//
//  AppDelegate.m
//  MSDKDnsDevDemo
//
//  Created by 付亚明 on 7/1/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "AppDelegate.h"
// 未接入MSDK的游戏需单独接入灯塔
#import <BeaconAPI_Base/BeaconBaseInterface.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(
        NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // 已正常接入MSDK的游戏无需关注以下代码，未接入MSDK的游戏调用以下代码注册灯塔
    // ******************************
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *appid = dict[@"COOPERATOR_APPID"];
    [BeaconBaseInterface setAppKey:appid];
    [BeaconBaseInterface enableAnalytics:@"" gatewayIP:nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
