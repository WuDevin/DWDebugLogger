//
//  DWDebugLogModel.h
//  DWAppProject
//
//  Created by lg on 2018/12/4.
//  Copyright © 2018 DevinWu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWDebugLogModel : NSObject

/** 文件名 */
@property (nonatomic,copy,readonly) NSString *fileName;
/** Debug行数 */
@property (nonatomic,assign,readonly) NSInteger lineNum;
/** 方法名称 */
@property (nonatomic,strong,readonly) NSString *functionName;
/** 打印类型 */
@property (nonatomic,assign,readonly) NSInteger LoggerType;
/** 事件 */
@property (nonatomic,copy,readonly) NSString *event;
/** 打印时间 */
@property (nonatomic,copy,readonly) NSString *logTime;
/** 运行时间 */
@property (nonatomic , copy , readonly) NSString *launchTime;
/** 标识 */
@property (nonatomic,copy) NSString *identify;

@end

@interface DWDebugLogRequestModel :DWDebugLogModel

@property (nonatomic,copy) NSString *url;//请求路径
@property (nonatomic,copy) NSString *params;//请求参数
@property (nonatomic,copy) NSString *responseObject;//返回数据
@property (nonatomic,copy) NSString *error;//是否有错误

@end
