//
//  TWloginiewControllerViewController.m
//  Applicatinmatch
//
//  Created by Wathik Almayali on 7/20/14.
//  Copyright (c) 2014 Wathik Almayali. All rights reserved.
//

#import "TWloginiewControllerViewController.h"

@interface TWloginiewControllerViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activititindicater;

@end

@implementation TWloginiewControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activititindicater.hidden=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginfacebookpress:(UIButton *)sender {
    self.activititindicater.hidden = NO;
    [self.activititindicater startAnimating];
    
    NSArray *premissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    [PFFacebookUtils logInWithPermissions:premissionsArray block:^(PFUser *user, NSError *error) {
        [self.activititindicater stopAnimating];
        self.activititindicater.hidden = YES;
        if(!user){
            if (!error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"log in Error" message:@"The Facebook Login was canceled" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
            }
            else {
                UIAlertView *alertView = [[ UIAlertView alloc]
                        initWithTitle:@"log in Error" message:[error description] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil]
                ;
            }
        }
        else {
            [self updateUserInformation];
                [self performSegueWithIdentifier:@"logonToTabBarSegue" sender:self];
            }
            
        
    }];
    
}
#pragma mark - helper Mwthod
-(void)updateUserInformation{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (!error) {
            NSDictionary *userDictionary = (NSDictionary *)result;
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc]initWithCapacity:8];
            if (userDictionary[@"name"]){
                userProfile[@"name"] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"]) {
                
                userProfile[@"first_name"]= userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"][@"name"]) {
                
                userProfile[@"location"] = userDictionary[@"location"][@"name"];
                
            }
            if (userDictionary[@"gender"]) {
                userProfile[@"gender"] = userDictionary[@"gender"];
            }
            if (userDictionary[@"Birthday"]){
                userProfile[@"Birthday"] = userDictionary[@"BirthDay"];
            }
            if (@"intersted_in") {
                userProfile[@"userintersted"]= userDictionary[@"intersted_in"]
                ;
            
            [[PFUser currentUser]setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
            }
            else {
                NSLog(@" Error in facebook request %", error);
            }
        }
     }];
}

@end
