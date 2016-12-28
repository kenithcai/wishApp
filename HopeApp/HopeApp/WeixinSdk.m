//
//  WeixinSdk.m
//  HopeApp
//
//  Created by KenithCai on 16/11/19.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#import "WeixinSdk.h"

#define WX_APP_ID       "wxdfe1608ac7e45ce3"
#define WX_APP_SECRET   "f03e7da8ed56bff12fff03b7e333dfa5"
#define WX_OAUTH2_URL   "https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"

static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
static NSString *kAuthOpenID = @"0c806938e2413ce73eef92cc3";
static NSString *kAuthState = @"com.fingertip.HopeApp";

static WeixinSdk * delegate = nil;

@implementation WeixinSdk

+(WeixinSdk *)instance
{
    @synchronized (self)
    {
        if(!delegate)
        {
            delegate = [[self alloc] init];
        }
    }
    return delegate;
}

+(BOOL) handleOpenUrl:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[WeixinSdk instance]];
}

-(void) initSdk
{
    [WXApi registerApp:@WX_APP_ID];
}

- (NSDictionary *) getAccessToken:(NSString *)code
{
    NSString * appIDString = [NSString stringWithCString: WX_APP_ID encoding:NSUTF8StringEncoding];
    
    NSString * appSecretString = [NSString stringWithCString: WX_APP_SECRET encoding:NSUTF8StringEncoding];
    
    NSString * codeString = [NSString stringWithCString: [code UTF8String] encoding:NSUTF8StringEncoding];
    
    NSString * formatString = [NSString stringWithCString: WX_OAUTH2_URL encoding:NSUTF8StringEncoding];
    
    NSString * urlString =[NSString stringWithFormat:formatString, appIDString, appSecretString, codeString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:urlString]];
    
    [request setHTTPMethod:@"GET"];
    
    NSHTTPURLResponse* urlResponse = nil;
    
    NSError * error = [[NSError alloc] init];
    
    NSData * responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSMutableString * result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    return dic;
}

- (void) dealSendMessageResp:(SendMessageToWXResp *)rep {
    
    NSString *strMsg = nil;
    if (rep.errCode == 0)
    {
        strMsg = @"发送成功";
    }
    else
    {
        strMsg = @"发送失败";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [alert show];
    [NSTimer scheduledTimerWithTimeInterval:2.0f repeats:false block:^(NSTimer*time){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        NSLog(@"The date and time is");
    }];
}

-(void) dealSendAuthResp:(SendAuthResp *)rep
{
    if (nil == rep) return;
    if (rep.errCode == 0)
    {
        NSDictionary * dic = [[WeixinSdk instance] getAccessToken:rep.code];
        NSString * openid = [dic objectForKey:@"openid"];
        NSString * unionid = [dic objectForKey:@"unionid"];
        NSString * token = [dic objectForKey:@"access_token"];
        
    }
}
//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)req
{
    
}
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        [[WeixinSdk instance] dealSendMessageResp:(SendMessageToWXResp *)resp];
        
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        [[WeixinSdk instance] dealSendAuthResp:(SendAuthResp *)resp];
    }
}

-(BOOL) loginWx
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = kAuthScope; // @"post_timeline,sns"
    req.state = kAuthState;
//    req.openID = kAuthOpenID;
    
    return [WXApi sendAuthReq:req
               viewController:nil
                     delegate:[WeixinSdk instance]];
}

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    return message;
}


- (BOOL) sendText:(NSString *)text InScene:(enum WXScene)scene
{
    if ([WXApi isWXAppInstalled] == FALSE)
    {
        return FALSE;
    }
    SendMessageToWXReq *req = [WeixinSdk requestWithText:text
                                                   OrMediaMessage:nil
                                                            bText:YES
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

-(BOOL) sendImg:(NSData *)imgData InScene:(enum WXScene)scene
{
    printf("aaaaaaaaaaaaaaaaaaa = %d\n",[WXApi isWXAppInstalled]);
    if ([WXApi isWXAppInstalled] == FALSE)
    {
        return FALSE;
    }
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imgData;
    
    WXMediaMessage *mes = [WeixinSdk messageWithTitle:@"title" Description:@"des" Object:ext MessageExt:@"mes" MessageAction:@"act" ThumbImage:nil MediaTag:@"tag"];
    
    SendMessageToWXReq* req = [WeixinSdk requestWithText:nil
                                          OrMediaMessage:mes
                                                   bText:NO
                                                 InScene:scene];
    return [WXApi sendReq:req];
}
@end
