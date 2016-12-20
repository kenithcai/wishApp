//
//  MyLabel.h
//  HopeApp
//
//  Created by KenithCai on 16/12/20.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    top = 0, // default
    middle,
    bottom,
} VerticalStyle;

@interface MyLabel : UILabel
{
@private
    VerticalStyle _verStyle;
}

@property (nonatomic) VerticalStyle verStyle;

@end
