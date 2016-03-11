//
//  Receipt+CoreDataProperties.h
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-09.
//  Copyright © 2016 brulak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Receipt.h"

NS_ASSUME_NONNULL_BEGIN

@interface Receipt (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *receiptName;
@property (nullable, nonatomic, retain) NSString *receiptDate;
@property (nullable, nonatomic, retain) NSDecimalNumber *receiptAmount;
@property (nullable, nonatomic, retain) NSString *externalID;
@property (nullable, nonatomic, retain) NSString *displayAmount;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *displayDate;

@end

NS_ASSUME_NONNULL_END
