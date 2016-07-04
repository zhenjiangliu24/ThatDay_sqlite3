//
//  NoteList.h
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "Note.h"
#import <sqlite3.h>
#define DBFileName @"Notes3.sqlite3"
@interface NoteList : NSObject
{
    sqlite3 *DB;
}
@property (strong, nonatomic) NSMutableArray *listData;

+ (NoteList *)shareManager;
- (int)addNote:(Note *)note;
- (int)editWithNote:(Note *)note;
- (int)deleteNote:(Note *)note;
- (NSMutableArray *)getAllNotes;
@end
