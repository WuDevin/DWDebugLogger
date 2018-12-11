//
//  DWDebugLogHelper.h
//  DWAppProject
//
//  Created by lg on 2018/12/4.
//  Copyright © 2018 DevinWu. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef NS_ENUM(NSInteger, kDebugLogInfoLevel) {
    
    kDebugLogInfoLevel_Defalut = 0,//默认
    kDebugLogInfoLevel_Alert,//提示
    kDebugLogInfoLevel_Warning,//警告
    kDebugLogInfoLevel_Error,//错误
};

@interface DWDebugLogHelper : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic,assign) NSInteger maxNumDayOfLogFiles;//保存文件天数
@property (nonatomic,assign) NSInteger maxNumTimeOfLogger;//每个打印信息保存的最大次数


-(void)logAtTime:(NSString *)time fileName:(NSString *)fileName level:(kDebugLogInfoLevel)level  function:(NSString *)function lineNum:(NSInteger)lineNum onEvent:(NSString *)event logMessage:(NSString *)message;

-(void)logAtTime:(NSString *)time fileName:(NSString *)fileName level:(kDebugLogInfoLevel)level  function:(NSString *)function lineNum:(NSInteger)lineNum onEvent:(NSString *)event logMessage:(NSString *)message saveToFile:(BOOL)save;

-(NSString *)debugLoggerDocumentPath;

/** 清除所有log信息 */
-(void)removeAllLoggerInfo;


@end
