//
//  ANSQueryTableViewController.m
//  Hang Around
//
//  Created by Adam Suskin on 7/20/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSQueryTableViewController.h"

@interface ANSQueryTableViewController ()

@end

@implementation ANSQueryTableViewController
@synthesize friendIds, pushTimes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        firstLoad = YES;
        self.parseClassName = @"User";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        [[self tableView] setTableFooterView:[[UIView alloc] init]];
    }
    return self;
}

-(PFQuery *)queryForTable
{
    PFQuery *friendQuery = [PFUser query];
    [friendQuery whereKey:@"fbID" containedIn:friendIds];
    return friendQuery;
}

-(void)loadObjects
{
    [ANSServerHandler fetchFacebookFriendIDsWithCallback:^(NSArray *results){
        [self setFriendIds:results];
        [super loadObjects];
    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *CellIdentifier = @"Cell";
    
    ANSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ANSTableViewCell" owner:self options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (ANSTableViewCell*)view;
            }
        }
        
    }
    
    PFUser *user = (PFUser *)object;
    
    [[cell nameLabel] setText:[NSString stringWithFormat:@"%@", [user objectForKey:@"name"]]];
    
    UIColor *foregroundColor = [UIColor blackColor];
    UIColor *otherColor = [[ANSSessionHandler colorsArray] objectAtIndex:[[user objectForKey:@"state"] intValue]];
    
    NSString *tmpString = [user objectForKey:@"status"];
    NSString *updateString = [NSString stringWithFormat:@" - %@", [ANSSessionHandler highestTimeInterval:[ANSSessionHandler formattedTimeInterval:[[NSDate date] timeIntervalSinceDate:user.updatedAt]]]];
    // Create the attributes
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           otherColor, NSForegroundColorAttributeName, nil];
    NSDictionary *subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                              foregroundColor, NSForegroundColorAttributeName, nil];
    
    // Create the attributed string (text + attributes)
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:tmpString
                                           attributes:attrs];
    NSAttributedString *tmpAttributedText =
    [[NSAttributedString alloc] initWithString:updateString attributes:subAttrs];
    
    [attributedText appendAttributedString:tmpAttributedText];
    
    // Set it in our UILabel and we are done!
    [[cell statusLabel] setAttributedText:attributedText];
    
    dispatch_queue_t downloader = dispatch_queue_create("ProfPicDownloader", NULL);
    dispatch_async(downloader, ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [user objectForKey:@"fbID"]]];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:urlData];
        image = [ANSSessionHandler imageWithBorderFromImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *tmp = [[UIImageView alloc] initWithImage:image];
            [tmp setFrame:CGRectMake(0, 0, 50, 50)];
            [[cell profPicView] setImage:[tmp image]];
        });
    });

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void)objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    if(firstLoad) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[friendIds count]];
        NSDate *prevDate = [[NSDate date] dateByAddingTimeInterval:-60*5];
        for (int i = 0; i < [friendIds count]; i++){
            [array addObject:prevDate];
        }
        pushTimes = [[NSMutableDictionary alloc] initWithObjects:array forKeys:friendIds];
        firstLoad = NO;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PFUser *friendUser = (PFUser *)[self objectAtIndexPath:indexPath];
    
    if([[NSDate date] timeIntervalSinceDate:[pushTimes objectForKey:[friendUser objectForKey:@"fbID"]]] >= 60*5){
    
        [pushTimes setObject:[NSDate date] forKey:[friendUser objectForKey:@"fbID"]];
        
        PFQuery *installQuery = [PFInstallation query];
        [installQuery whereKey:@"owner" equalTo:friendUser.objectId];
        
        PFPush *push = [[PFPush alloc] init];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ nudged you!", [[PFUser currentUser] objectForKey:@"name"]], @"alert", @"Increment", @"badge", nil];
        [push expireAfterTimeInterval:60*60*24];
        [push setQuery:installQuery];
        [push setData:data];
        [push sendPushInBackground];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hang Around"
                                                        message:@"You may not nudge someone within 5 minutes of your last nudge to them."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
