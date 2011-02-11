//
//  C1Content.h
//  C1ContentViewController
//
//  Created by Kevin Lee on 2/10/11.
//  Copyright 2011 ChaiONE Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CHMediaItem

@property (nonatomic, copy) NSString * mimeType;
@property (nonatomic, copy) NSString * path;
@property (nonatomic, copy) NSString * thumbPath;

@end
