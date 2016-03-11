//
//  ReceiptSync.m
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-11.
//  Copyright © 2016 brulak. All rights reserved.
//

#import "ReceiptSync.h"

#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Receipt.h"
#import "ReceiptViewController.h"
#import "ReceiptSync.h"

@implementation ReceiptSync

+(void) SyncReceipts:(syncCompletion) complete
{
    AppDelegate* app = [[UIApplication sharedApplication] delegate];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://getsensibill.com/api/tests/receipts" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) { //this URL would never be hardcoded IRL
        
        NSArray *receiptArray = [responseObject objectForKey:@"receipts"];
        
        for(NSDictionary* receiptFromJSON in receiptArray)
        {
            NSNumber *receiptID = [receiptFromJSON objectForKey:@"id"];
            NSString *externalID = [receiptID stringValue];
            
            Receipt *receipt = [Receipt receiptWithID:externalID createIfNecessary:YES];
            
            NSDictionary *displayInfo = [receiptFromJSON objectForKey:@"display"];
            
            /*
             this next 3 attributes are already formatteed with currency and date, but this may be redundant,
             because without more context: ie
             - Locale
             - purchased currency
             - etc
             
             It's undeterministic of how we should format the data. So, I'm caching everythign that is available for future use and instead will
             let the UI layer deal with it.
             */
            receipt.displayAmount = [displayInfo objectForKey:@"amount"];
            receipt.displayDate = [displayInfo objectForKey:@"date"];
            receipt.displayName = [displayInfo objectForKey:@"name"];
            
            receipt.receiptAmount = [receiptFromJSON objectForKey:@"receiptAmount"];
            receipt.receiptName = [receiptFromJSON objectForKey:@"receiptName"];
            
            receipt.receiptDate = [receiptFromJSON objectForKey:@"receiptDate"];
            
            [app saveContext];
            if(complete != nil)
            {
                complete();
            }
        }
        
        
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if(complete != nil)
        {
            complete();
        }
        
    }];
    
    
}
@end
