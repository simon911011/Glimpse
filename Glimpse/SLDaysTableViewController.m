//
//  SLDaysTableViewController.m
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import "SLDaysTableViewController.h"
#import "SLPhotoCell.h"
#import "Day+Management.h"
#import "Days+Management.h"
#import "UIImage+Resize.h"
#import "SSFlatDatePicker.h"

@interface SLDaysTableViewController () {
    ALAssetsLibrary *_library;
    Days *_days;
    NSMutableArray *_temp;
    NSFetchedResultsController *_fetchResultsController;
    NSOperationQueue *_queue;
    NSDate *_date;
}
@property (nonatomic, retain) NSFetchedResultsController *tableFetchedResultsController;

@end
@implementation SLDaysTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        //self.tableView.rowHeight = 220;
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
    
    _library = [[ALAssetsLibrary alloc] init];
    _days = [Days insertDaysWithRound:@1];
    _queue = [[NSOperationQueue alloc] init];
    _date = [NSDate date];
    
    // Configure leftButton
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(menuPressed:)];
    self.navigationItem.leftBarButtonItem = left;
    
    // Configure rightButton
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(addAsset:)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)menuPressed:(id)sender
{
    //[self performSegueWithIdentifier:@"Options" sender:self];
    [self callDP];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Adding Assets

- (IBAction)addAsset:(id)sender
{
    /*
    NSDate *date = [self dateByMovingToBeginningOfDay:[NSDate date]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSArray *objects = fetchManagedObjects(@"Day", predicate, nil, defaultManagedObjectContext());
    if ([objects count] > 0 && ![[self dateByMovingToBeginningOfDay:((Day *)objects[0]).date] isEqualToDate: date]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You already added a photo today!" delegate:self cancelButtonTitle:@"Roger that." otherButtonTitles:nil, nil];
        [alert show];
    } else {*/
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose from library", nil];
    [action showInView:self.tableView];
    //}
}

- (void)assetFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        picker.allowsEditing = YES;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)assetFromLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - Actionsheet Delegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Take Photo"]) {
        [self assetFromCamera];
    }
    if ([title isEqualToString:@"Choose from library"]) {
        [self assetFromLibrary];
    }
}


#pragma mark - UIImagePickerController Delegate Method
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Check if we are doing an update or a create
    BOOL createNew = YES;
    NSDate *date = [self dateByMovingToBeginningOfDay:[NSDate date]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSArray *objects = fetchManagedObjects(@"Day", predicate, nil, defaultManagedObjectContext());
    if ([objects count] > 0) {
        // update, don't create new
        createNew = NO;
    }
    // Save new asset to photo album.
    if (![info objectForKey:UIImagePickerControllerReferenceURL])
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [_library writeImageToSavedPhotosAlbum:[image CGImage]
                                   orientation:(ALAssetOrientation)[image imageOrientation]
                               completionBlock:^(NSURL *assetURL, NSError *error) {
                                   // This will also save the asset to Core Data
                                   // NSLog(@"Save with date: %@", [self dateByMovingToBeginningOfDay:[NSDate date]]);
                                   //NSLog(@"%d", createNew);
                                   if (createNew) {
                                       Day *day = [Day insertDayWithDate:date
                                                                     URL:[assetURL absoluteString]
                                                               MediaType:@"Photo"
                                                                  Parent:_days];
                                       [_days addChildrenObject:day];
                                   } else {
                                       Day *existingDay = objects[0];
                                       existingDay.date = date;
                                       existingDay.url = [assetURL absoluteString];
                                   }
                                   if (!commitDefaultMOC())
                                   {
                                       NSLog(@"Error saving new Day.");
                                   }
                               }];
    }
    else
    {
        // NSLog(@"Save with date: %@", [self dateByMovingToBeginningOfDay:[NSDate date]]);
        if (createNew) {
        Day *day = [Day insertDayWithDate:[self dateByMovingToBeginningOfDay:[NSDate date]] URL:[[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString] MediaType:@"Photo" Parent:_days];
        [_days addChildrenObject:day];
        } else {
            Day *existingDay = objects[0];
            existingDay.date = date;
            existingDay.url = [[info objectForKey:UIImagePickerControllerReferenceURL] absoluteString];
        }
        if (!commitDefaultMOC())
        {
            NSLog(@"Error saving the day.");
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSDate *)dateByMovingToBeginningOfDay: (NSDate *)date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:date];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[[self fetchedResultsController] sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    /*
    Day *day = (Day *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSLog(@"DAY %d: %@", indexPath.row, day.url);
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = day.url;
    */
    
    if (![cell.backgroundView isKindOfClass:[SLPhotoCell class]])
    {
        cell.backgroundView = [[SLPhotoCell alloc] init];
    }
    
    if (![cell.selectedBackgroundView isKindOfClass:[SLPhotoCell class]])
    {
        cell.selectedBackgroundView = [[SLPhotoCell alloc] init];
    }
    cell.backgroundView.opaque = NO;
    cell.selectedBackgroundView.opaque = NO;
    //cell.backgroundColor = [UIColor blueColor];

    [self configureCell:cell atIndexPath:indexPath animated:YES];
    
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
	Day *day = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:day.url];
    [_library assetForURL:url resultBlock:^(ALAsset *asset) {
        UIImageView *cellImage = (UIImageView *)[cell viewWithTag:2];
        cellImage.image = [UIImage imageWithCGImage:[asset thumbnail]];
        
        /*[[NSOperationQueue mainQueue] addOperationWithBlock:^{
            ALAssetRepresentation *rep = [asset defaultRepresentation];
            NSDictionary *meta = [rep metadata];
            NSLog(@"%@", [meta[@"Orientation"] class]);
            CGImageRef iref = [rep fullResolutionImage];
            
            if (iref) {
                cell.imageView.image = [UIImage imageWithCGImage:iref scale:1.0 orientation:UIImageOrientationRight];
            }
        }];*/
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    UILabel *monthLabel = (UILabel *)[cell viewWithTag:3];
    UILabel *dayLabel = (UILabel *)[cell viewWithTag:4];
    NSDateComponents *dateComponents = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]
                                        components:(NSDayCalendarUnit | NSMonthCalendarUnit)
                                        fromDate:day.date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    monthLabel.text =  [NSString stringWithFormat:@"%@", dateFormatter.shortMonthSymbols[dateComponents.month-1]];
    dayLabel.text =  [NSString stringWithFormat:@"%d", dateComponents.day];
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark NSFetchedResultsController set up
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchResultsController != nil)
    {
        return _fetchResultsController;
    }
    
    NSManagedObjectContext *moc = defaultManagedObjectContext();
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Day" inManagedObjectContext:moc];
    [request setEntity:entityDescription];
    
    [request setFetchBatchSize: 20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController =
                        [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                            managedObjectContext:moc
                                                              sectionNameKeyPath:nil
                                                                       cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    _fetchResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![_fetchResultsController performFetch:&error])
    {
        NSLog(@"Error: %@", error);
    }
    
    return _fetchResultsController;
}

#pragma mark NSFecthedResultsController Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath
                       animated:YES];
            break;
        
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


#pragma mark - DatePicker

- (void)changeDate:(UIDatePicker *)sender {
    //NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:sender.date];
    _date = sender.date;
}

- (void)setDailyNotification: (NSDate *)date
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    UILocalNotification *notif = [[UILocalNotification alloc] init];
    NSCalendar *gregCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregCalendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    //NSLog(@"New time: %d:%d", [dateComponents hour], [dateComponents minute]);
    //[dateComponents setHour:16];
    [notif setFireDate:[gregCalendar dateFromComponents:dateComponents]];
    [notif setAlertBody:@"Take a new photo today!"];
    [notif setRepeatInterval:NSDayCalendarUnit];
    [notif setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
}


- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:12] removeFromSuperview];
    [[self.view viewWithTag:13] removeFromSuperview];
    [[self.navigationController.view viewWithTag:99] removeFromSuperview];
}

- (void)dismissDatePicker {
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [self.navigationItem setTitle:@"Glimpse"];
    UIView *reminderView = [self.navigationController.view viewWithTag:99];
    [self.tableView setScrollEnabled:YES];
    
    CGRect datePickerTargetFrame = CGRectMake(0, reminderView.bounds.size.height + reminderView.bounds.origin.y, 320, 216);
    CGRect clearTargetFrame = CGRectMake(reminderView.bounds.origin.x, reminderView.bounds.origin.y-200, 320, 100);
    CGRect setTargetFrame = CGRectMake(reminderView.bounds.origin.x, reminderView.bounds.origin.y-100, 320, 100);

    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:12].frame = clearTargetFrame;
    [self.view viewWithTag:13].frame = setTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)callDP {
    [self.navigationItem setTitle:@"Daily Reminder"];
    [self.tableView setScrollEnabled:NO];
    UIView *reminderView = [[UIView alloc] initWithFrame:self.view.frame];
    reminderView.tag = 99;
    [self.navigationController.view addSubview:reminderView];
    
    CGRect pickerTargetFrame = CGRectMake(0, reminderView.bounds.size.height+ reminderView.bounds.origin.y-216, 320, 216);
    CGRect clearTargetFrame = CGRectMake(0, reminderView.bounds.origin.y+64, 320, 100);
    CGRect setTargetFrame = CGRectMake(0, reminderView.bounds.origin.y+164, 320, 100);
    
    SSFlatDatePicker *picker = [[SSFlatDatePicker alloc] initWithFrame:CGRectMake(0, reminderView.bounds.size.height + reminderView.bounds.origin.y, 320, 216)];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker.datePickerMode = SSFlatDatePickerModeTime;
    picker.tag = 10;
    [picker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [reminderView addSubview:picker];
        
    UIButton *clearView = [UIButton buttonWithType:UIButtonTypeCustom];
    clearView.frame = CGRectMake(0, reminderView.bounds.origin.y-200, 320, 100);
    clearView.tag = 12;
    [clearView setTitle:@"Clear" forState:UIControlStateNormal];
    clearView.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:55.0/255.0 blue:61.0/255.0 alpha:1.0];
    clearView.titleLabel.textAlignment = NSTextAlignmentCenter;
    clearView.titleLabel.textColor = [UIColor whiteColor];
    clearView.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    [clearView addTarget:self action:@selector(clearPressed:) forControlEvents:UIControlEventTouchUpInside];
    [reminderView addSubview:clearView];
    
    UIButton *setView = [UIButton buttonWithType:UIButtonTypeCustom];
    setView.frame = CGRectMake(0, reminderView.bounds.origin.y-100, 320, 100);
    setView.tag = 13;
    [setView setTitle:@"Set" forState:UIControlStateNormal];
    setView.backgroundColor = [UIColor colorWithRed:22.0/255.0 green:160.0/255.0 blue:133.0/255.0 alpha:1.0];
    setView.titleLabel.textAlignment = NSTextAlignmentCenter;
    setView.titleLabel.textColor = [UIColor whiteColor];
    setView.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40];
    [setView addTarget:self action:@selector(setPressed:) forControlEvents:UIControlEventTouchUpInside];
    [reminderView addSubview:setView];
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker setDate:_date];
    });
     
    [UIView beginAnimations:@"MoveIn" context:nil];
    picker.frame = pickerTargetFrame;
    clearView.frame = clearTargetFrame;
    setView.frame = setTargetFrame;
    [UIView commitAnimations];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void) clearPressed:(id)sender
{
    [self dismissDatePicker];
}

-(void) setPressed:(id)sender
{
    [self setDailyNotification:_date];
    [self dismissDatePicker];
}

@end
