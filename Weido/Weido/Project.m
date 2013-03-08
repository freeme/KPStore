//
//  Project.m
//  Todo
//
//  Created by He baochen on 12-3-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Project.h"
#import "Task.h"


@implementation Project

@dynamic createDate;
@dynamic dueDate;
@dynamic isFinish;
@dynamic name;
@dynamic tasks;

- (void)addTasksObject:(Task *)value {
  // Plesase read the comments in [EditTaskViewController saveTask] method
}


+ (BOOL) addProjectWithName:(NSString*)name {
  //    Project *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
  Project *newProject = (Project*)[Project createNewObject];
  newProject.name = name;
  newProject.createDate = [NSDate date];
  [newProject save];
  return YES; //TODO:
}

@end
