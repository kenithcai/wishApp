//
//  CMUUIDManager.m
//  HopeApp
//
//  Created by KenithCai on 16/11/22.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CMUUIDManager.h"
#import "CMKeyChain.h"

@implementation CMUUIDManager

static NSString * const KEY_IN_KEYCHAIN = @"com.fingertip.HopeApp";
static NSString * const KEY_UUID = @"com.fingertip.HopeApp.uuid";

+(void)saveUUID:(NSString *)uuid
{
    NSMutableDictionary *usernameUuidPairs = [NSMutableDictionary dictionary];
    [usernameUuidPairs setObject:uuid forKey:KEY_UUID];
    [CMKeyChain save:KEY_IN_KEYCHAIN data:usernameUuidPairs];
}

+(id)readUUID
{
    NSMutableDictionary *usernameUuidPairs = (NSMutableDictionary *)[CMKeyChain load:KEY_IN_KEYCHAIN];
    return [usernameUuidPairs objectForKey:KEY_UUID];
}

+(void)deleteUUID
{
    [CMKeyChain delete:KEY_IN_KEYCHAIN];
}
@end
