//
//  WallPost.h
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallPost : NSObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* postType;
@property (strong, nonatomic) NSNumber* fromID;
@property (strong, nonatomic) NSNumber* likes;
@property (strong, nonatomic) NSNumber* reposts;
@property (strong, nonatomic) NSArray* attachments;


-(id)initWithServerResponce:(NSDictionary*)responceObject;

@end
