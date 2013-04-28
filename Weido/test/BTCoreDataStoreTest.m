//
//  BTCoreDataStoreTest.m
//  Weido
//
//  Created by He baochen on 13-4-27.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 
#import "BTCoreDataStore.h"
@interface BTCoreDataStoreTest : GHTestCase { }

@end

@implementation BTCoreDataStoreTest

- (void)testInit {
  BTCoreDataStore *mainStore = [BTCoreDataStore mainStore];
  GHAssertNotNULL(mainStore, nil);
  NSManagedObjectContext *currentContext = [mainStore mocForCurrentThread];
  GHAssertNotNULL(currentContext, nil);
}

@end
