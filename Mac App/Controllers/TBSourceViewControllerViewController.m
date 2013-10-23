//
//  TBSourceViewControllerViewController.m
//  Tribo
//
//  Created by Samuel Goodwin on 2/22/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import "TBSourceViewControllerViewController.h"
#import "TBAsset.h"
#import "AZWebPreviewViewController.h"

@implementation TBSourceViewControllerViewController

- (NSString*)defaultNibName 	{	return @"TBSourceViewControllerView";	}
- (NSString*)title 				{	return @"Sources";							}

- (void)awakeFromNib {

    _outlineView.delegate 		= self;
    _outlineView.target   		= self;
    _outlineView.doubleAction = @selector(doubleClickRow:);
}

- (void)doubleClickRow:(NSOutlineView*)outlineView {

    NSA * assets 		= self.assetTree.selectedObjects;
    NSA * assetURLS 	= [assets vFK:@"URL"];

    [assetURLS enumerateObjectsUsingBlock:^(id obj, NSUI idx, BOOL *stop) {

        BOOL fileOpened = 	[AZWORKSPACE openURLs:@[obj] withAppBundleIdentifier:nil options:NSWorkspaceLaunchAsync
																additionalEventParamDescriptor:nil launchIdentifiers:NULL];
			if (!fileOpened) [AZWORKSPACE openURLs:@[obj] withAppBundleIdentifier:@"com.apple.TextEdit" options:NSWorkspaceLaunchAsync
																 additionalEventParamDescriptor:nil launchIdentifiers:NULL];
    }];
}

- (void) outlineViewSelectionDidChange:(NSNotification*)notification { AZLOGCMD;

//- (void) outlineView:(NSOutlineView*)outlineView willDisplayOutlineCell:(id)cell forTableColumn:(NSTableColumn*)tableColumn item:(id)item { 
//	XX(self.view.window.aceView);

   NSA * assets = [_assetTree.selectedObjects vFKP:@"URL"];
	NSURL 	* u = assets[0];

	NSAssert(u.class == NSURL.class, @"must be a url");

	XX(self.view.window.aceView);

	[self.view.window.aceView setURL:u];

	// [NSS stringWithContentsOfURL:u encoding:NSUTF8StringEncoding error:nil]];
	//	setContent:u mode:ACEModeHandlebars];
	//	[AZNOTCENTER postNotification:[NSNOT notificationWithName:AZNewSourceSelectedNotification object:assets[0]]];
}
@end
