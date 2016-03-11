//
//  ReceiptViewController.m
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-10.
//  Copyright © 2016 brulak. All rights reserved.
//

#import "ReceiptViewController.h"

#import "AppDelegate.h"
#import "ReceiptTableViewCell.h"
#import "Receipt.h"
#import "ReceiptSync.h"
#import "FormatHelper.h"


@interface ReceiptViewController ()

@property (weak, nonatomic) IBOutlet UITableView *receiptTable;

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong) UIRefreshControl* refreshControl;
@end

@implementation ReceiptViewController

static NSString *CellIdentifier = @"ReceiptCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.receiptTable.delegate = self;
    self.receiptTable.dataSource = self;
    
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = app.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[Receipt EntityName]];
    
    // Add Sort Descriptors
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"receiptDate" ascending:YES]]];
    
    // Initialize Fetched Results Controller
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    self.navigationItem.title = NSLocalizedString(@"RECIEPT_TITLE", nil);
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.receiptTable addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
}


- (void)refreshTable {
    [ReceiptSync SyncReceipts: ^() {
        [self.refreshControl endRefreshing];
        [self.receiptTable reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sections = [self.fetchedResultsController sections];
    id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}



- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ReceiptTableViewCell *receiptCell = (ReceiptTableViewCell*) cell;
    
    NSManagedObject *record = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSString *receiptName = [record valueForKey:@"receiptName"];
    NSString *displayName = [record valueForKey:@"displayName"];
    
    if([displayName length] < 1)
    {
        [receiptCell.receiptNameLabel setText:receiptName];
    }
    else
    {
        [receiptCell.receiptNameLabel setText:displayName];
    }
    
    NSString* displayDate = [record valueForKey:@"displayDate"];
    if([displayDate length] < 1)
    {
        
        NSString *receiptDate = [record valueForKey:@"receiptDate"];
        [receiptCell.receiptDateLabel setText:[FormatHelper dateFormatInLocalTime: receiptDate]];
        
    }
    else
    {
        [receiptCell.receiptDateLabel setText:displayDate];
    }
    
    NSString* displayAmount = [record valueForKey:@"displayAmount"];
    
    if([displayAmount length] < 1)
    {
        NSDecimalNumber *receiptAmount = [record valueForKey:@"receiptAmount"];
        [receiptCell.receiptAmountLabel setText:[FormatHelper currentyFormatInLocale:receiptAmount]];
    }
    else
    {
        [receiptCell.receiptAmountLabel setText:displayAmount];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ReceiptTableViewCell *cell = (ReceiptTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil)
    {
        [self.receiptTable registerNib:[UINib nibWithNibName:@"ReceiptTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = (ReceiptTableViewCell*) [self.receiptTable dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}



- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:[Receipt EntityName] inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"receiptDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.receiptTable beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.receiptTable;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.receiptTable insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.receiptTable deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.receiptTable endUpdates];
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.receiptTable dequeueReusableCellWithIdentifier:CellIdentifier];
    
    return cell.frame.size.height;
}

@end
