//
//  NoteBL.h
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Note.h"
#import "NoteList.h"
@interface NoteBL : NSObject
- (NSMutableArray *)addNote:(Note *)note;
- (NSMutableArray *)editNote:(Note *)note;
- (NSMutableArray *)deleteNote:(Note *)note;
- (NSMutableArray *)getAllNote;
@end
