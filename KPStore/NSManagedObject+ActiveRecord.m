//
//  NSManagedObject+ActiveRecord.m
//  KPStore
//
//  Created by He baochen on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"
#import "KPStore.h"
#import "BTCoreDataStore.h"

static BTCoreDataStore *__store = nil;

@implementation NSManagedObject (Base)
+ (void)setStore:(BTCoreDataStore*)store {
  __store = store;
}
+ (BTCoreDataStore*)store {
  if (!__store) {
    __store = [BTCoreDataStore mainStore];
  }
  return __store;
}
+ (NSString*)entityName {
  return NSStringFromClass([self class]);
}

+ (NSManagedObjectContext *) contextForCurrentThread {
  return [[self store] mocForCurrentThread];
}

+ (NSFetchRequest*)defaultFetchRequest{
  NSFetchRequest *request = [self fetchRequestWithPredicate:nil fetchLimit:0 sortDescriptors:nil];
  return request;
}

+ (NSFetchRequest*)fetchRequestWithPredicate:(NSPredicate*)predicate fetchLimit:(NSUInteger)limit sortDescriptors:(NSArray *)sortDescriptors {
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
  if (predicate) {
    [request setPredicate:predicate];
  }
  if (limit > 0) {
    [request setFetchLimit:limit];
  }
  if (sortDescriptors) {
      [request setSortDescriptors:sortDescriptors];
  }
  return request;
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error {
  return [[self contextForCurrentThread] executeFetchRequest:request error:error];
}
/**
 获得调用该方法的线程所对应的ManagedObjectContext，来Save
 */
+ (void)save {
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSError *error = [BTCoreDataStore saveContext:context];
  if (error && error.code == 133020) {
     
  }
}

+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate {
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSFetchRequest *request = [self defaultFetchRequest];
  [request setPredicate:predicate];
  [request setReturnsObjectsAsFaults:YES];
	[request setIncludesPropertyValues:NO];
	NSArray *objectsToDelete = [context executeFetchRequest:request error:nil];
  
	for (NSManagedObject* objectToDelete in objectsToDelete) {
		[context deleteObject:objectToDelete];
  }
	return YES;
}

+ (NSArray*)findAllMatchingPredicate:(NSPredicate*)predicate fetchLimit:(NSUInteger)limit sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error{
  NSArray *results = nil;
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSFetchRequest *request = [self fetchRequestWithPredicate:predicate fetchLimit:limit sortDescriptors:sortDescriptors];
  results = [context executeFetchRequest:request error:error];
  return results;
}

+ (NSArray*)findAllWithFetchLimit:(NSUInteger)limit sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error{
  NSArray *results = nil;
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSFetchRequest *request = [self fetchRequestWithPredicate:nil fetchLimit:limit sortDescriptors:sortDescriptors];
  results = [context executeFetchRequest:request error:error];
  return results;
}

+ (NSArray*)findByProperty:(NSString *)property value:(NSObject*)value fetchLimit:(NSUInteger)limit sortDescriptors:(NSArray *)sortDescriptors error:(NSError **)error{
  NSArray *results = nil;
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSFetchRequest *request = [self fetchRequestWithPredicate:[NSPredicate predicateWithFormat:@"%@ == %@",property,value] fetchLimit:limit sortDescriptors:sortDescriptors];
  results = [context executeFetchRequest:request error:error];
  return results;
}

+ (NSInteger)countForRequest:(NSFetchRequest*)request {
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSInteger count = [context countForFetchRequest:request error:NUlL];
  return count;
}

@end

@implementation NSManagedObject (ActiveRecord)

+ (NSManagedObject*)createNewObject {
  NSManagedObject *newObject = nil;
  NSManagedObjectContext *context = [self contextForCurrentThread];
  newObject = [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                            inManagedObjectContext:context];
  return newObject;
}

+ (NSArray*)findAllWithFetchLimit:(NSUInteger)limit error:(NSError **)error {
  return [self findAllWithFetchLimit:limit sortDescriptors:nil error:error];
}

+ (NSManagedObject*)findByID:(NSManagedObjectID*)objectID error:(NSError **)error {
//  NSArray *results = [self findByProperty:@"self" value:objectID fetchLimit:1 sortDescriptors:nil error:error];
//  if ([results count] > 0) {
//    return [results objectAtIndex:0];
//  }
  //TODO: test
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSManagedObject *object = [context existingObjectWithID:objectID error:NULL];
  return object;
}

+ (NSArray*)findByProperty:(NSString *)property value:(NSObject*)value error:(NSError **)error {
  NSArray *results = [self findByProperty:property value:value fetchLimit:0 sortDescriptors:nil error:error];
  return results;
}

+ (void)deleteAllObjects {
  [self deleteAllMatchingPredicate:nil];
}

+ (void) deleteObjectByID:(NSManagedObjectID*)objectID {
  NSManagedObjectContext *context = [self contextForCurrentThread];
  
  /* returns the object for the specified ID if it is already registered, otherwise it creates a fault corresponding to that objectID.  It never returns nil, and never performs I/O.  The object specified by objectID is assumed to exist, and if that assumption is wrong the fault may throw an exception when used. */
  
  //TODO: test on second thread
  NSManagedObject *object = [context objectWithID:objectID];
  
  /* returns the object for the specified ID if it is already registered in the context, or faults the object into the context.  It might perform I/O if the data is uncached.  If the object cannot be fetched, or does not exist, or cannot be faulted, it returns nil.  Unlike -objectWithID: it never returns a fault.  */
  
  //TODO: test 与上面有和区别
  //NSManagedObject *object = [context existingObjectWithID:objectID error:NULL];
  if (object) {
    [context deleteObject:object];
  }
}


- (void) deleteSelf {
  if ([NSThread isMainThread]) {
    [[self managedObjectContext] deleteObject:self];
  } else {
    [[self class] deleteObjectByID:[self objectID]];
  }
}
- (void) save {
  NSError *error = [BTCoreDataStore saveContext:[self managedObjectContext]];
}

@end


