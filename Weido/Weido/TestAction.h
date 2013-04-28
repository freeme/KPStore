//
//  TestAction.h
//  Weido
//
//  Created by He baochen on 13-3-29.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Project.h"
#import "BTSingleOperationQueue.h"
@interface TestAction : NSObject {
  BTSingleOperationQueue *_opQueue;
  
}
- (void)test1 ;
- (void)test2;

- (void)test3;
- (void)test4;
@end
