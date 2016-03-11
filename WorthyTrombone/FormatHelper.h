//
//  FormatHelper.h
//  WorthyTrombone
//
//  Created by Chris Brulak on 2016-03-11.
//  Copyright © 2016 brulak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormatHelper : NSObject

+(NSString*) currentyFormatInLocale:(NSDecimalNumber*) number;

+(NSString*) dateFormatInLocalTime:(NSString*) dateFromAPI;

@end
