//
//  AppDelegate.m
//  Demo
//
//  Created by iOS@Umeng on 12-3-19.
//  Copyright (c) 2012年 iOS@Umeng. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "UMFeedback.h"
#import "UMessage_Sdk_1.1.0/UMessage.h"

#define APPKEY @"5425495dfd98c594860045ed"

#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [UMFeedback setAppkey:APPKEY];
    [UMFeedback setLogEnabled:YES];
    
    ViewController *controller = [ViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];

    // with remote push notification
    [UMessage startWithAppkey:APPKEY launchOptions:launchOptions];
    if (IOS_8_OR_LATER) {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    } else {
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge |
                                                     UIRemoteNotificationTypeSound |
                                                     UIRemoteNotificationTypeAlert];
    }
     [UMessage setLogEnabled:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkFinished:)
                                                 name:UMFBCheckFinishedNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:nil
                                               object:nil];
    
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    [UMFeedback didReceiveRemoteNotification:notificationDict];
    return YES;
}

- (void)receiveNotification:(id)receiveNotification {
//    NSLog(@"receiveNotification = %@", receiveNotification);
}

- (void)checkFinished:(NSNotification *)notification {
    NSLog(@"class checkFinished = %@", notification);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Remote Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
    NSLog(@"umeng message alias is: %@", [UMFeedback uuid]);
    [UMessage addAlias:[UMFeedback uuid] type:@"umeng_feedback" response:^(id responseObject, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", error);
            NSLog(@"%@", responseObject);
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    [UMessage didReceiveRemoteNotification:userInfo];
    [UMFeedback didReceiveRemoteNotification:userInfo];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if ([alertView.title isEqualToString:NSLocalizedString(@"new feedback", nil)])
	{
		if (buttonIndex == 1) // "open" button
		{
            UINavigationController *currentVC = (UINavigationController *)self.window.rootViewController;
            [currentVC pushViewController:[UMFeedback feedbackViewController]
                                                 animated:YES];
		}
	}
}

@end
