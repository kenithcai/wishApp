//
//  WeixinSdk.h
//  HopeApp
//
//  Created by KenithCai on 16/11/19.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#ifndef WeixinSdk_h
#define WeixinSdk_h

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface WeixinSdk : NSObject <WXApiDelegate>

+(WeixinSdk *)instance;

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene;

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName;

+(BOOL) handleOpenUrl:(NSURL *)url;

-(void) initSdk;

-(BOOL) loginWx;

-(BOOL) sendText:(NSString *)text
         InScene:(enum WXScene)scene;

//-(BOOL) sendImg:(NSString *)imgFile
//        InScene:(enum WXScene)scene;

-(BOOL) sendImg:(NSData *)data
        InScene:(enum WXScene)scene;

@end

#endif /* WeixinSdk_h */
