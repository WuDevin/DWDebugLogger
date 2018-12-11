//
//  DWDebugLoggerMacro.h
//  DWAppProject
//
//  Created by lg on 2018/12/6.
//  Copyright © 2018 DevinWu. All rights reserved.
//

#ifndef DWDebugLoggerMacro_h
#define DWDebugLoggerMacro_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DWDebugLogHelper.h"

#define DWLog(fmt,...)   [[DWDebugLogHelper sharedInstance] logAtTime:[NSString stringWithUTF8String:__TIME__] fileName:[[NSString stringWithUTF8String:__FILE__] lastPathComponent] level:kDebugLogInfoLevel_Defalut function:NSStringFromSelector(_cmd) lineNum:__LINE__ onEvent:@"" logMessage:(fmt, ##__VA_ARGS__)]

#endif /* DWDebugLoggerMacro_h */
