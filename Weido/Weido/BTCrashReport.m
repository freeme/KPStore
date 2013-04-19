//
//  BTCrashReport.m
//  ZTCrashReport
//
//  Created by Zero on 3/29/13.
//  Copyright (c) 2013 21kunpeng. All rights reserved.
//

#import "BTCrashReport.h"
#import <Foundation/NSException.h>

void WriteCrashLogToFile(NSDictionary* dic);

static int s_fatal_signals[] = {
    SIGABRT,
    SIGBUS,
    SIGFPE,
    SIGILL,
    SIGSEGV,
    SIGTRAP,
	SIGTERM,
	SIGKILL,
};

static const char* s_fatal_signal_names[] = {
	"SIGABRT",
	"SIGBUS",
	"SIGFPE",
	"SIGILL",
	"SIGSEGV",
	"SIGTRAP",
	"SIGTERM",
	"SIGKILL",
};

static int s_fatal_signal_num = sizeof(s_fatal_signals) / sizeof(s_fatal_signals[0]);

void SignalHandler(int sig) {
	for (int i=0; i<s_fatal_signal_num; i++) {
		if (sig == s_fatal_signals[i]) {
			NSLog(@"CatchSignal:%s(%d)",s_fatal_signal_names[i],sig);
			
			NSMutableDictionary *dic = [NSMutableDictionary dictionary];
			NSString *name = [NSString stringWithFormat:@"%s",s_fatal_signal_names[i]];
			NSString *reason = [NSString stringWithFormat:@"%d",sig];
			[dic setValue:name forKey:@"name"];
			[dic setValue:reason forKey:@"reason"];
			
			WriteCrashLogToFile(dic);
			
			break;
		}
	}
	
	
	
}

void UncaughtExceptionHandler(NSException *exception) {
	NSArray *arr = [exception callStackSymbols];
	NSString *reason = [exception reason];
	NSString *name = [exception name];
	NSLog(@"Name:%@",name);
	NSLog(@"Reason:%@",reason);
	NSLog(@"CallStackDetail:%@",arr);
	
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setValue:name forKey:@"name"];
	[dic setValue:reason forKey:@"reason"];
	[dic setValue:arr forKey:@"call_stack"];
	[dic setValue:[NSDate date] forKey:@"time_stamp"];
	
	WriteCrashLogToFile(dic);
}

#define __BT__DOCUMENTS_DIRECTORY ([( NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0])
void WriteCrashLogToFile(NSDictionary* dic) {
	NSString *path = [__BT__DOCUMENTS_DIRECTORY stringByAppendingPathComponent:@"crash.plist"];
	NSArray *array = [NSArray arrayWithContentsOfFile:path];
	NSMutableArray *newArray = [NSMutableArray arrayWithArray:array];
	if (newArray == nil) {
		newArray = [NSMutableArray array];
	}
	
	[newArray insertObject:dic atIndex:0];
	[newArray writeToFile:path atomically:YES];
}
#undef __BT__DOCUMENTS_DIRECTORY

void InitCrashReport()
{
	// 1     linux错误信号捕获
	for (int i = 0; i < s_fatal_signal_num; ++i) {
		signal(s_fatal_signals[i], SignalHandler);
	}
	
	// 2      objective-c未捕获异常的捕获
	NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

