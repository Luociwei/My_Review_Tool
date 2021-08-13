//
//  OC_Regular.m
//  Atlas2_Analysis_Tool
//
//  Created by ciwei luo on 2021/6/22.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "RegularVC.h"
#import "LuaScriptCore.h"
@interface RegularVC ()
@property (unsafe_unretained) IBOutlet NSTextView *contentView;

@property (weak) IBOutlet NSTextField *patternView;
@property (unsafe_unretained) IBOutlet NSTextView *resultView;
@property(nonatomic, strong) LSCContext *context;
@end

@implementation RegularVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.contentView.string =@"-----\\J407\\diag-pallas-44.06.81.bin----\\J408\\diag-pallas-48.05.82.bin--\\J409\\diag-pallas-41.02.84.bin";
    if ([self.title.lowercaseString containsString:@"lua"]) {
        self.context = [[LSCContext alloc] init];
        
        //捕获异常
        [self.context onException:^(NSString *message) {
            
            NSLog(@"error = %@", message);
            
        }];
        self.patternView.stringValue= @"diag%-pallas%-([%d%.]+).bin";
    }else{
       self.patternView.stringValue= @"diag-pallas-([\\d.]+)bin";
    }
    
//    self.resultVIew
    
    [self patternClick:nil];
    
}

- (IBAction)patternClick:(id)sender {
//    NSString *content = @"\\J407\\diag-pallas-44.06.81.bin----\\J408\\diag-pallas-48.05.82.bin--\\J409\\diag-pallas-41.02.84.bin";
//    NSString *pattern = @"diag-pallas-([\\d.]+)bin";
    self.resultView.string = @"";
    NSString *content = [NSString stringWithFormat:@"%@",self.contentView.string];
    NSString *pattern = [NSString stringWithFormat:@"%@",self.patternView.stringValue];
    if ([self.title.lowercaseString containsString:@"lua"]) {
        //加载Lua脚本
        [self.context
         evalScriptFromFile:[[NSBundle mainBundle] pathForResource:@"LuaRegularTest"
                                                            ofType:@"lua"]];
        
        //调用Lua方法
//        LSCValue *value = [self.context callMethodWithName:@"add"
//                                                 arguments:@[
//                                                             [LSCValue integerValue:1000],
//                                                             [LSCValue integerValue:24]
//                                                             ]];
//
//
//        NSLog(@"result = %@", [value toNumber]);
        
        LSCValue *value1 = [self.context callMethodWithName:@"regular"
                                                  arguments:@[
                                                              [LSCValue stringValue:content],
                                                              [LSCValue stringValue:pattern]
                                                              ]];
        
        
//        NSLog(@"result = %@", [value1 toString]);
//        NSLog(@"result = %@", [value toNumber]);
//        XCTAssertNotNil(resValue, "result value is nil");
        if (value1) {
            self.resultView.string =[value1 toString];
        }
        
    }else{
        NSError *err = nil;
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
        NSArray *results = [regular matchesInString:content options:0 range:NSMakeRange(0,content.length)];
        NSMutableArray *resultsArr = [[NSMutableArray alloc]init];
        for (NSTextCheckingResult *result in results) {
            NSMutableArray *resultArr = [[NSMutableArray alloc]init];
            NSInteger rangesCount = result.numberOfRanges;
            for (int i =0; i<rangesCount; i++) {
                NSRange range = [result rangeAtIndex:i];
                NSString *resultString =[content substringWithRange:range];
                [resultArr addObject:resultString];
            }
            [resultsArr addObject:resultArr];
            
        }
        NSMutableString *resultMutStr = [[NSMutableString alloc]initWithString:@""];
        if (resultsArr.count) {
            for (int i =0; i<resultsArr.count; i++) {
                NSArray *resultArr = resultsArr[i];
                if (resultArr.count) {
                    for (int j =0; j<resultArr.count; j++) {
                        NSString *sub_result =[NSString stringWithFormat:@"results[%d][%d]:%@\n",i+1,j+1,resultArr[j]] ;
                        
                        [resultMutStr appendString:sub_result];
                        
                    }
                }
                
            }
        }
        
        self.resultView.string =resultMutStr;
        
    }
    
    NSLog(@"11");
}



-(void)test1{
    NSString *content = @"\\J407\\diag-pallas-44.06.81.bin----\\J408\\diag-pallas-48.05.82.bin--\\J409\\diag-pallas-41.02.84.bin";
    NSString *pattern = @"diag-pallas-([\\d.]+)bin";
    //    NSString *pattern = @"a";
    NSError *err = nil;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&err];
    NSArray *results = [regular matchesInString:content options:0 range:NSMakeRange(0,content.length)];
    NSMutableArray *resultsArr = [[NSMutableArray alloc]init];
    for (NSTextCheckingResult *result in results) {
        NSMutableArray *resultArr = [[NSMutableArray alloc]init];
        NSInteger rangesCount = result.numberOfRanges;
        for (int i =0; i<rangesCount; i++) {
            NSRange range = [result rangeAtIndex:i];
            NSString *resultString =[content substringWithRange:range];
            [resultArr addObject:resultString];
        }
        [resultsArr addObject:resultArr];
        
    }
}

@end