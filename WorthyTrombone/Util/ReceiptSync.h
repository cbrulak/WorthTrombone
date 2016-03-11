//
//  ReceiptSync.h
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-11.
//  Copyright © 2016 brulak. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^syncCompletion)();

@interface ReceiptSync : NSObject

+(void) SyncReceipts:(syncCompletion) complete;

@end
