//
//  Project.h
//  Todo
//
//  Created by He baochen on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isFinish;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *tasks;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)insertObject:(Task *)value inTasksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTasksAtIndex:(NSUInteger)idx;
- (void)insertTasks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTasksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTasksAtIndex:(NSUInteger)idx withObject:(Task *)value;
- (void)replaceTasksAtIndexes:(NSIndexSet *)indexes withTasks:(NSArray *)values;
- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSOrderedSet *)values;
- (void)removeTasks:(NSOrderedSet *)values;
@end

@interface Project (Weido)

+ (BOOL) addProjectWithName:(NSString*)name;

@end