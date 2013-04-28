//
//  BTBlockOperationManager.h
//  AABabyTing3
//
//  Created by Tiny on 13-3-8.
//
//

#import <Foundation/Foundation.h>

@interface BTSingleOperationQueue : NSOperationQueue

//+ (BTSingleOperationQueue *)sharedQueue;
+ (void)destoryQueue;

// Note: completionBlock here, always run in main thread
+ (NSBlockOperation *) operationWithBlock:(void (^)(void))runBlock completion:(void (^)(void))completionBlock;
+ (void) addOperation:(NSOperation*) operation;
@end
