//
//  WallController.h
//  TestApiVk
//
//  Created by Галанов Сергей on 16.03.16.
//  Copyright © 2016 Галанов Сергей. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallController : UITableViewController

@property (assign, nonatomic) NSInteger userID;
@property (strong, nonatomic) NSURL* userPhotoURL;
@end
