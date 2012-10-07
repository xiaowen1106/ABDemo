//
//  ABDContactController.h
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface ABDContactController : NSObject

@property (nonatomic, copy) NSMutableArray *contactList;
@property (nonatomic) CFArrayRef allPeople;
@property (nonatomic) int nPeople;

- (NSUInteger)countOfList;
- (NSString *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)sendContactsWithCallback:(void (^)(void))callback inContext:(id)context;

@end
