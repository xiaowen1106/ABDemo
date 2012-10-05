//
//  ABDContactController.m
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import "ABDContactController.h"

@interface ABDContactController()

-(void)initDefaultContactList;

@end

@implementation ABDContactController

@synthesize contactList = _contactList;
@synthesize allPeople = _allPeople;
@synthesize nPeople = _nPeople;

- (void)setContactList:(NSMutableArray *)newList {
    if (_contactList != newList) {
        _contactList = [newList mutableCopy];
    }
}

-(void)setContactsAfterGranted:(ABAddressBookRef)addressBook {
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
    self.allPeople = allPeople;
    self.nPeople = nPeople;
}

//init all contacts in self.contactList
-(void)initDefaultContactList {
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    self.contactList = contactList;
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            [self setContactsAfterGranted:addressBook];
        });
    }else {
        [self setContactsAfterGranted:addressBook];
    }
}

//overwrite the constructor
- (id)init {
    if (self = [super init]) {
        [self initDefaultContactList];
        return self;
    }
    return nil;
}

- (NSUInteger)countOfList {
    return [self.contactList count];
}

- (NSString *)objectInListAtIndex:(NSUInteger)theIndex {
    return ([self.contactList objectAtIndex:theIndex]);
}

- (BOOL)sendContacts {
    
    CFArrayRef allPeople = self.allPeople;
    CFIndex nPeople = self.nPeople;
    ABRecordRef ref;
    
    NSMutableArray *encodedParam = [NSMutableArray array];
    
    for ( int i = 0; i < nPeople; i++ )
    {
        ref = CFArrayGetValueAtIndex( allPeople, i );
        NSString * encoded = [NSString stringWithFormat:@"%@%d=%@",
            [@"Last Name" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],i,
            [(__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty) stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];//NSASCIIStringEncoding
        
        [encodedParam addObject:encoded];
        
//        [encodedParam removeAllObjects];
    }
    BOOL sentOK = [self sendPost:encodedParam];
    return sentOK;
}

- (BOOL)sendPost:(NSArray *)encodedParam
{
    NSString * post = [encodedParam componentsJoinedByString:@"&"];
    NSData * postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    
    NSURL * url = [NSURL URLWithString:@"http://www.xiaowen.me/TX/contacts.php"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        NSLog(@"Connection succeeded!");
        return YES;
    }else {
        return NO;
    }
}

@end
