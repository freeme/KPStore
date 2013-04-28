//
//  BTCoreDataStore.m
//  Weido
//
//  Created by He baochen on 13-4-19.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import "BTCoreDataStore.h"
#import "NSManagedObject+ActiveRecord.h"

static NSString const * kKPStoreManagedObjectContextKey = @"KPStore_NSManagedObjectContextForThreadKey";
static BTCoreDataStore *__instance = nil;
@implementation BTCoreDataStore
#pragma mark static methods

+ (id)mainStore {
  if (!__instance) {
    @synchronized(self) {
      if (!__instance) {
        __instance = [[BTCoreDataStore alloc] initWithName:[NSString stringWithFormat:@"MainStore-%@",MAIN_MODEL_FILE_NAME] modelName:MAIN_MODEL_FILE_NAME];
      }
    }
  }
  return __instance;
}
+ (void)registerClass:(NSString*)className toStore:(BTCoreDataStore*) store {
  Class cls = NSClassFromString(className);
  NSAssert(![cls isSubclassOfClass:[NSManagedObject class]], @"%@ is not subclass of NSManagedObject", className);
  [cls setStore:store];
}

+ (NSError*)saveContext:(NSManagedObjectContext*)context {
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = context;
  if (managedObjectContext != nil && [managedObjectContext hasChanges]) {
    if (![managedObjectContext save:&error]) {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      //      
#ifdef DEBUG
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
#endif
      return error;
    } else {
      if (![NSThread isMainThread]) {
        //如果不是主线程中的NSManagedObjectContext，save后将数据清除，避免后续操作产生Merge失败的问题
        [context reset];
        //TODO: remove the NSManagedObjectContext from thread?
      }
    }
  }
  return error;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
+ (NSURL *)applicationDocumentsDirectory {
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -

- (void)dealloc {
  [_mainThreadManagedObjectContext release];
  [_managedObjectModel release];
  [_persistentStoreCoordinator release];
  [_modelName release];
  [_name release];
  [super dealloc];
}

- (id)initWithName:(NSString*)name modelName:(NSString*)modelName {
  self = [super init];
  if (self) {
    _name = [name copy];
    _modelName = [modelName copy];
  }
  return self;
}

- (NSString*)name {
  return _name;
}


- (NSManagedObjectContext*)mainManagedObjectContext {
  NSAssert([NSThread isMainThread], @"mainManagedObjectContext should be only called on main thread");
  if (!_mainThreadManagedObjectContext) {
    @synchronized (self) {
      if (!_mainThreadManagedObjectContext) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
          _mainThreadManagedObjectContext = [[NSManagedObjectContext alloc] init];
          [_mainThreadManagedObjectContext setPersistentStoreCoordinator:coordinator];
          //[_mainThreadManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        }
      }
    }
  }
  return _mainThreadManagedObjectContext;
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */

- (NSManagedObjectContext *) mocForCurrentThread {
  if ([NSThread isMainThread]) {
    return [self mainManagedObjectContext];
  }else {
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    //NSManagedObjectContext 不但跟线程有关，也跟当前的BTCoreDataStore有关
    //同一个线程中的NSManagedObjectContext，也可能属于不同的Store
    NSManagedObjectContext *threadContext = [threadDict objectForKey:[NSString stringWithFormat:@"%@-%@",kKPStoreManagedObjectContextKey,_name]];
    if (threadContext == nil) {
      NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
      if (coordinator != nil) {
        threadContext = [[[NSManagedObjectContext alloc] init] autorelease];
        [threadContext setPersistentStoreCoordinator:coordinator];
        //[threadContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [threadDict setObject:threadContext forKey:kKPStoreManagedObjectContextKey];
        [self addObserverToContext:threadContext];
      }
    }
    return threadContext;
  }
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (!_managedObjectModel) {
    @synchronized (self) {
      if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:_modelName withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
      }
    }
  }
  return _managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (!_persistentStoreCoordinator) {
    @synchronized (self) {
      if (!_persistentStoreCoordinator) {
        NSURL *storeURL = [[[self class] applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@_DB.sqlite",_modelName]];
        
        NSError *error = nil;
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSPersistentStore *persistenStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        if (!persistenStore) {
          [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
          NSLog(@"Removed incompatible model version: %@", [storeURL lastPathComponent]);
          
          persistenStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
          if (persistenStore) {
            error = nil;
          } else {
            NSLog(@"error domain: %@, error code:%d", [error domain], [error code]);
          }
          /*
           Replace this implementation with code to handle the error appropriately.
           
           abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
           
           Typical reasons for an error here include:
           * The persistent store is not accessible;
           * The schema for the persistent store is incompatible with current managed object model.
           Check the error message to determine what the actual problem was.
           
           
           If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
           
           If you encounter schema incompatibility errors during development, you can reduce their frequency by:
           * Simply deleting the existing store:
           [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
           
           * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
           [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
           
           Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
           
           */
          //    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
  #ifdef DEBUG
          abort();
  #endif
        }
      }
    }
  }
  return _persistentStoreCoordinator;
}

#pragma mark Core Data Merge Changes from other thread

- (void)addObserverToContext:(NSManagedObjectContext*)otherContext {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(mergeChanges:)
                                               name:NSManagedObjectContextDidSaveNotification
                                             object:otherContext];
}

- (void)mergeChanges:(NSNotification *)notification {
  if ([NSThread isMainThread]) {
    // main context save, no need to perform the merge
    return;
  }
  [self performSelectorOnMainThread:@selector(updateContext:) withObject:notification waitUntilDone:YES];
}

- (void)updateContext:(NSNotification *)notification
{
	[[self mainManagedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
}
#pragma mark -

- (void) didReceiveMemoryWarning {
  
  
}



@end
