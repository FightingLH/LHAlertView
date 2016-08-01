//
//  main.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/25.
//  Copyright © 2016年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <tingyunApp/NBSAppAgent.h>
int main(int argc, char * argv[]) {
    @autoreleasepool {
        [NBSAppAgent startWithAppID:@"5b4c32cc95204724bdb36cbedf620102"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
