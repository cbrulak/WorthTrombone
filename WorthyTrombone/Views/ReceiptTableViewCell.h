//
//  ReceiptTableViewCell.h
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-11.
//  Copyright © 2016 brulak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiptTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *receiptNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiptDateLabel;

@end
