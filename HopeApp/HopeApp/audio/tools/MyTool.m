//
//  MyTool.h
//  zFM
//
//  Created by zykhbl on 15-9-25.
//  Copyright (c) 2015年 zykhbl. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool

+ (NSString*)makeUserFilePath:(NSString*)filename {
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    return filePath;
}

+ (NSString*)makeTmpFilePath:(NSString*)filename {	
	NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
	
	return filePath;
}

+ (NSString*)makeAppFilePath:(NSString*)filename {
	NSString *appDirectory = [[NSBundle mainBundle] resourcePath];
	NSString *filePath = [appDirectory stringByAppendingPathComponent:filename];
	
	return filePath;
}

+ (NSString*)makePlistInTmp:(NSString *)filename {
    NSString *tmpPath = [MyTool makeTmpFilePath:filename];
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:tmpPath];
    if (dic == nil) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:tmpPath contents:nil attributes:nil];
        NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        [mdic writeToFile:tmpPath atomically:YES];
    }
    return tmpPath;
}

+ (void)addValue:(NSString *)plistPath key:(NSString *)key value:(NSString *)value {
    NSLog(@"key == %@,value == %@",key,value);
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    
    [dic setObject:value forKey:key];
    [dic writeToFile:plistPath atomically:YES];
}
+(NSString*)readValue:(NSString *)plistPath key:(NSString *)key {
    NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    if (dic == nil) {
        return nil;
    }
    return [dic objectForKey:key];
}
+(NSString*)readValueInAudioPlist:(NSString *)key {
    NSString *path = [MyTool makePlistInTmp:DOWN_PLIST];
    NSString *file = [MyTool readValue:path key:key];
    return file;
}


+ (void)makeDir:(NSString*)dir {
	NSFileManager *fm = [NSFileManager defaultManager];
	
	if ([fm fileExistsAtPath:dir]) {
		return ;
	} else {
		NSError* error;
		[fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
	}
}

+ (void)makeDirWithFilePath:(NSString*)filepath {
	if (!filepath) {
		return ;
	}
	NSString *filename = [filepath lastPathComponent];
	NSString *dirpath = [filepath substringToIndex:([filepath length]-[filename length])];
	
	return [[self class] makeDir:dirpath];	
}

+ (BOOL)checkFilepathExists:(NSString*)filepath {
	NSFileManager *fm = [NSFileManager defaultManager];
	return [fm fileExistsAtPath:filepath];
}

+ (void)makeFile:(NSString*)filepath {
	if (![self checkFilepathExists:filepath]) {
        [self makeDirWithFilePath:filepath];
        
        NSFileManager *fm = [NSFileManager defaultManager];
		[fm createFileAtPath:filepath contents:nil attributes:nil];
    }
}

+ (void)removeFile:(NSString*)filepath {
    if ([self checkFilepathExists:filepath]) {        
        NSFileManager *fm = [NSFileManager defaultManager];
        
        NSError* error;
		[fm removeItemAtPath:filepath error:&error];
    }
}

@end
