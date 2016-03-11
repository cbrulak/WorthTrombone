//
//  FormatHelper.m
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-11.
//  Copyright © 2016 brulak. All rights reserved.
//

#import "FormatHelper.h"

@implementation FormatHelper


+(NSString*) currentyFormatInLocale:(NSDecimalNumber*) number
{
    static NSNumberFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    
    
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *localizedMoneyString = [formatter stringFromNumber:number];
    
    return localizedMoneyString;
    
}

+(NSString*) dateFormatInLocalTime:(NSString *)dateFromAPI
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormat setTimeZone:timeZone];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    NSDate *receiptDateAsDate = [dateFormat dateFromString: dateFromAPI];
    
    [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormat setDateFormat:@"MMMM d, yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate: receiptDateAsDate];
    
    return dateString;
}

@end
