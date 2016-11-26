//
//  CMUUIDManager.h
//  HopeApp
//
//  Created by KenithCai on 16/11/22.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#ifndef CMUUIDManager_h
#define CMUUIDManager_h

@interface CMUUIDManager : NSObject

+(void)saveUUID:(NSString *)uuid;

+(id)readUUID;

+(void)deleteUUID;

@end

#endif /* CMUUIDManager_h */
