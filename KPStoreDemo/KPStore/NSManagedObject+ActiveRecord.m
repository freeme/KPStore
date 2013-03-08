//
//  NSManagedObject+ActiveRecord.m
//  KPStore
//
//  Created by He baochen on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObject+ActiveRecord.h"
#import "KPStore.h"

@implementation NSManagedObject (ActiveRecord)

+ (NSString*)entityName {
  return NSStringFromClass([self class]);
}

+ (NSFetchRequest*)defaultFetchRequest{
  NSManagedObjectContext *context = [self contextForCurrentThread];
  return [self fetchRequestInContext:context];
}

+ (NSFetchRequest*)fetchRequestInContext:(NSManagedObjectContext*)context {
	NSFetchRequest* fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	return fetchRequest;
}

+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error {
  return [[self contextForCurrentThread] executeFetchRequest:request error:error];
}

+ (NSArray *)findAllOnLimit:(NSUInteger)theLimit
					  error:(NSError **)anError {
	NSFetchRequest* fetchRequest = [self defaultFetchRequest];
	[fetchRequest setFetchLimit:theLimit];
	return [self executeFetchRequest:fetchRequest
							   error:anError];
}

+ (NSArray*)findAllWithError:(NSError **)error {
  return [self findAllSortByKey:nil ascending:YES error:error];
}

+ (NSArray*)findAllSortByKey:(NSString*)sortKey ascending:(BOOL)ascending error:(NSError **)error {
  NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [[self currentStore] entityForName:[self entityName]];
  [fetchRequest setEntity:entity];
  if (sortKey) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey
                                                                   ascending:ascending];
    [fetchRequest setSortDescriptors: [NSArray arrayWithObject:sortDescriptor]];
    [sortDescriptor release];
  }
  NSArray *array = [[self currentStore] executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return array;
}


+ (id)createNewObject {
  id newObject = nil;
  newObject = [[self currentStore] insertNewObjectForEntityForName:[self entityName]];
  return newObject;
}

+ (void)deleteAllObjects {
	NSArray *objects = [self findAllWithError:nil];
	for (NSManagedObject *o in objects) {
		[o deleteSelf];
	}
  //Gary to not call save in this class
	//[self save];
}

+ (void) deleteObjectByID:(NSManagedObjectID*)objectID {
  [[self currentStore] deleteObjectByID:objectID];
}


- (void) deleteSelf {
  if ([NSThread isMainThread]) {
    [self deleteInContext:[self managedObjectContext]];
  } else {
    [[self class] deleteObjectByID:[self objectID]];
  }
}
- (void) save {
  [KPStore saveContext:[self managedObjectContext]];
}

+ (void)save {
	[KPStore saveContext:[self contextForCurrentThread]];
}


- (BOOL) deleteInContext:(NSManagedObjectContext *)context
{
	[context deleteObject:self];
	return YES;
}

+ (BOOL) deleteAllMatchingPredicate:(NSPredicate *)predicate {
  NSManagedObjectContext *context = [self contextForCurrentThread];
  NSFetchRequest *request = [self fetchRequestInContext:context];
  [request setPredicate:predicate];
  [request setReturnsObjectsAsFaults:YES];
	[request setIncludesPropertyValues:NO];
  
	NSArray *objectsToDelete = [context executeFetchRequest:request error:nil];
  
	for (NSManagedObject* objectToDelete in objectsToDelete) {
		[context deleteObject:objectToDelete];
  }
  
	return YES;
}


          
+ (NSManagedObjectContext *) contextForCurrentThread {
   return [KPStore storeForObject:[self class]].managedObjectContext;
}

+ (KPStore *) currentStore {
  return [KPStore storeForObject:[self class]];
}

@end
