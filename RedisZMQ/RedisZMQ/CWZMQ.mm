//
//  CWZMQ.m
//  Atlas2_Review_Tool
//
//  Created by ciwei luo on 2021/12/11.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "CWZMQ.h"
#import "Client.h"
//#define  cpk_zmq_addr           @"tcp://127.0.0.1:3100"
@interface CWZMQ ()

@end


@implementation CWZMQ{
    Client *zmqClient;
//    NSString *f
}

+(void)load{
    system("/usr/bin/ulimit -n 8192");
}

-(instancetype)initWithURL:(NSString *)url{
    if (self == [super init]) {
        zmqClient = [[Client alloc] init];   // connect CPK zmq for PythonTest.py
        [zmqClient CreateRPC:url withSubscriber:nil];
        [zmqClient setTimeout:20*1000];
    }
    
    return self;
    
}

-(instancetype)initWithURL:(NSString *)url pythonFile:(NSString *)filePath{
    if (self == [super init]) {
        zmqClient = [[Client alloc] init];   // connect CPK zmq for PythonTest.py
        [zmqClient CreateRPC:url withSubscriber:nil];
        [zmqClient setTimeout:20*1000];
        
        [self lanuchPythonFile:filePath];
    }
    
    return self;
    
}

-(instancetype)initWithURL:(NSString *)url pythonFile:(NSString *)filePath launchPath:(NSString *)launchPath{
    if (self == [super init]) {
        zmqClient = [[Client alloc] init];   // connect CPK zmq for PythonTest.py
        [zmqClient CreateRPC:url withSubscriber:nil];
        [zmqClient setTimeout:20*1000];
        
        [self lanuchPythonFile:filePath launchPath:launchPath];
    }
    
    return self;
    
}

-(void)lanuchPythonFile:(NSString *)filePath launchPath:(NSString *)launchPath{
    
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
//    NSString * launchPath = [resourcePath stringByAppendingString:@"/Python/NewEnv/pythonProject/bin/python3.10"];
    
    NSString * arg = [resourcePath stringByAppendingPathComponent:@"/Python/pythonProject/main.py"];
    NSString *logCmd = @"ps -ef |grep -i python |grep -i main.py |grep -v grep|awk '{print $2}' | xargs kill -9";
    system([logCmd UTF8String]); //杀掉PythonTest.py 进程
    [self execute_withTask:launchPath withPython:arg];
    
}


-(void)lanuchPythonFile:(NSString *)filePath{
    
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString * launchPath = [resourcePath stringByAppendingString:@"/Python/NewEnv/pythonProject/bin/python3.10"];
    
    NSString * arg = [resourcePath stringByAppendingPathComponent:@"/Python/pythonProject/main.py"];
    NSString *logCmd = @"ps -ef |grep -i python |grep -i main.py |grep -v grep|awk '{print $2}' | xargs kill -9";
    system([logCmd UTF8String]); //杀掉PythonTest.py 进程
    [self execute_withTask:launchPath withPython:arg];
    
}



-(int)execute_withTask:(NSString*) szcmd withPython:(NSString *)arg{
    
    if (!szcmd) return -1;
    NSTask * task = [[NSTask alloc] init];
    [task setLaunchPath:szcmd];
    [task setArguments:[NSArray arrayWithObjects:arg, nil]];
    [task launch];
    return 0;
}



-(BOOL)send:(NSString *)msg{
    return [zmqClient SendCmd:msg] > 0;
}


-(NSString *)read{
    NSString * response = [zmqClient RecvRquest:1024];
    return response;
}

-(NSString *)sendRead:(NSString *)msg{
    if ([self send:msg]) {
        NSString * response = [self read];
        return response.length ? response : @"";
    }else{
        return @"";
    }
}

+(void)shutdown{
    NSString *logCmd = @"ps -ef |grep -i python |grep -i main.py |grep -v grep|awk '{print $2}' | xargs kill -9";
    system([logCmd UTF8String]); //杀掉PythonTest.py 进程
}



@end
