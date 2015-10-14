//
//  ANSViewController.m
//  Hang Around
//
//  Created by Adam Suskin on 6/30/13.
//  Copyright (c) 2013 Adam Suskin. All rights reserved.
//

#import "ANSViewController.h"

@interface ANSViewController ()

@end

@implementation ANSViewController
@synthesize haMainViewController, haServerHandler, backgroundImageView, haLoginActivityIndicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGSize winSize = [ANSSessionHandler windowSize];
    if(winSize.height > 1000)
        [backgroundImageView setImage:[UIImage imageNamed:@"hangAroundLaunch5.png"]];
    else
        [backgroundImageView setImage:[UIImage imageNamed:@"hangAroundLaunch.png"]];
    [[self view] insertSubview:backgroundImageView atIndex:0];
    
    haLoginActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [haLoginActivityIndicator setCenter:CGPointMake(self.view.center.x, self.view.center.y)];
    [haLoginActivityIndicator setHidden:YES];
    [[self view] addSubview:haLoginActivityIndicator];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([PFUser currentUser])
        [self handleLogIn:YES];
}
 
-(IBAction)logInButtonPushed:(id)sender
{
    [self handleLogIn:YES];
}

-(void)handleLogIn:(BOOL)animated
{
    [self toggleState];
    NSArray *permissionsArray = [NSArray arrayWithObjects:@"email", nil];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
        }
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            if (user.isNew){
                NSLog(@"New User!");
                [[PFUser currentUser] setObject:@"Available" forKey:@"status"];
                [[PFUser currentUser] setObject:@1 forKey:@"state"];
            }
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Store the current user's Facebook ID on the user
                    [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                             forKey:@"fbID"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"name"] forKey:@"name"];
                    [[PFUser currentUser] setObject:[result objectForKey:@"email"] forKey:@"email"];
                    
                    [[PFUser currentUser] saveInBackground];
                    
                    [[PFInstallation currentInstallation] setObject:[PFUser currentUser].objectId forKey:@"owner"];
                    [[PFInstallation currentInstallation] saveInBackground];
                }
            }];
            NSLog(@"User logged in through Facebook!");
            CGRect mainFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y,
                                          self.view.frame.size.width, self.view.frame.size.height-44);
            haMainViewController = [[ANSMainViewController alloc] initWithFrame:mainFrame];
            [haMainViewController setTitle:@"Hang Around"];
            [haMainViewController setHaServerHandler:haServerHandler];
            [haMainViewController refreshData];
            UINavigationController *navController = [[UINavigationController alloc]
                                                     initWithRootViewController:haMainViewController];
            [[navController navigationBar] setTintColor:[UIColor colorWithRed:1.0 green:(216 / 255.0) blue:0.0 alpha:1.0]];
            [self toggleState];
            [self presentViewController:navController animated:YES completion:nil];
        }
    }];
}

- (void)toggleState
{
    if([haLoginActivityIndicator isHidden]){
        [haLoginActivityIndicator startAnimating];
        [haLoginActivityIndicator setHidden:NO];
    }
    else {
        [haLoginActivityIndicator setHidden:YES];
        [haLoginActivityIndicator stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
