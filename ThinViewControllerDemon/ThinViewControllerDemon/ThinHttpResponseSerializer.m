//
//  ThinHttpResponseSerializer.m
//  ThinViewControllerDemon
//
//  Created by lh on 16/7/26.
//  Copyright © 2016年 lh. All rights reserved.
//
/**
 *  @author 李欢, 16-07-26 09:07:44
 *
 *  监听网络状态
 */
#import "ThinHttpResponseSerializer.h"
NSString *const ThinNetWrokingErrorDomain = @"ThinNetWrokingErrorDomain";
@implementation ThinHttpResponseSerializer
static BOOL AFErrorOrUnderlyingErrorHasCode(NSError *error, NSInteger code) {
    if (error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return AFErrorOrUnderlyingErrorHasCode(error.userInfo[NSUnderlyingErrorKey], code);
    }
    
    return NO;
}

static NSError * AFErrorWithUnderlyingError(NSError *error, NSError *underlyingError) {
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"image/jpeg", @"image/png", nil];
    return self;
}
- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (AFErrorOrUnderlyingErrorHasCode(*error, NSURLErrorCannotDecodeContentData)) {
            if (error) {
                NSError *newError = *error;
                if (![newError.domain isEqualToString:ThinNetWrokingErrorDomain]) {
                    NSMutableDictionary *mutDic = newError.userInfo.mutableCopy;
                    mutDic[NSLocalizedDescriptionKey] = @" 服务器有点小问题，不要走开马上回来~";
                    newError = [NSError errorWithDomain:ThinNetWrokingErrorDomain code:newError.code userInfo:mutDic];
                }
                *error = newError;
            }
            return nil;
        }
    }
    
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    id responseObject = nil;
    NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
    if (responseString && ![responseString isEqualToString:@" "]) {
        // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
        // See http://stackoverflow.com/a/12843465/157142
        data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *serializationError = nil;
        if (data) {
            if ([data length] > 0) {
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
            } else {
                //return nil;
                serializationError = [NSError errorWithDomain:ThinNetWrokingErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:@{NSLocalizedDescriptionKey: @"服务器放空中，很快就会回来的，请稍后重试！",NSLocalizedFailureReasonErrorKey: @"返回数据为空"}];
            }
        } else {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: @"服务器获取异常，请稍后重试！",
                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", nil, @"AFNetworking"), responseString]
                                       };
            
            serializationError = [NSError errorWithDomain:ThinNetWrokingErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
        }
        
        if (error) {
            NSError *newError = AFErrorWithUnderlyingError(serializationError, *error);
            if (newError && ![newError.domain isEqualToString:ThinNetWrokingErrorDomain]) {
                NSMutableDictionary *mutDic = newError.userInfo.mutableCopy;
                mutDic[NSLocalizedDescriptionKey] = @" 服务器有点小问题，不要走开马上回来~";
                newError = [NSError errorWithDomain:ThinNetWrokingErrorDomain code:newError.code userInfo:mutDic];
            }
            *error = newError;
        }
    }
    
    return responseObject;
}

@end
