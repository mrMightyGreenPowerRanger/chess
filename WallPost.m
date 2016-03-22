//
//  WallPost.m
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import "WallPost.h"

@implementation WallPost


-(id)initWithServerResponce:(NSDictionary*)responseObject
{
    self = [super init];
    if (self) {
        self.postType = [responseObject objectForKey:@"post_type"];
        if ([self.postType isEqualToString:@"copy"]) {
            self.text = [responseObject objectForKey:@"copy_text"];
        } else {
            self.text = [responseObject objectForKey:@"text"];
        }
        self.fromID = [responseObject objectForKey:@"from_id"];
        self.likes = [[responseObject objectForKey:@"likes"] objectForKey:@"count"];
        self.reposts = [[responseObject objectForKey:@"reposts"] objectForKey:@"count"];
        self.attachments = [responseObject objectForKey:@"attachments"];
    }
    return self;
}
@end
