//
//  MVCLoader.m
//  RainbowNote
//
//  Created by 张超 on 2019/3/22.
//  Copyright © 2019 Gerinn. All rights reserved.
//

#import "ClassyKitLoader.h"
#import "MVCLoader.h"
#import "RRExtraViewController.h"
#import "RRReadMode.h"
@import MagicalRecord;
@import SVProgressHUD;
@import mvc_base;
@import ui_base;
@import IQKeyboardManager;

@implementation MVCLoader

+ (void)registRouter
{
    [MVPRouter registView:NSClassFromString(@"RNMainView") forURL:@"rn://main"];
}

+ (void)configUI
{
//    [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[UITableViewCell class]]] setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[UIApplication sharedApplication] setHUDStyle];
    [SVProgressHUD setHapticsEnabled:YES];
}

+ (void)loadCas
{
    [ClassyKitLoader cleanStyleFiles]; // 删除本地cas文件
    [ClassyKitLoader copyStyleFile]; // 拷贝cas文件
    [[self class] notiReloadCas];
  
}

+ (void)notiReloadCas
{
    RRReadMode mode = [[NSUserDefaults standardUserDefaults] integerForKey:@"kRRReadMode"];
    switch (mode) {
        case RRReadModeDark:
        {
            [ClassyKitLoader loadWithStyle:@"rrstyle" variables:@"style_dark"]; //加载cas文件
            break;
        }
        case RRReadModeLight:
        {
            [ClassyKitLoader loadWithStyle:@"rrstyle" variables:@"style"]; //加载cas文件
            break;
        }
        default:
            break;
    }
}

+ (void)loadCoreData
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Data"];
}


+ (void)loadForApplication:(UIApplication *)app
{
    [[self class] registRouter];
    [[self class] configUI];
    [[self class] loadCas];
    [[self class] loadCoreData];
    
    id vc = [MVPRouter viewForURL:@"rn://main" withUserInfo:nil];
    RRExtraViewController* nv = [[RRExtraViewController alloc] initWithRootViewController:vc];
    id<UIApplicationDelegate> delegate = app.delegate;
    delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    delegate.window.backgroundColor = [UIColor whiteColor];
    delegate.window.rootViewController = nv;
    [delegate.window makeKeyAndVisible];
}

@end
