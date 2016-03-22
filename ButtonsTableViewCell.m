//
//  ButtonsTableViewCell.m
//  HW45
//
//  Created by Илья Егоров on 20.09.15.
//  Copyright © 2015 Илья Егоров. All rights reserved.
//

#import "ButtonsTableViewCell.h"

@implementation ButtonsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionShowFriends:(UIButton *)sender {
    [self.delegate actionShowFriends:sender];
}

- (IBAction)actionShowSubscriptions:(UIButton *)sender {
    [self.delegate actionShowSubscriptions:sender];
}

- (IBAction)actionShowFollowers:(UIButton *)sender {
    [self.delegate actionShowFollowers:sender];
}

@end
