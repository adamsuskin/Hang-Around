//
//  ANSOptionsViewController.m
//  Hang Around
//
//  Created by Adam Suskin on 7/22/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSOptionsViewController.h"

@interface ANSOptionsViewController ()

@end

@implementation ANSOptionsViewController
@synthesize optionsDictionary, accountSettings, friendSettings, infoCollection, orderedKeys, blacklistViewController;
@synthesize friends;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        orderedKeys = [[NSArray alloc] initWithObjects:@"accountSettings", @"friendSettings", @"infoCollection", nil];
        
        accountSettings = [[NSDictionary alloc] init];
        friendSettings = [[NSDictionary alloc] init];
        infoCollection = [ANSSessionHandler infoCollection];
        
        optionsDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:accountSettings, friendSettings, infoCollection, nil] forKeys:orderedKeys];
        
        blacklistViewController = [[ANSBlacklistViewController alloc] initWithStyle:UITableViewStylePlain];
        [blacklistViewController setTitle:@"Blacklist"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
}

-(void)setFriends:(NSArray *)_friends
{
    [blacklistViewController setFriends:_friends];
    friends = _friends;
}

-(void)backPressed
{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)initializeSettings
{
    optionsDictionary = [ANSSessionHandler userDictionary];
    accountSettings = (NSDictionary *)[optionsDictionary objectForKey:@"accountSettings"];
    friendSettings = (NSDictionary *)[optionsDictionary objectForKey:@"friendSettings"];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [orderedKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[optionsDictionary objectForKey:[orderedKeys objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titlesArray = [NSArray arrayWithObjects:
                            @"My Account",
                            @"Friend Settings",
                            @"Information",
                            nil];
    return [titlesArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifierInfo = @"InfoCell";
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section == [orderedKeys indexOfObject:@"accountSettings"]) {
        ANSInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifierInfo];
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ANSInfoCell" owner:self options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (ANSInfoCell*)view;
            }
        }
        
        NSString *key = [self getKeyFromDictionary:accountSettings ForIndexPath:indexPath];
        
        [[cell titleLabel] setText:[self formatText:key withColon:YES]];
        [[cell contentLabel] setText:[accountSettings objectForKey:key]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section == [orderedKeys indexOfObject:@"friendSettings"]){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *key = [self getKeyFromDictionary:friendSettings ForIndexPath:indexPath];
        
        [[cell textLabel] setText:[self formatText:key withColon:NO]];
        [[cell textLabel] setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        return cell;
    }
}

-(NSString *)getKeyFromDictionary:(NSDictionary *)dictionary ForIndexPath:(NSIndexPath *)indexPath
{
    NSString *key;
    if ([dictionary isEqualToDictionary:accountSettings]) {
        switch (indexPath.row) {
            case 0:
                key = @"name";
                break;
            case 1:
                key = @"email";
                break;
            default:
                key = @"name";
                break;
        }
    }
    else if ([dictionary isEqualToDictionary:friendSettings]) {
        switch (indexPath.row) {
            case 0:
                key = @"blacklist";
                break;
            case 1:
                key = @"notification center";
                break;
            default:
                key = @"blacklist";
                break;
        }
    }
    else {
    
    }
    return key;
}

-(NSString *)formatText:(NSString *)text withColon:(BOOL)colon
{
    NSString *lowercase = [text lowercaseString];
    NSString *newString = @"";
    
    newString = [newString stringByAppendingString:[[lowercase substringToIndex:1] uppercaseString]];
    for (int i = 1; i < [lowercase length]; i++){
        NSString *character = [lowercase substringWithRange:NSMakeRange(i, 1)];
        if([lowercase characterAtIndex:(i-1)] == ' ')
            character = [character uppercaseString];
        newString = [newString stringByAppendingString:character];
    }
    if(colon)
        newString = [newString stringByAppendingString:@":"];
    return newString;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == [orderedKeys indexOfObject:@"friendSettings"]) {
        switch (indexPath.row) {
            case 0:
                [[self navigationController] pushViewController:blacklistViewController animated:YES];
                break;
            default:
                break;
        }
    }}

@end
