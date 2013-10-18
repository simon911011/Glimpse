//
//  SLDaysTableViewController.h
//  CoreDataSample
//
//  Created by Shao Ping Lee on 8/1/13.
//  Copyright (c) 2013 Shao-Ping Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SLDaysTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addAsset;

- (IBAction)addAsset:(id)sender;

@end

