//
//  ThinHttpManager.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/25.
//  Copyright © 2016年 lh. All rights reserved.
//

#import "ThinHttpManager.h"
#import "AFNetworking.h"
#import "ThinHttpResponseSerializer.h"
static NSString *baseUrl = @"http://api.liwushuo.com/v1/collections?";


@implementation ThinHttpManager

-(instancetype)initWithBaseUrl:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];//监听网络状态打开
        self.responseSerializer = [ThinHttpResponseSerializer serializer];
        NSURLCache *cache = [[NSURLCache alloc]initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:cache];//减缓与服务端的交互做的一个缓存处理
        
    }
    return self;
}

+(instancetype)shareManager{
    
    static ThinHttpManager *manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token,^{
        manager = [[ThinHttpManager alloc]initWithBaseURL:[NSURL URLWithString:baseUrl]];
    });
    return manager;
    
}

//不再做封装直接使用,主要是为了实现瘦身ViewController
-(void)httpManagerRequestparameters:(NSDictionary *)parameters finish:(void (^)(NSData *data,NSDictionary *obj, NSError *error))finish{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if (self.requestType == ThinRequestGet) {
        
        [manager GET:baseUrl parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%@",downloadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finish(responseObject,nil,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finish(nil,nil,error);
        }];
        
    }else if (self.requestType == ThinRequestPost){
        
        [manager POST:baseUrl parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            finish(responseObject,nil,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            finish(nil,nil,error);
        }
         ];
    }
    
}

@end
