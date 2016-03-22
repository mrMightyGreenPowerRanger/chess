//
//  WallTableViewCell.m
//  HW45
//
//  Created by Илья Егоров on 15.02.16.
//  Copyright © 2016 Илья Егоров. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallTableViewCell.h"
#import "WallPost.h"
#import "UIImageView+AFNetworking.h"

@interface WallTableViewCell ()

@property (strong, nonatomic) WallPost* post;

@property (assign, nonatomic) CGFloat attachmentHeight;

@end

@implementation WallTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setWallPost:(WallPost *)wallPost {
    
    for (UIView* subview in self.subviews) {
        [subview removeFromSuperview];
    }
    
    self.attachmentHeight = 8.f;
    self.post = wallPost;
    if (self.post.text) {
        UIFont *font = [UIFont systemFontOfSize: 15.0];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName];

        NSAttributedString* string = [[NSAttributedString alloc] initWithString:self.post.text attributes:attrsDictionary];
        CGRect rect = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:NULL];
        UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(66, self.attachmentHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, rect.size.height+8)];
        self.attachmentHeight += rect.size.height + 4;
        [textView setContentInset:UIEdgeInsetsMake(-8,-6,0,0)];
        [textView setScrollEnabled:NO];
        [textView setAttributedText:string];
        
        [textView setEditable:NO];
        [self addSubview:textView];
    }
    if ([self.post.postType isEqualToString:@"copy"]) {
        UILabel* copy = [[UILabel alloc] initWithFrame:CGRectMake(66, self.attachmentHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, 30)];
        [copy setText:@"REPOST"];
        [copy setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.7]];
        [self addSubview:copy];
        self.attachmentHeight += 30 + 4;
    }
    if (self.post.attachments) {
        [self configureAttachments];
    }
   
    self.attachmentHeight += 25 + 4;
    self.attachmentHeight = MAX (self.attachmentHeight, 50 + 8 + 8);
    UILabel* likesRepostsLabel = [[UILabel alloc] initWithFrame:CGRectMake(66, self.attachmentHeight - 25 - 4, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, 25)];
    [likesRepostsLabel setBackgroundColor:[UIColor greenColor]];
    [likesRepostsLabel setText:[NSString stringWithFormat:@"Likes: %d  Reposts: %d",[self.post.likes integerValue],[self.post.reposts integerValue]]];
    [self addSubview:likesRepostsLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configureAttachments {
    for (int i = 0; i < self.post.attachments.count; i++) {
        NSDictionary* attachment = [self.post.attachments objectAtIndex:i];
        if ([[attachment valueForKey:@"type"] isEqualToString:@"photo"]) {
            NSDictionary* photoInfo = [attachment objectForKey:@"photo"];
            UIImageView* imageView = [[UIImageView alloc] initWithImage:nil];
            [imageView setFrame:CGRectMake(66, self.attachmentHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, (CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8)/4*3)];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [self addSubview:imageView];
            
            self.attachmentHeight += CGRectGetHeight(imageView.frame) + 4;
            
            __weak UIImageView* weakImageView = imageView;
            NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[photoInfo objectForKey:@"src"]]];
            [imageView setImageWithURLRequest:request
                             placeholderImage:nil
                                      success:^void(NSURLRequest * __nonnull request, NSHTTPURLResponse * __nonnull responce, UIImage * __nonnull image) {
                                          [weakImageView setImage:image];
                                        } failure:^ void(NSURLRequest * __nonnull request,
                                                         NSHTTPURLResponse * __nonnull responce,
                                                         NSError * __nonnull error) {
                                        }];
        } else {
            NSString* attachmentType = [attachment valueForKey:@"type"];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(66, self.attachmentHeight, CGRectGetWidth([[UIScreen mainScreen] bounds]) - 66 - 8, 30)];
            [label setText:[attachmentType uppercaseString]];
            [label setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.7]];
            self.attachmentHeight += CGRectGetHeight(label.frame) + 4;
            [self addSubview:label];
        }
    }
}
@end
