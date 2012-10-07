//
//  ABDDetailCell.m
//  ABDemo
//
//  Created by Zhang on 06/10/12.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "ABDDetailCell.h"

@implementation ABDDetailCell

@synthesize address=_address, company = _company, birthday=_birthday;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
