//
//  ThinHttpManager.h
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/25.
//  Copyright © 2016年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
typedef NS_ENUM(NSInteger,ThinRequestType){
    ThinRequestGet,
    ThinRequestPost
};

@interface ThinHttpManager : AFHTTPSessionManager

@property (nonatomic,assign) ThinRequestType requestType;
+(instancetype)shareManager;
-(void)httpManagerRequestparameters:(NSDictionary *)parameters finish:(void (^)(NSData *data,NSDictionary *obj, NSError *error))finish;
@end
