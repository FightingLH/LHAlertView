//
//  NSString+Operation.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/26.
//  Copyright © 2016年 lh. All rights reserved.
//

#import "NSString+Operation.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (Operation)
//对参数做一个md5加密
-(NSString *)MD5String{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString
            stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5],
            result[6], result[7], result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
@end
