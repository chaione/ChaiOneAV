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

- (void)playStop {
	if(_player.currentPlaybackRate == 0.0){
		[_player play];
	} else {
		[_player pause];
	}
}

- (void) setupMirroringForScreen:(UIScreen *)anExternalScreen {       	
	// Set the new screen to mirror
	BOOL done = NO;
	UIScreenMode *mainScreenMode = [UIScreen mainScreen].currentMode;
	for (UIScreenMode *externalScreenMode in anExternalScreen.availableModes) {
		if (CGSizeEqualToSize(externalScreenMode.size, mainScreenMode.size)) {
			// Select a screen that matches the main screen
			anExternalScreen.currentMode = externalScreenMode;
			done = YES;
			break;
		}
	}
	
	if (!done && [anExternalScreen.availableModes count]) {
		anExternalScreen.currentMode = [anExternalScreen.availableModes objectAtIndex:0];
	}
	
	[_mirroredScreen release];
	_mirroredScreen = [anExternalScreen retain];
	
	// Setup window in external screen	
	UIWindow *newWindow = [[UIWindow alloc] initWithFrame:_mirroredScreen.bounds];
	newWindow.opaque = YES;
	newWindow.hidden = NO;
	newWindow.backgroundColor = [UIColor blackColor];
	newWindow.layer.contentsGravity = kCAGravityResizeAspect;
	[_mirroredWindow release];
	_mirroredWindow = [newWindow retain];
	_mirroredWindow.screen = _mirroredScreen;
	[newWindow release];
}


- (BOOL)isConnectedToScreen {
	NSArray *connectedScreens = [UIScreen screens];
	return [connectedScreens count]>1;
}

- (void)setupPlayerControls {
	if (_offscreenView) {
		[_offscreenView removeFromSuperview];
		[_offscreenView release];
	}

	_offscreenView = [[CHOffscreenMediaPlayerView alloc] initWithFrame:CGRectZero] ;
	[_offscreenView.playButton addTarget:self action:@selector(playStop) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview: _offscreenView];
}

- (void)pushMoviePlayerToExternalScreen {
	NSArray *connectedScreens = [UIScreen screens];
	if ([connectedScreens count] > 1) {
		UIScreen *mainScreen = [UIScreen mainScreen];
		for (UIScreen *aScreen in connectedScreens) {
			if (aScreen != mainScreen) {
				// We've found an external screen !
				NSLog(@"We have an external screen!");
				[self setupMirroringForScreen:aScreen];
				_player.view.frame = _mirroredWindow.frame;
				[_mirroredWindow addSubview:_player.view];
				[_player play];
				break;
			}
		}
	}				
}

- (void)setupMediaPlayerView {
	NSURL *url = [[[NSURL alloc]initFileURLWithPath:self.mediaItem.path] autorelease];
	_player = [[MPMoviePlayerController alloc] initWithContentURL:url];
	[_player setShouldAutoplay:NO];
	[_player setFullscreen:YES animated:YES];
	
	if ([self isConnectedToScreen]) {
		[self setupPlayerControls];
		[self pushMoviePlayerToExternalScreen];
	} else {
		self.view = _player.view;
	}
}

- (void)setupPDFView {
	UIWebView *web				= [[UIWebView alloc] init];
	NSURL* pdfURL				= [[[NSURL alloc] initFileURLWithPath:self.mediaItem.path] autorelease];
	NSURLRequest* pdfRequest	= [NSURLRequest requestWithURL:pdfURL];
	
	[web loadRequest:pdfRequest];
	
	//NSData *pdfData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.mediaItem.path]];
	//[web loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:self.mediaItem.path]];

	self.view = web;
	
	//	if ([self isConnectedToScreen]) {
	//		//Need to hook in our new PDF view here.
	//		[[UIApplication sharedApplication] setupScreenMirroringWithFramesPerSecond:ScreenMirroringDefaultFramesPerSecond];	
	//	}
}
- (void)refreshView {	
	if ([self.mediaItem.mimeType isEqualToString:@"application/pdf"]) {
		[self setupPDFView];
	} else {
		[self setupMediaPlayerView];
	}
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

- (void)stopMirroredDisplay {
	[[UIApplication sharedApplication] disableScreenMirroring];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	if (_mediaItem) {
		_mediaItem = nil;	
	}
	
	if(_player) {
		[_player release];
		_player = nil;
	}
	if(_mirroredWindow) {
		[_mirroredWindow release];
	}
	if(_mirroredScreen) {
		[_mirroredScreen release];
	}
	if(_offscreenView) {
		[_offscreenView release];
	}
    [super dealloc];
}


@end
