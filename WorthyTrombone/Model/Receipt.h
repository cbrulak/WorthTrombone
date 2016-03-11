//
//  Receipt.h
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-09.
//  Copyright © 2016 brulak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Receipt : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+ (NSString *)EntityName;

+ (Receipt *)createReceipt;

+ (Receipt *)receiptWithID:(NSString *)receiptID;

+ (Receipt *)receiptWithID:(NSString *)receiptID createIfNecessary:(BOOL)create;

@end

NS_ASSUME_NONNULL_END

#import "Receipt+CoreDataProperties.h"
