//
//  FetchRequestFactory.h
//  Todo
//
//  Created by He baochen on 12-2-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FetchRequestFactory : NSObject

+ (NSFetchRequest*) inboxTaskFetchRequest;
+ (NSFetchRequest*) todayTaskFetchRequest;
+ (NSFetchRequest*) defaultProjectFetchRequest;
+ (NSFetchRequest*) finishTaskFetchRequest;
@end
