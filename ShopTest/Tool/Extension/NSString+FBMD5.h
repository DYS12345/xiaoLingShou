//
//  NSString+FBMD5.h
//  parrot
//
//  Created by xiaoyi on 15/11/12.
//  Copyright © 2015年 taihuoniao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (FBMD5)

+ (NSString *)getMd5_32Bit_String:(NSString *)srcString;
- (NSString *)FBMD5Hash8;
- (NSString *)FBMD5Hash32;
+(NSString*) sha1:(NSString *)str;
+ (NSString *)base64StringFromText:(NSString *)text;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
