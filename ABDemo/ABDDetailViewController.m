//
//  ABDDetailViewController.m
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "ABDDetailViewController.h"

@interface ABDDetailViewController ()
- (void)configureView;
@end

@implementation ABDDetailViewController

@synthesize contactRef = _contactRef;
@synthesize firstNameDisplay = _firstNameDisplay;
@synthesize lastNameDisplay = _lastNameDisplay;

-(void) setContactRef:(ABRecordRef)newContactRef {
    if (_contactRef != newContactRef) {
        _contactRef = newContactRef;
        //[self configureView];
    }
}

- (void)getPhoneNumbers  {
    const ABRecordRef *ref = self.contactRef;
    const ABMultiValueRef *phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
    {
        CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
        CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
        NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
        NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
        CFRelease(phoneNumberRef);
        CFRelease(locLabel);
        NSLog(@"  - %@ (%@)", phoneNumber, phoneLabel);
    }
}

-(void)getEmails {
    const ABRecordRef *ref = self.contactRef;
    const ABMultiValueRef *emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
    for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++)
    {
        CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, j);
        CFStringRef localLabel = ABMultiValueCopyLabelAtIndex(emails, j);
        NSString *emailLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(localLabel);
        NSString *emailString = (__bridge NSString *)emailRef;
        CFRelease(emailRef);
        CFRelease(localLabel);
        NSLog(@"  - %@ (%@)", emailString, emailLabel);
    }

}

- (void)configureView
{
    // Update the user interface for the detail item.
    const ABRecordRef *ref = self.contactRef;
    
    if(ref) {
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if(!firstName) firstName = @"";
        if(!lastName) lastName = @"";
        self.firstNameDisplay.text = firstName;
        self.lastNameDisplay.text = lastName;
        [self getPhoneNumbers];
        [self getEmails];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
