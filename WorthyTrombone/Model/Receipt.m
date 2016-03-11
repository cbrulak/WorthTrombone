//
//  Receipt.m
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-09.
//  Copyright © 2016 brulak. All rights reserved.
//

#import "Receipt.h"

#import "AppDelegate.h"

@implementation Receipt

// Insert code here to add functionality to your managed object subclass




+ (NSString *)EntityName {
    // This will return `LLClaim` even though it's in the category
    return NSStringFromClass([self class]);
}

+ (Receipt *)createReceipt {
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    
    
    return [NSEntityDescription insertNewObjectForEntityForName:[self EntityName] inManagedObjectContext:app.managedObjectContext];
}


+ (Receipt *)receiptWithID:(NSString *)receiptID {
    
    if( receiptID == nil )
        return ( nil );
    
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = app.managedObjectContext;
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"externalID == %@", receiptID];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity: [NSEntityDescription entityForName:[self EntityName] inManagedObjectContext:moc]];
    [request setPredicate: predicate];
    [request setFetchLimit:1];
    
    NSError *error = nil;
    NSArray *results = [moc executeFetchRequest: request error: &error];
    Receipt *receipt = [results lastObject];
    
    if( error != nil ) {
        NSLog(@"Error getting Receipt with ID %@", receiptID);
    }
    
    return receipt;
}

+ (Receipt *)receiptWithID:(NSString *)receiptID createIfNecessary:(BOOL)create {
    
    Receipt *receipt = [self receiptWithID:receiptID];
    if( receipt != nil || !create ) { return receipt; }
    
    receipt = [self createReceipt];
    receipt.externalID  = receiptID;
    
    return receipt;
}


@end
