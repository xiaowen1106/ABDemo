//
//  ABDDetailViewController.h
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface ABDDetailViewController : UIViewController

@property (nonatomic) ABRecordRef contactRef;
@property (weak, nonatomic) IBOutlet UILabel *firstNameDisplay;
@property (weak, nonatomic) IBOutlet UILabel *lastNameDisplay;

@end
