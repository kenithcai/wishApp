//
//  MyLabel.m
//  HopeApp
//
//  Created by KenithCai on 16/12/20.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#import "MyLabel.h"

@implementation MyLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize verStyle = verticalAlignment_;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = middle;
    }
    return self;
}

- (void)setVerticalAlignment:(VerticalStyle)verStyle {
    verticalAlignment_ = verStyle;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    switch (self.verStyle) {
        case top:
            textRect.origin.y = bounds.origin.y;
            break;
        case bottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
            break;
        case middle:
            // Fall through.
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

-(void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect limitedToNumberOfLines:self.numberOfLines];
    [super drawTextInRect:actualRect];
}

@end
