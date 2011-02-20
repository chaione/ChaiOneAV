//
//  C1ContentViewController.m
//  C1ContentViewController
//
//  Created by Kevin Lee on 2/10/11.
//  Copyright 2011 ChaiONE Inc. All rights reserved.
//

#import "CHMediaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import "UIApplication+ScreenMirroring.h"

@implementation CHMediaViewController
@synthesize mediaItem = _mediaItem;

- (void)setupMediaPlayerView {
	NSURL *url = [[[NSURL alloc]initFileURLWithPath:self.mediaItem.path] autorelease];
	
	[_player release];
	
	_player = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[_player setShouldAutoplay:NO];
	[_player setFullscreen:YES animated:YES];
	[_player setRepeatMode:MPMovieRepeatModeOne];
	self.view = _player.view;
}

- (void)refreshView {	
	if ([self.mediaItem.mimeType isEqualToString:@"video/h264"]) {
		[self setupMediaPlayerView];
	} 
	return;
}

- (void)setMediaItem:(id <CHMediaItem>)value {
	[(id)_mediaItem release];
	_mediaItem = [(id)value retain];
	[self refreshView];
	[self.view setNeedsDisplay];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[_player stop];
	[_player release];
	_player = nil;
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self refreshView];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	// Drop the movie
	[_player stop];
	[_player release];
	_player = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[_webView release];
	[(id)_mediaItem release];
	[_player release];
    [super dealloc];
}


@end
