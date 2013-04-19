//
//  Task.h
//  Weido
//
//  Created by He baochen on 13-3-29.
//  Copyright (c) 2013年 He baochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project, Tag;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isFinish;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Task (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
