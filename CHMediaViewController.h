//
//  C1ContentViewController.h
//  C1ContentViewController
//
//  Created by Kevin Lee on 2/10/11.
//  Copyright 2011 ChaiONE Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CHMediaItem.h"
#import "CHOffscreenMediaPlayerView.h"

@interface CHMediaViewController : UIViewController {
	id<CHMediaItem> _mediaItem;
	MPMoviePlayerController *_player;
	UIWebView* _webView;
	UIWindow *_mirroredWindow;
	UIScreen *_mirroredScreen;
	CHOffscreenMediaPlayerView *_offscreenView;
}
@property (nonatomic, retain) id<CHMediaItem> mediaItem;

@end
