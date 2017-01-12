//
//  MyTool.h
//  zFM
//
//  Created by zykhbl on 15-9-25.
//  Copyright (c) 2015年 zykhbl. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOWN_PLIST @"checkDown.plist"

@interface MyTool : NSObject

+ (NSString*)makeUserFilePath:(NSString*)filename;
// 创建tmp文件夹
+ (NSString*)makeTmpFilePath:(NSString*)filename;
+ (NSString*)makeAppFilePath:(NSString*)filename;

// 在tmp文件夹里面创建plist
+ (NSString*)makePlistInTmp:(NSString*)filename;

// 在plist里面添加值
+ (void)addValue:(NSString*)plistPath key:(NSString *)key value:(NSString *)value;
+ (NSString*)readValue:(NSString*)plistPath key:(NSString*)key;
+ (NSString*)readValueInAudioPlist:(NSString*)key;

+ (void)makeDir:(NSString*)dir;
+ (void)makeDirWithFilePath:(NSString*)filepath;
+ (BOOL)checkFilepathExists:(NSString*)filepath;
+ (void)makeFile:(NSString*)filepath;
+ (void)removeFile:(NSString*)filepath;




@end
