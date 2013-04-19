//
//  Project+Actions.m
//  Weido
//
//  Created by He baochen on 13-3-20.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import "Project+Actions.h"

@implementation Project(Actions)

+ (BOOL) addProjectWithName:(NSString*)name {
  //    Project *newProject = [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:self.managedObjectContext];
  Project *newProject = (Project*)[Project createNewObject];
  newProject.name = name;
  newProject.createDate = [NSDate date];
  [newProject save];
  return YES; //TODO:
}

@end
