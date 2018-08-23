//
//  SocketStream.m
//  SystemSocket
//
//  Created by 肖旭晖 on 2018/8/23.
//  Copyright © 2018年 [简书](https://www.jianshu.com/p/e1d8b4eb0ecd). All rights reserved.
//

//https://www.jianshu.com/p/d04197cd7751

#define HOST @"114.119.7.136"
#define PORT 5222

#import "SocketStream.h"

@interface SocketStream ()
@property (nonatomic, strong) NSInputStream *inputStream;//输入流
@property (nonatomic, strong) NSOutputStream *outputStream;//输出流
@end

static SocketStream *streamInstance = nil;

@implementation SocketStream

+(instancetype)shareInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        streamInstance = [[self alloc] init];
    });
    return streamInstance;
}

#pragma mark - 连接到主机
-(void)connectToHost{
    
    //设置流的配置信息
    NSString *host = HOST;
    uint32_t port  = PORT;
    
    //定义C语言的输入输出流
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    //与主机进行配对
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    
    //C语音输入输出流转换成OC输入输出流
    self.inputStream = (__bridge NSInputStream *)(readStream);
    self.outputStream = (__bridge NSOutputStream *)(writeStream);
    
    //设置输入输出流代理
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    
    //把输入输入流添加到主运行循环
    [self.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //打开输入输出流
    [self.inputStream open];
    [self.outputStream open];
}

#pragma mark - NSStreamDelegate(输入输出流代理)
-(void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            NSLog(@"输入输出流打开完成");
            break;
            
        case NSStreamEventHasBytesAvailable:
            NSLog(@"有字节可读");
            //读取数据
            [self readData];
            break;
            
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"可以发送字节");
            break;
            
        case NSStreamEventErrorOccurred:
            NSLog(@"连接出现错误");
            break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"连接结束");
            [self disconnect];
    
            break;
            
        default:
            break;
    }
}

-(void)disconnect{
    
    [self.inputStream close];
    [self.outputStream close];
    [self.inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}
#pragma mark - 读了服务器返回的数据
-(void)readData{
    
    //建立一个缓冲区 可以放1024个字节
    uint8_t buf[1024];
    //返回实际装的字节数
    NSInteger len = [self.inputStream read:buf maxLength:sizeof(buf)];
    //把字节数组转化成字符串
    NSData *data =[NSData dataWithBytes:buf length:len];
    //从服务器接收到的数据
    NSString *reciveString =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self receiveMessage:reciveString];
}

#pragma mark - 接收数据
-(void)receiveMessage:(NSString *)message{
    NSLog(@"接收到消息啦:%@",message);
}
#pragma mark - 发送数据
-(void)sendMessage:(NSString *)message{
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.outputStream write:data.bytes maxLength:data.length];
}





@end
