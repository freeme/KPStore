//
//  TestAction.m
//  Weido
//
//  Created by He baochen on 13-3-29.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import "TestAction.h"
#import "Project+Actions.h"
#import "Project.h"
#import "Tag.h"
#import "Task.h"

@implementation TestAction

- (id)init {
  self = [super init];
  if (self) {
    _opQueue = [[BTSingleOperationQueue alloc] init];
  }
  return self;
}

//Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Illegal attempt to establish a relationship 'project' between objects in different contexts
- (void)test1 {
  _p1 = [Project createNewObject];
  [_p1 save];
  NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
    Task *task1 = [Task createNewObject];
    [_p1 addTasksObject:task1];
    [task1 save];
  }];
  [op setCompletionBlock:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"p1=%@",_p1);
    });
  }];
  [_opQueue addOperation:op];

}
static Project *_p1 = nil;
- (void)test2 {
  if (_p1 == nil) {
    _p1 = [[Project createNewObject] retain];
    _p1.name = @"project";
    [_p1 save];
  }

  NSLog(@"p1=%@",_p1);
  NSManagedObjectID *objID = [_p1.objectID copy];
  NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
    Project* tempP1 = [Project findByID:objID];
    NSLog(@"p1=%@",tempP1);
    NSLog(@"p1=%@",tempP1.name);
    Task *task1 = [Task createNewObject];
    [tempP1 addTasksObject:task1];
    [task1 save];
    
    [task1 deleteSelf];
    
    [Task save];
  }];
  [op setCompletionBlock:^{
    dispatch_async(dispatch_get_main_queue(), ^{
      NSLog(@"---------------------------------");
//      _p1.tasks;
//      NSLog(@"p1=%@",_p1);
////      Project* tempP2 = [Project findByID:_p1.objectID];
////      NSLog(@"p2=%@",tempP2.name);
//      NSLog(@"_p1.tasks=%@",_p1.tasks);
      NSSet *tasks = _p1.tasks;
      for (Task* task in tasks) {
        NSLog(@"task=%@",task);
      }
    });
  }];
  [_opQueue addOperation:op];
  
}

//NSBlockOperation *op = [_opQueue operationWithBlock:^{
//  
//} completion:^{
//  
//}];
- (void)test3 {
  __block Project *p1 = [Project createNewObject];
  p1.name = @"project old name";
  [p1 save];
  NSLog(@"[1 save];");
  NSBlockOperation *op = [BTSingleOperationQueue operationWithBlock:^{
    Project *p2 = (Project*)[Project findByID:p1.objectID error:NULL];
    p2.name = @"project new name";
    [p2 save];
    //NSLog(@"[p2 save];");
  } completion:^{
    
  }];
  [_opQueue addOperation:op];
  [NSThread sleepForTimeInterval:1];
  p1.name = @"project new name1";
  p1.isFinish = [NSNumber numberWithBool:YES];
  [p1 save];
  NSLog(@"[12 save];");
}

- (void)test4 {
  __block Project *p1 = [Project createNewObject];
  p1.name = @"project old name";
  [p1 save];
  NSLog(@"[1 save];");
  NSBlockOperation *op = [BTSingleOperationQueue operationWithBlock:^{
    Project *p2 = (Project*)[Project findByID:p1.objectID error:NULL];
    p2.name = @"project new name";
    [p2 save];
    //NSLog(@"[p2 save];");
  } completion:^{
    
  }];
  [_opQueue addOperation:op];
  [NSThread sleepForTimeInterval:1];
  p1.name = @"project new name1";
  p1.isFinish = [NSNumber numberWithBool:YES];
  [p1 save];
  NSLog(@"[12 save];p1.name = %@", p1.name);
  
  Project *p3 = (Project*)[Project findByID:p1.objectID error:NULL];
  NSLog(@"[3 ];p3.name = %@", p3.name);
  
  
}
@end
