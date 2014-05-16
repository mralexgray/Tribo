@import AtoZ;
//
//  TBPostsViewController.m
//  Tribo
//
//  Created by Carter Allen on 10/24/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//

#import "TBPostsViewController.h"
#import "TBAddPostSheetController.h"
#import "TBSiteDocument.h"
#import "TBSite.h"
#import "TBPost.h"
#import "TBTableView.h"
#import "TBHTTPServer.h"
#import "NSResponder+TBAdditions.h"

#import "AZWebPreviewViewController.h"


@interface TBPostsViewController () <TBTableViewDelegate>
- (void) moveURLsToTrash:			(NSA*)URLs;
- (void) undoMoveToTrashForURLs:	(NSD*)URLs;
@end

@implementation TBPostsViewController

#pragma mark - View Controller Configuration

- (NSString*)defaultNibName 	{	return @"TBPostsView";	}
- (NSString*)title 				{	return @"Posts";			}

- (void)viewDidLoad {
	self.postTableView.delegate = self;
	self.postTableView.target = self;
	self.postTableView.doubleAction = @selector(editPost:);
}

- (void) tableViewSelectionDidChange:(NSNotification*)notification {

//AZTALK(@"vageen");

//	NSA * assets = [_assetTree.selectedObjects vFKP:@"URL"];
//	NSURL 	* u = assets[0];
//
//	NSAssert(u.class == NSURL.class, @"must be a url");
//
//	XX(self.view.window.aceView);
//
//	[self.view.window.aceView setURL:u];

}

-(TBPost*) selectedPost {  return ((TBSiteDocument*)self.document).site.posts[self.postTableView.clickedRow]; }

#pragma mark - Actions

- (IBAction)editPost:(id)sender {	[self.view.window.aceView setURL:self.selectedPost.URL];  } //	[AZWORKSPACE openURL:clickedPost.URL];
- (IBAction)previewPost:(id)sender {

	NSDateFormatter *formatter 	= NSDateFormatter.new;
	formatter.dateFormat 			= @"yyyy/MM/dd";
	NSString *postURLPrefix 		= [[formatter stringFromDate:self.selectedPost.date] withPath:self.selectedPost.slug];
	NSURL *postPreviewURL 			= [NSURL URLWithString:postURLPrefix relativeToURL:$URL($(@"http://localhost:%d", self.document.server.listeningPort))];
	[(WebView*)[self.view.window subviewWithClass:WebView.class]setMainFrameURL:postPreviewURL.path];
//	[AZWORKSPACE openURL:postPreviewURL];

}

- (IBAction)revealPost:(id)sender {
	TBPost *clickedPost = (self.document.site.posts)[[self.postTableView clickedRow]];
	[[NSWorkspace sharedWorkspace] selectFile:clickedPost.URL.path inFileViewerRootedAtPath:nil];
}

- (void)tableView:(NSTableView*)tableView shouldDeleteRows:(NSIndexSet*)rowIndexes {

	NSA*selectedPosts = [self.document.site.posts objectsAtIndexes:rowIndexes];
	NSA*postURLs = [selectedPosts valueForKey:@"URL"];
	[self moveURLsToTrash:postURLs];
}

- (void)moveURLsToTrash:(NSA*)URLs {
	[[NSWorkspace sharedWorkspace] recycleURLs:URLs completionHandler:^(NSD *newURLs, NSError *error) {
		
		if (error) [self tb_presentErrorOnMainQueue:error];
		
		[self.document.undoManager registerUndoWithTarget:self selector:@selector(undoMoveToTrashForURLs:) object:newURLs];
		[self.document.undoManager setActionName:@"Move to Trash"];
		
		NSError *postParsingError = nil;
		BOOL success = [self.document.site parsePosts:&postParsingError];
		if (!success) [self tb_presentErrorOnMainQueue:postParsingError];
		
	}];
}

- (void)undoMoveToTrashForURLs:(NSD*)URLs {
	[URLs enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
		NSURL *originalURL = key;
		NSURL *trashURL = object;
		NSError *error = nil;
		BOOL success = [AZFILEMANAGER moveItemAtURL:trashURL toURL:originalURL error:&error];
		if (!success) [self tb_presentErrorOnMainQueue:error];
		NSError *postParsingError = nil;
		success = [self.document.site parsePosts:&postParsingError];
		if (!success) [self tb_presentErrorOnMainQueue:postParsingError];
	}];
	[self.document.undoManager registerUndoWithTarget:self selector:@selector(moveURLsToTrash:) object:URLs.allKeys];
	[self.document.undoManager setActionName:@"Move to Trash"];
}

#pragma mark - QuickLook Support

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel*)panel {	return self.document.site.posts.count;	}

- (BOOL)previewPanel:(QLPreviewPanel*)panel handleEvent:(NSEvent*)event {	return NO;	}

- (NSRect)previewPanel:(QLPreviewPanel*)pnl sourceFrameOnScreenForPreviewItem:(id <QLPreviewItem>)item {		NSUInteger index = 0;

	for (index = 0; index < self.document.site.posts.count; index++)
		if ([((TBPost*)(self.document.site.posts)[index]).URL isEqual:item]) continue;
	return [self.postTableView rectOfRow:index];
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel*)pnl previewItemAtIndex:(NSI)idx {	return ((TBPost*)self.document.site.posts[idx]).URL;	}

@end
