//
//  LuaScript.h
//  Lua
//
//  Created by Amir Malik on 1/27/12.
//  Copyright (c) 2012 Amir Malik. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "lua.h"
//#import "lauxlib.h"
//#import "lualib.h"
@interface LuaScript : NSObject {
    NSString *scriptPath;
    NSString *packagePath;
    NSString *packageCpath;
}
+ (LuaScript *)luaScriptWithContentsOfFile:(NSString *)path;
- (void)run;
- (id)callFunction:(NSString *)aName withArguments:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION;

@property (nonatomic, retain) NSString *scriptPath;
@property (nonatomic, retain) NSString *packagePath;
@property (nonatomic, retain) NSString *packageCpath;

@end
