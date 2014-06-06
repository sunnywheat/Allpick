//
//  MenuListTableViewController.m
//  RT
//
//  Created by yiqin on 5/25/14.
//  Copyright (c) 2014 telerik. All rights reserved.
//

#import "MenuListTableViewController.h"
#import <Colours.h>
#import "CartSummary.h"
#import "MenuViewController.h"


@interface MenuListTableViewController ()
@property (nonatomic,strong) NSArray *colorButtonArray;

@end

@implementation MenuListTableViewController

@synthesize delegate;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        self.objectsPerPage = 10;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.cart = [[NSMutableDictionary alloc] init];
    
    UIColor *newColor = [UIColor waveColor];
    self.colorButtonArray = [newColor colorSchemeOfType:ColorSchemeAnalagous];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

*/
 
- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:@"MenuGreatWall"];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *weekday = [[NSDateFormatter alloc] init];
    [weekday setDateFormat: @"EEEE"];    
    [query whereKey:[weekday stringFromDate:now] equalTo:@"YES"];
    
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *) object
{
    static NSString *simpleTableIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *nameLabel = (UILabel *) [cell viewWithTag:100];
    nameLabel.text = [object objectForKey:@"name"];
    
    UILabel *nameEnglishLabel = (UILabel *) [cell viewWithTag:102];
    nameEnglishLabel.text = [object objectForKey:@"nameEnglish"];
    
    PFFile *thumbnail = [object objectForKey:@"imageFile"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:101];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];
    
    UIButton *colorButton = (UIButton *) [cell viewWithTag:103];
    int i = indexPath.row%4;
    [colorButton setBackgroundColor:[self.colorButtonArray objectAtIndex:i]];

    
    // Dynamically add buttons
    // add button
    UIButton *addDishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addDishButton.tag = indexPath.row;
    addDishButton.frame = CGRectMake(88.0f, 5.0f, 75.0f, 30.0f);
    [addDishButton setTitle:@"Add" forState:UIControlStateNormal];
    [addDishButton setBackgroundColor:[UIColor black25PercentColor]];
    [addDishButton setTintColor:[UIColor whiteColor]];
    [cell addSubview:addDishButton];
    [addDishButton addTarget:self
                      action:@selector(addDish:)
            forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // minus button
    UIButton *minusDishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    minusDishButton.tag = indexPath.row;
    minusDishButton.frame = CGRectMake(250.0f, 5.0f, 75.0f, 30.0f);
    [minusDishButton setTitle:@"Delete" forState:UIControlStateNormal];
    [minusDishButton setBackgroundColor:[UIColor black25PercentColor]];
    [minusDishButton setTintColor:[UIColor whiteColor]];
    [cell addSubview:minusDishButton];
    [minusDishButton addTarget:self
                        action:@selector(minusDish:)
              forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)addDish: (UIButton*) sender {
    PFObject* selectedDish = [self.objects objectAtIndex:sender.tag];
    NSString* dishName = [selectedDish objectForKey:@"name"];
    NSNumber* i = @0;
    
    if (![self.cart objectForKey:dishName]) {
        [self.cart setValue:@1 forKey:dishName];
    }
    else {
        i = @([[self.cart valueForKey:dishName] integerValue]+1);
        [self.cart setValue:i forKey:dishName];
    }

    [self fetchingText];
}

- (void)minusDish:(UIButton*) sender {
    PFObject* selectedDish = [self.objects objectAtIndex:sender.tag];
    NSString* dishName = [selectedDish objectForKey:@"name"];
    NSNumber* i = @0;
    
    if (![self.cart objectForKey:dishName]) {

    }
    else {
        i = @([[self.cart valueForKey:dishName] integerValue]-1);
        if ([i integerValue] == 0) {
            [self.cart   removeObjectForKey:dishName];
        }
        else {
            [self.cart setValue:i forKey:dishName];
        }
    }
    
    [self fetchingText];
    
}

-(void)fetchingText
{
    NSMutableString *tempCart = [[NSMutableString alloc] initWithString:@"ORDER "];
    int i = 0;
    for (id key in self.cart) {
        [tempCart appendFormat:@"%@: %li, ", key, (long)[[self.cart objectForKey:key] integerValue]];
        i = i + [[self.cart objectForKey:key] intValue];
    }
    
    BOOL tempEmpty = YES;
    if ([tempCart isEqualToString:@"ORDER "]) {
        tempEmpty = NO;
    }
        
    NSString* cartSummary = [NSMutableString stringWithFormat:@"%@PLACE: %@.", tempCart, [CartSummary getSomeData]];
    
    if ([delegate respondsToSelector:@selector(updateCartSummary:fetchedText:dishCount:notEmpty:)]) {
        [delegate updateCartSummary:self fetchedText:cartSummary dishCount:i notEmpty:tempEmpty];
    }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
