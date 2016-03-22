//
//  User.h
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (assign, nonatomic) NSInteger userID;
@property (assign, nonatomic) BOOL isOnline;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* birthDate;
@property (strong, nonatomic) NSURL* smallImageURL;
@property (strong, nonatomic) NSURL* largeImageURL;

@property (strong, nonatomic) NSString* mobilePhone;


- (id)initWithServerResponce:(NSDictionary*)responceObject;

- (instancetype)initWithId:(NSInteger)userID;


@end
