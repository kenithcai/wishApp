//
//  CMKeyChain.h
//  HopeApp
//
//  Created by KenithCai on 16/11/22.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#ifndef CMKeyChain_h
#define CMKeyChain_h

@interface CMKeyChain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service ;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end

#endif /* CMKeyChain_h */
