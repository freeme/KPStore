//
//  KPStore.h
//  kweibo
//
//  Created by He baochen on 11-9-6.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 可以将一个KPStore对象理解为对应一个数据库
 通常情况一下一个产品只需要一个数据库的话，就不需要做任何额外的工作
 
 Example
 当需要有两个数据库时，比如将Log信息单独入到一个数据库里的话
 KPStore *logStore = [KPStore registerStoreWithName:@"LogDB" modelFile:@"xxx"];
 假设BTLogRecord是一个ManagedObject对象
 [KPStore bindObjectClass:[BTLogRecord class] toStore:logStore];
 或 [KPStore bindObjectClass:[BTXXXXXXXXX class] toStore:logStore];
 在这之后，BTLogRecord的相关增删改查，都会保存在LogDB对应的数据库中
 
 没有绑定的其他ManagedObject对象，默认保存在[KPStore sharedStore]对应的数据库中
 */

@interface KPStore : NSObject {
  NSManagedObjectContext *_managedObjectContext;
  NSManagedObjectModel *_managedObjectModel;
  NSPersistentStoreCoordinator *_persistentStoreCoordinator;
  NSString *_modelFileName;
}

// 注册一个新的模型和数据库
+ (KPStore*)registerStoreWithName:(NSString*)name modelFile:(NSString*)modelFileName;
// 根据名字返回注册的KPStore
+ (KPStore*)storeForName:(NSString*)name;
// 绑定对象到指定的数据库（KPStore）上
+ (void)bindObjectClass:(Class)objClass toStore:(KPStore*)store;
// 返回对象所属的KPStore对象, 如果没有绑定到其他KPStore上，默认返回sharedStore
+ (KPStore*)storeForObject:(Class) objClass;
+ (KPStore*)sharedStore;
+ (void)destory;
+ (void)saveAllStore;
+ (void)saveContext:(NSManagedObjectContext*)context;

- (id) initWithModelFileName:(NSString*)modelFileName;

@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory;
- (void) saveContext;
- (void) didReceiveMemoryWarning;
- (void) resetPersistentStore;

- (NSManagedObject *)objectWithID:(NSManagedObjectID *)objectID; 
- (void)deleteObject:(NSManagedObject *)object;
- (NSManagedObject*)insertNewObjectForEntityForName:(NSString*)entityName;
- (void)deleteObjectByID:(NSManagedObjectID *)objectID;
- (NSEntityDescription*) entityForName:(NSString*)entityName;
- (NSArray *)executeFetchRequest:(NSFetchRequest *)request
						   error:(NSError **)error;
@end
