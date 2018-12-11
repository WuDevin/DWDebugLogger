//
//  DWDebugLogHelper.m
//  DWAppProject
//
//  Created by lg on 2018/12/4.
//  Copyright © 2018 DevinWu. All rights reserved.
//

#import "DWDebugLogHelper.h"

static NSString *kNSDateHelperFormatCompactDate             = @"yyMMdd";

@implementation DWDebugLogHelper

#pragma mark - Init                         - Method -
+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

-(instancetype)init{
    if (self = [super init]) {
        self.maxNumTimeOfLogger = 3;
        self.maxNumDayOfLogFiles = 7;
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[self class] sharedInstance];
}

- (id)copy {
    return [[self class] sharedInstance];
}

- (id)mutableCopy {
    return [[self class] sharedInstance];
}

#pragma mark - PubilcMethod                 - Method -
-(void)logAtTime:(NSString *)time fileName:(NSString *)fileName level:(kDebugLogInfoLevel)level function:(NSString *)function lineNum:(NSInteger)lineNum onEvent:(NSString *)event logMessage:(NSString *)message{
    
    [self logAtTime:time fileName:fileName level:level function:function lineNum:lineNum onEvent:event logMessage:message saveToFile:YES];

}

-(void)logAtTime:(NSString *)time fileName:(NSString *)fileName level:(kDebugLogInfoLevel)level function:(NSString *)function lineNum:(NSInteger)lineNum onEvent:(NSString *)event logMessage:(NSString *)message saveToFile:(BOOL)save{
    
    NSString *logHeader = @"-------------------👇LoggerInfo Tool👇-------------------";
    NSString *baseInfo = [NSString stringWithFormat:@"\n[%@] [%@]-[%@] [第%ld行]",time,[fileName componentsSeparatedByString:@"."].firstObject,function,lineNum];
    NSString *logMessage = [NSString stringWithFormat:@"\n%@",message];
    NSString *logFooter = @"\n-----------------👆LoggerInfo Tool👆-------------------";
    
    NSMutableString *logInfo = [[NSMutableString alloc] initWithString:logHeader];
    [logInfo appendString:baseInfo];
    [logInfo appendString:logMessage];
    [logInfo appendString:logFooter];
    
    NSLog(@"%@",logInfo);
    
    if (save) {
        [self saveLoggerInfoToPlistPathWithLogTime:time fileName:fileName level:level function:function lineNum:lineNum onEvent:event logMessage:message];
    }
}

-(void)removeAllLoggerInfo{
    
}

#pragma mark - privateMethod                - Method -
-(void)saveLoggerInfoToPlistPathWithLogTime:(NSString *)time fileName:(NSString *)fileName level:(kDebugLogInfoLevel)level function:(NSString *)function lineNum:(NSInteger)lineNum onEvent:(NSString *)event logMessage:(NSString *)message{
    
    NSString *curDate = [self currentDate];

    NSString *curPlistPath = [[self debugLoggerDocumentPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",curDate]];
    
    NSLog(@"%@",curPlistPath);
    //清除plist文件，可以根据我上面讲的方式进去本地查看plist文件是否被清除
    NSFileManager *fileMger = [NSFileManager defaultManager];
    //写入数据到plist文件
    NSMutableDictionary *writeInfoDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:time,@"logTime",fileName,@"fileName",function,@"method",@(lineNum),@"lineNum",message,@"logMessage",@(level),@"LogLevel",nil];
    NSString *baseInfo = [NSString stringWithFormat:@"[%@]-[%@]-[第%ld行]",[fileName componentsSeparatedByString:@"."].firstObject,function,lineNum];
    if ([fileMger fileExistsAtPath:curPlistPath]) {
        NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:curPlistPath];
        if ([dataDictionary.allKeys containsObject:baseInfo]) {
            NSMutableArray *infoArray = [dataDictionary objectForKey:baseInfo];
            /** 只保留最近7条数据 */
            if (infoArray.count >= self.maxNumTimeOfLogger) {
                [infoArray replaceObjectAtIndex:0 withObject:writeInfoDic];
            }else{
                [infoArray insertObject:writeInfoDic atIndex:0];
            }
             [dataDictionary setObject:infoArray forKey:baseInfo];
        }else{
            NSMutableArray *infoArray = [NSMutableArray array];
            [infoArray addObject:writeInfoDic];
            [dataDictionary setObject:infoArray forKey:baseInfo];
        }
        [dataDictionary writeToFile:curPlistPath atomically:YES];
    }else{
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
        NSMutableArray *infoArray = [NSMutableArray array];
        [infoArray insertObject:writeInfoDic atIndex:0];
        [dataDic setObject:infoArray forKey:baseInfo];
        [dataDic writeToFile:curPlistPath atomically:YES];
    }
}

-(NSString *)debugLoggerDocumentPath{
     // 默认路径在沙盒的Library/Caches/DWDebugLoggerDocument/目录下
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *baseDir = paths.firstObject;
    NSString *logsDirectory = [baseDir stringByAppendingPathComponent:@"DWDebugLoggerDocument"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:logsDirectory]) {
        NSError *err = nil;
        
        if (![[NSFileManager defaultManager] createDirectoryAtPath:logsDirectory
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&err]) {
            NSLog(@"无法创建文件夹 logsDirectory: %@", err);
        }
    }

    return logsDirectory;
}

/** 获取当天日期 */
-(NSString *)currentDate{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    
    return currentDateString;
}

#pragma mark - getters and setters          - Method -
-(void)setMaxNumTimeOfLogger:(NSInteger)maxNumTimeOfLogger{
    _maxNumTimeOfLogger = maxNumTimeOfLogger;
    
}

-(void)setMaxNumDayOfLogFiles:(NSInteger)maxNumDayOfLogFiles{
    
    _maxNumDayOfLogFiles = maxNumDayOfLogFiles;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *filesArr = [fileManager contentsOfDirectoryAtPath:[self debugLoggerDocumentPath] error:nil];
    if (filesArr.count > 0) {
        NSMutableArray *filePathArray = [[NSMutableArray alloc]init];   //用来存目录名字的数组
        [filesArr enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([[file pathExtension] isEqualToString:@"plist"])  //取得后缀名为.plist的文件名
            {
                [filePathArray addObject:file];//存到数组
            }
        }];
        
        if (filePathArray.count > maxNumDayOfLogFiles) {
           [filePathArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
               NSString *fileName = [obj1 componentsSeparatedByString:@"."].firstObject;
               NSString *fileName1 = [obj2 componentsSeparatedByString:@"."].firstObject;
               NSInteger num1 = [fileName integerValue];
               NSInteger num2 = [fileName1 integerValue];
               if (num1 > num2) {
                   return NSOrderedAscending;
               }else{
                   return NSOrderedDescending;
               }
               return NSOrderedSame;
            }];
            
            NSLog(@"%@",filePathArray);
            [fileManager removeItemAtPath:[[self debugLoggerDocumentPath] stringByAppendingPathComponent:filePathArray.lastObject] error:NULL];
        }
    }
}

@end
