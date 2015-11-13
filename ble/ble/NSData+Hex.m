//
//  NSData+Hex.m
//  ble-utility
//
//  Created by 北京锐和信科技有限公司 on 11/10/13.
//  Copyright (c) 2013 北京锐和信科技有限公司. All rights reserved.
//

#import "NSData+Hex.h"

@implementation NSData(Hex)

+(BOOL)byteAtIndex:(int)index Byte:(Byte)byte{//获取字节指定位的0|1 从低到高位
    if (index<0 || index>=8) return NO;
    return (BOOL)((byte>>index)&0x01);
}
//获取data指定位
+ (BOOL)dataGetBitIndex:(int)index data:(NSData *)data{
    int byteNum = (int)data.length;
    if (index<0 || index>=byteNum*8) return NO;//超出
    
    int byteIndex = (byteNum-1)-floor(index/8);
    Byte * bytes = (unsigned char *)[data bytes];
    Byte theByte = bytes[byteIndex];//从右向左；低位到高位
    return [self byteAtIndex:index%8 Byte:theByte];
}

- (NSString *)hexadecimalString {
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}
+ (NSData *)dataWithHexString:(NSString *)hexstring
{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexstring.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexstring substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}
@end
