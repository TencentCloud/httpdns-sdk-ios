//
//  LabelWithPickView.m
//  PickerViewDemo
//
//  Created by FrankLiu on 15/12/24.
//  Copyright © 2015年 FrankLiu. All rights reserved.
//

#import "LabelWithPickView.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation LabelWithPickView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)tapAction {

    [self becomeFirstResponder];
}

// 这个方法必须实现
- (BOOL) canBecomeFirstResponder {
    
    return YES;
}

@end
