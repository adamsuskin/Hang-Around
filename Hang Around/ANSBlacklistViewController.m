//
//  ANSBlacklistViewController.m
//  Hang Around
//
//  Created by Adam Suskin on 7/28/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSBlacklistViewController.h"

@interface ANSBlacklistViewController ()

@end

@implementation ANSBlacklistViewController
@synthesize data, friends;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self tableView] setTableFooterView:[[UIView alloc] init]];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
    [[self navigationItem] setLeftBarButtonItem:barButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blockSelected:) name:@"com.adamsuskin.hangaround.blockSelected" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)blockSelected:(NSNotification *)notification
{
    PFUser *user = [[notification userInfo] objectForKey:@"user"];
    BOOL isSelected = [[[notification userInfo] objectForKey:@"isSelected"] boolValue];
    if (!isSelected) {
        PFObject *blacklist = [[PFObject alloc] initWithClassName:@"Blacklist"];
        PFACL *acl = [PFACL ACL];
        [acl setPublicReadAccess:YES];
        [acl setPublicWriteAccess:YES];
        [blacklist setACL:acl];
        [blacklist setObject:[PFUser currentUser] forKey:@"blacklister"];
        [blacklist setObject:user forKey:@"blacklistee"];
        [blacklist saveInBackground];
    }
    else {
        PFQuery *query = [PFQuery queryWithClassName:@"Blacklist"];
        [query whereKey:@"blacklister" equalTo:[PFUser currentUser]];
        [query whereKey:@"blacklistee" equalTo:user];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error)
                NSLog(@"%@", [error localizedDescription]);
            else {
                for (PFObject *object in objects){
                    [object deleteInBackground];
                }
            }
        }];
    }
}

-(void)backPressed
{
    [[self navigationController] popViewControllerAnimated:YES];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(friends != nil)
        return [friends count];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ANSBlacklistCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"ANSBlacklistCell" owner:nil options:nil];
        cell = [views objectAtIndex:0];
        [cell setCorrespondingUser:[friends objectAtIndex:indexPath.row]];
    }
    
    [[cell titleLabel] setText:[[friends objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
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
}

@end
