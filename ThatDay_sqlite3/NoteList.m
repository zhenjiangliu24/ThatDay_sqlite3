//
//  NoteList.m
//  ThatDay_sqlite3
//
//  Created by ZhongZhongzhong on 16/5/1.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "NoteList.h"

@implementation NoteList
static NoteList *sharedManager = nil;

+ (NoteList *)shareManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
        [sharedManager createDBIfNeeded];
    });
    return sharedManager;
}

- (void)createDBIfNeeded
{
    NSString *writableDBPath = [self applicationDocumentDirectoryPath];
    const char *dbPath = [writableDBPath UTF8String];
    if (sqlite3_open(dbPath, &DB) != SQLITE_OK) {
        sqlite3_close(DB);
        NSAssert(NO,@"open data base failed");
    }else{
        char *error;
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS Note(date TEXT PRIMARY KEY, title TEXT, content TEXT, location TEXT, weather TEXT)"];
        const char *cSQL = [sql UTF8String];
        if (sqlite3_exec(DB, cSQL, NULL, NULL, &error) !=SQLITE_OK) {
            NSAssert(NO, @"create table failed");
            sqlite3_close(DB);
        }
        sqlite3_close(DB);
    }
}

- (int)addNote:(Note *)note
{
    NSString *writableDBPath = [self applicationDocumentDirectoryPath];
    const char *dbPath = [writableDBPath UTF8String];
    if (sqlite3_open(dbPath, &DB) != SQLITE_OK) {
        NSAssert(NO, @"open data base failed");
        sqlite3_close(DB);
    }else{
        NSString *sql_command = [NSString stringWithFormat:@"INSERT OR REPLACE INTO note (date, title, content, location, weather) VALUES (?,?,?,?,?)"];
        const char *cSQL = [sql_command UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(DB, cSQL, -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd/MM/yyyy hh:mm a"];
            NSString *dateString = [format stringFromDate:note.date];
            const char *cDate = [dateString UTF8String];
            const char *cTitle = [note.title UTF8String];
            const char *cContent = [note.content UTF8String];
            const char *cLocation = [note.location UTF8String];
            const char *cWeather = [note.weather UTF8String];
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            sqlite3_bind_text(statement, 2, cTitle, -1, NULL);
            sqlite3_bind_text(statement, 3, cContent, -1, NULL);
            sqlite3_bind_text(statement, 4, cLocation, -1, NULL);
            sqlite3_bind_text(statement, 5, cWeather, -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"insert failed");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(DB);
    }
    return 0;
}

- (int)editWithNote:(Note *)note
{
    NSString *writableDBPath = [self applicationDocumentDirectoryPath];
    const char *cPath = [writableDBPath UTF8String];
    if (sqlite3_open(cPath, &DB) != SQLITE_OK) {
        sqlite3_close(DB);
        NSAssert(NO, @"OPEN data base failed");
    }else{
        NSString *sql_command = [NSString stringWithFormat:@"UPDATE note SET title=?, content=? where date=?"];
        const char *cSql = [sql_command UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(DB, cSql, -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd/MM/yyyy hh:mm a"];
            NSString *dateString = [format stringFromDate:note.date];
            const char *cDate = [dateString UTF8String];
            const char *cTitle = [note.title UTF8String];
            const char *cContent = [note.content UTF8String];
            sqlite3_bind_text(statement, 3, cDate, -1, NULL);
            sqlite3_bind_text(statement, 1, cTitle, -1, NULL);
            sqlite3_bind_text(statement, 2, cContent, -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"edit failed");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(DB);
    }
    return 0;
}

- (int)deleteNote:(Note *)note
{
    NSString *writableDBPath = [self applicationDocumentDirectoryPath];
    const char *cPath = [writableDBPath UTF8String];
    if (sqlite3_open(cPath, &DB) != SQLITE_OK) {
        sqlite3_close(DB);
        NSAssert(NO, @"OPEN data base failed");
    }else{
        NSString *sql_command = [NSString stringWithFormat:@"DELETE from note where date=?"];
        const char *cSql = [sql_command UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(DB, cSql, -1, &statement, NULL) == SQLITE_OK) {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd/MM/yyyy hh:mm a"];
            NSString *dateString = [format stringFromDate:note.date];
            const char *cDate = [dateString UTF8String];
            sqlite3_bind_text(statement, 1, cDate, -1, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"delete failed");
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(DB);
    }
    return 0;
}

- (NSMutableArray *)getAllNotes
{
    NSMutableArray *listData = [[NSMutableArray alloc] init];
    NSString *path = [self applicationDocumentDirectoryPath];
    const char *cPath = [path UTF8String];
    if (sqlite3_open(cPath, &DB) != SQLITE_OK) {
        NSAssert(NO, @"can not open data base");
        sqlite3_close(DB);
    }else{
        NSString *sql_command = [NSString stringWithFormat:@"select date, title, content, location, weather FROM Note"];
        const char *cSql = [sql_command UTF8String];
        sqlite3_stmt *statement;
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/yyyy hh:mm a"];
        if (sqlite3_prepare_v2(DB, cSql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *cDate = (char *)sqlite3_column_text(statement, 0);
                NSString *strDate = [NSString stringWithUTF8String:cDate];
                NSDate *date = [format dateFromString:strDate];
                
                char *cTitle = (char *)sqlite3_column_text(statement, 1);
                NSString *strTitle = [NSString stringWithUTF8String:cTitle];
                
                char *cContent = (char *)sqlite3_column_text(statement, 2);
                NSString *strContent = [NSString stringWithUTF8String:cContent];
                
                char *cLocation = (char *)sqlite3_column_text(statement, 3);
                NSString *strLocation = [NSString stringWithUTF8String:cLocation];
                
                char *cWeather = (char *)sqlite3_column_text(statement, 4);
                NSString *strWeather = [NSString stringWithUTF8String:cWeather];
                
                Note *note = [[Note alloc] initWithTitle:strTitle andContent:strContent andDate:date andLocation:strLocation andWeatherInfo:strWeather];
                [listData addObject:note];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(DB);
    }
    return listData;
}

- (NSString *)applicationDocumentDirectoryPath
{
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documentDirectory stringByAppendingPathComponent:DBFileName];
    return path;
}
@end
