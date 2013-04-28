//
//  NSManagedObject+ActiveRecord.h
//  KPStore
//
//  Created by He baochen on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
@class BTCoreDataStore;
@interface NSManagedObject (Base)
/**
 DO NOT USE CALL THIS IN YOUR CODE
 */
+ (void)setStore:(BTCoreDataStore*)store;
+ (BTCoreDataStore*)store;
+ (NSString*)entityName;
+ (NSManagedObjectContext *) contextForCurrentThread;
+ (NSFetchRequest*)defaultFetchRequest;
+ (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error;
/**
 获得调用该方法的线程所对应的ManagedObjectContext，来Save
 */
+ (void)save;
+ (BOOL)deleteAllMatchingPredicate:(NSPredicate *)predicate;

@end


@interface NSManagedObject (ActiveRecord)


//创新一个新对象
+ (id)createNewObject;
//查找该类型对象的全部数据
+ (NSArray*)findAllWithFetchLimit:(NSUInteger)limit error:(NSError **)error;
+ (NSManagedObject*)findByID:(NSManagedObjectID*)objectID error:(NSError **)error;
+ (NSArray*)findByProperty:(NSString *)property value:(NSObject*)value error:(NSError **)error;
+ (void)deleteAllObjects;
+ (void)deleteObjectByID:(NSManagedObjectID*)objectID;
/**
 在主线程中调用时，直接使用对象当前所在的managedObjectContext
 */
- (void)deleteSelf;
/**
 获得当前对象所绑定的ManagedObjectContext，来Save
 */
- (void) save;
@end


