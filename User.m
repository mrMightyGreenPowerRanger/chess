//
//  User.m
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithId:(NSInteger)userID
{
    self = [super init];
    if (self) {
        self.userID = userID;
    }
    return self;
}


-(id)initWithServerResponce:(NSDictionary*)responceObject;
{
    self = [super init];
    if (self) {
        self.userID = [[responceObject objectForKey:@"uid"] integerValue];
        self.firstName = [responceObject objectForKey:@"first_name"];
        self.lastName = [responceObject objectForKey:@"last_name"];
        self.isOnline = [[responceObject objectForKey:@"online"] integerValue];
        
        NSString* urlString = [responceObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.smallImageURL = [NSURL URLWithString:urlString];
        }
        
        urlString = [responceObject objectForKey:@"photo_max"];
        
        if (urlString) {
            self.largeImageURL = [NSURL URLWithString:urlString];
        }
        
        self.birthDate = [responceObject objectForKey:@"bdate"];
        
        self.mobilePhone = [responceObject objectForKey:@"mobile_phone"];
    }
    return self;
}
@end
