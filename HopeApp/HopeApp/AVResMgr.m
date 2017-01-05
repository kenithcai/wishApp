//
//  AVResMgr.m
//  HopeApp
//
//  Created by KenithCai on 17/1/4.
//  Copyright © 2017年 KenithCai. All rights reserved.
//

#import "AVResMgr.h"

@implementation AVResMgr

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
 
}
@end
