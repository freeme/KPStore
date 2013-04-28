//
//  BTBlockOperationManager.m
//  AABabyTing3
//
//  Created by Tiny on 13-3-8.
//
//

#import "BTSingleOperationQueue.h"

static BTSingleOperationQueue *sharedQueue;

@implementation BTSingleOperationQueue

- (void)dealloc {
    [super dealloc];
}

+ (void)initialize {
    @synchronized(self){
        if (sharedQueue == nil){
            sharedQueue = [[BTSingleOperationQueue alloc] init];
            [sharedQueue setMaxConcurrentOperationCount:1];
        }
    }
}


+ (void)destoryQueue{
    if (sharedQueue){
        [sharedQueue release];
        sharedQueue = nil;
    }
}

+ (NSBlockOperation* ) operationWithBlock:(void (^)(void))runBlock completion:(void (^)(void))completionBlock{
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:runBlock];
    if(completionBlock!=nil){
        [blockOperation setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock();
            });
        }];
    }
    return blockOperation;
}

+ (void) addOperation:(NSOperation*) operation {
    [sharedQueue addOperation:operation];
}

@end
