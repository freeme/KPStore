//
//  BTCoreDataStore.h
//  Weido
//
//  Created by He baochen on 13-4-19.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 使用说明：
 1. 在新工程中使用的时候，需要先修改 MODEL_FILE_NAME, 例如model文件名为 Hello.xcdatamodeld，MODEL_FILE_NAME 需要指定为Hello
 
 */
#define MAIN_MODEL_FILE_NAME @"Weido"
#ifndef MAIN_MODEL_FILE_NAME
#warning please define MAIN_MODEL_FILE_NAME
#endif



@interface BTCoreDataStore : NSObject {
  NSManagedObjectContext *_mainThreadManagedObjectContext;
  NSManagedObjectModel *_managedObjectModel;
  NSPersistentStoreCoordinator *_persistentStoreCoordinator;
  NSString *_modelName;
  NSString *_name;
}

/**
 You should only call this method on main thread
 */
+ (id)mainStore;

+ (void)registerClass:(NSString*)className toStore:(BTCoreDataStore*) store;

+ (NSError*)saveContext:(NSManagedObjectContext*)context;


- (id)initWithName:(NSString*)name modelName:(NSString*)modelName;
- (NSString *)name;
/**
 返回当前线程对应的NSManagedObjectContext，如果没有则创建一个
 主线程返回_mainThreadManagedObjectContext
 */
- (NSManagedObjectContext *) mocForCurrentThread;

@end
