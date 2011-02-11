//
//  CHOffScreenMediaPlayerView.m
//  ChaiOneAV
//
//  Created by Kevin Lee on 2/11/11.
//  Copyright 2011 Q Technology Company. All rights reserved.
//

#import "CHOffscreenMediaPlayerView.h"


@implementation CHOffscreenMediaPlayerView
@synthesize playButton;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor blackColor];
		self.userInteractionEnabled = YES;
		
		self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.playButton.titleLabel.text = @"Play";
		self.playButton.frame = CGRectMake(0, 0, 50, 50);
		[self addSubview:self.playButton];

    }
    return self;
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	self.playButton.center = CGPointMake(rect.size.width/2, rect.size.height/2);
}

- (void)dealloc {
	self.playButton = nil;
    [super dealloc];
}


@end
