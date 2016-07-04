//
//  EditViewController.h
//  ThatDayUniversal
//
//  Created by ZhongZhongzhong on 16/4/29.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//
#import "Note.h"

@protocol EditVCDelegate <NSObject>

- (void)editWithNote:(Note *)note;
- (void)addNote:(Note *)note;
- (void)deleteNote;
@end
@interface EditViewController : UIViewController
@property (strong, nonatomic) NSString *titleString;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) NSString *contentString;
@property (assign, nonatomic) BOOL isModalSegue;
@property (weak, nonatomic) id<EditVCDelegate> delegate;
@end
