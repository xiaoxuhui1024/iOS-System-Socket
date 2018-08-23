//
//  SocketStream.h
//  SystemSocket
//
//  Created by 肖旭晖 on 2018/8/23.
//  Copyright © 2018年 [简书](https://www.jianshu.com/p/e1d8b4eb0ecd). All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SocketStream : NSObject <NSStreamDelegate>

+(instancetype)shareInstance;

-(void)connectToHost;//连接到主机

-(void)disconnect;//主机断开链接

-(void)receiveMessage:(NSString *)message;//接收数据

-(void)sendMessage:(NSString *)message;//发送数据

@end

