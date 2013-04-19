//
//  Project.h
//  Weido
//
//  Created by He baochen on 13-3-29.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Task;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isFinish;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *tasks;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addTasksObject:(Task *)value;
- (void)removeTasksObject:(Task *)value;
- (void)addTasks:(NSSet *)values;
- (void)removeTasks:(NSSet *)values;

@end
