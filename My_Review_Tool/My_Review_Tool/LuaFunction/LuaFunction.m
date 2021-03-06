//
//  LuaFunction.m
//  My_Review_Tool
//
//  Created by ciwei luo on 2021/5/11.
//  Copyright © 2021 Suncode. All rights reserved.
//

#import "LuaFunction.h"

@interface LuaFunction ()
//@property (nonatomic,strong)TextView *textView;
@property (unsafe_unretained) IBOutlet NSTextView *textFuncView;

@end

@implementation LuaFunction

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.textFuncView.usesFindPanel = YES;
    // Do view setup here.
    //self.textView = [[TextView alloc]init];
    //    self.textView = [TextView cw_allocInitWithFrame:self.view.bounds];
    //[self.view addSubview:self.textView];
    //    self.textView1.frame = self.view.bounds;
    //[self setupAutolayout];
    
//    self.textFuncView.usesFindBar = YES;
}

-(void)setLuaFunctionPath:(NSString *)luaFuncPath{
    self.textFuncView.string = @"";
    if (luaFuncPath.length) {
        _luaFunctionPath = luaFuncPath;
        NSString *content = [FileManager cw_readFromFile:luaFuncPath];
        NSRange range = [content rangeOfString:self.luaFunctionName];
        //        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:content];
        //        [noteStr addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:range];
        
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [NSThread sleepForTimeInterval:1];
        //                [self.textFuncView.string rangeOfString:self.luaFunctionName];
        self.textFuncView.string = content;
        [[_textFuncView textStorage] setFont:[NSFont fontWithName:@"Menlo" size:15]];
        [self.textFuncView setSelectedRange:range];
        //                [noteStr addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:range];
        [self.textFuncView scrollRangeToVisible:range];
        
        //            });
        //        });
        
        //        NSString *cmd = [NSString stringWithFormat:@"grep \",FAIL,\" %@",recordPath];
        //        NSString *log = [Task cw_termialWithCmd:cmd];
        //        [self.textView showLog:[NSString stringWithFormat:@"%@\n%@",recordPath,log]];
    }
}

//- (void)setupAutolayout {
//
//    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        // 添加大小约束
//        make.left.and.top.and.bottom.and.right.mas_equalTo(0);
//
//    }];
//}

- (IBAction)performChanges:(NSButton *)btn {
    [FileManager cw_removeItemAtPath:_luaFunctionPath];
    NSString *content = self.textFuncView.string;
    [FileManager cw_writeToFile:_luaFunctionPath content:content];
}


@end
