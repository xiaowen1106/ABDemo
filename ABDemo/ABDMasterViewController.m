//
//  ABDMasterViewController.m
//  ABDemo
//
//  Created by Zhenyi ZHANG on 2012-10-02.
//  Copyright (c) 2012 Zhenyi ZHANG. All rights reserved.
//



#import "ABDMasterViewController.h"

#import "ABDDetailViewController.h"

/*@interface ABDMasterViewController () {
    NSInteger showADetail;
}
@end*/

@implementation ABDMasterViewController

@synthesize contactController = _contactController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //Trick, but not good, check it
    
    if(self.tableView.tag!=-1){
        return self.contactController.nPeople + 1;
    }else{
        return self.contactController.nPeople;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Two case: for detail and normal content
    
    NSInteger pIndex;
    ABRecordRef ref;
    
    static NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    if(self.tableView.tag != -1 && indexPath.row == self.tableView.tag + 1){
        ABDDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
        pIndex = self.tableView.tag;
        ref = CFArrayGetValueAtIndex( self.contactController.allPeople, pIndex);
        NSString *address = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonAddressProperty);
        NSString *company = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonOrganizationProperty);
        
        return cell;
    }else{
        ABDContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell"];
        pIndex = indexPath.row;
        ref = CFArrayGetValueAtIndex( self.contactController.allPeople, pIndex);
        NSString *firstName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        if (!firstName) firstName = @" ";
        if (!lastName) lastName = @" ";
        cell.name.text = [NSString stringWithFormat:@"%@ %@",lastName, firstName];
        
        NSMutableString *phone = [NSMutableString stringWithString:@""];
        const ABMultiValueRef *phones = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            //CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            //NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            CFRelease(phoneNumberRef);
            //CFRelease(locLabel);
            [phone appendFormat:@"%@ ",phoneNumber];
        }
        cell.phone.text = phone;
        
        NSMutableString *email = [NSMutableString stringWithString:@""];
        const ABMultiValueRef *emails = ABRecordCopyValue(ref, kABPersonEmailProperty);
        for(CFIndex j = 0; j < ABMultiValueGetCount(emails); j++)
        {
            CFStringRef emailRef = ABMultiValueCopyValueAtIndex(emails, j);
            //CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(emails, j);
            //NSString *phoneLabel =(__bridge NSString*) ABAddressBookCopyLocalizedLabel(locLabel);
            NSString *emailad = (__bridge NSString *)emailRef;
            CFRelease(emailRef);
            //CFRelease(locLabel);
            [email appendFormat:@"%@ ",emailad];
        }
        cell.email.text = email;

        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/**
  加入右侧的小滑块索引
*/
/*
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    [titles addObject:@"A"];
    return titles;
}
*/

/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSLog(@"in");
    }
}*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *index;
    NSInteger tempTag = self.tableView.tag;
    ABDContentCell *motherCell = (ABDContentCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(self.tableView.tag == -1){
        self.tableView.tag = indexPath.row;
        motherCell.line.hidden = YES;
        index = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
        [tableView cellForRowAtIndexPath:index].backgroundColor = [UIColor blackColor];
        motherCell.foldIcon.hidden = NO;
    }else{
        self.tableView.tag = -1;
        ABDContentCell *oldMotherCell = (ABDContentCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tempTag inSection:indexPath.section]];
        motherCell.line.hidden = NO;
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:tempTag+1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
        oldMotherCell.foldIcon.hidden = YES;
        if(tempTag != indexPath.row){
            NSInteger newIndex = indexPath.row;
            if(indexPath.row > tempTag + 1){
                newIndex = indexPath.row -1;
            }
            self.tableView.tag = newIndex;
            motherCell.line.hidden = YES;
            index = [NSIndexPath indexPathForRow:newIndex+1 inSection:indexPath.section];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationFade];
            [tableView cellForRowAtIndexPath:index].backgroundColor = [UIColor blackColor];
            motherCell.foldIcon.hidden = NO;
        }
    }
}

- (IBAction)sendContacts:(UIBarButtonItem *)sender {
    
    NSString *message;
    BOOL sentOk = [self.contactController sendContacts];
    if (sentOk) {
        message = @"Contact data has been successfully sent to server!";
    } else {
        message = @"Connection failed!";
    }
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"ABDemo" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
