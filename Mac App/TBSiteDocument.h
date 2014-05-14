//
//  TBSiteDocument.h
//  Tribo
//
//  Created by Carter Allen on 10/3/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//

#import "TBSiteWindowController.h"
#import "TBNewSiteSheetController.h"
#import "TBSite.h"
#import "TBMacros.h"
#import "TBHTTPServer.h"
#import "NSResponder+TBAdditions.h"
#import "CZAFileWatcher.h"
#import "AZWelcomeWindowController.h"

typedef void(^TBSiteDocumentPreviewCallback)(NSURL *localURL, NSError *error);

//@class TBSite, TBHTTPServer, AZWebPreviewViewController;

@interface 						  TBSiteDocument : NSDocument <TBSiteDelegate>

@property (weak)    AZWebPreviewViewController * webView;
@property																TBSite * site;
@property													TBHTTPServer * server;
@property ( readonly) 					   BOOL   previewIsRunning;

@property (nonatomic) 				   CZAFileWatcher * sourceWatcher,
																								* postsWatcher;
@property (nonatomic)  TBNewSiteSheetController * siteSheetController;
@property (nonatomic) AZWelcomeWindowController * welcome;

- (void) startPreview:(TBSiteDocumentPreviewCallback)callback;
- (void) stopPreview;

@end
