//
//  LabelWithPickView.h
//  PickerViewDemo
//
//  Created by FrankLiu on 15/12/24.
//  Copyright © 2015年 FrankLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelWithPickView : UILabel

// 将UIResponder的这两个readonly属性变为readwrite
@property (nonatomic,strong,readwrite) __kindof UIView * inputView;
@property (nonatomic,strong,readwrite) __kindof UIView * inputAccessoryView;

@end
