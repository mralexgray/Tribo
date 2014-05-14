#import "TBSiteDocument.h"



@implementation 					  TBSiteDocument

- (void) startPreview:(TBSiteDocumentPreviewCallback)callback 	{	MAWeakSelfDeclare();

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{		__block NSError *error; MAWeakSelfImport();

																									[NSProcessInfo.processInfo disableSuddenTermination];
		if (![self.site process:&error]) return callback(nil, error);
																									 [NSProcessInfo.processInfo enableSuddenTermination];

		if (!self.server) (self.server = TBHTTPServer.new).documentRoot = self.site.destination.path;

		[self.server            start:nil];		
		[self.server         refreshPages];
		[self.sourceWatcher startWatching];		
		[self.postsWatcher   stopWatching];		//	[NSWorkspace.sharedWorkspace openURL:localURL];
		self->_previewIsRunning 	 = YES;	// 
		if (!callback) 				return;  // require that processor returned URL string..

		dispatch_async(dispatch_get_main_queue(), ^{		callback($URL($(@"http://localhost:%d", self.server.listeningPort)), error);		});
	});
	
}
- (void) stopPreview {	[self.sourceWatcher stopWatching]; [self.postsWatcher startWatching]; [self.server stop];	_previewIsRunning = NO;	}

- (CZAFileWatcher*) sourceWatcher {	if (_sourceWatcher) return _sourceWatcher;	MAWeakSelfDeclare();

	_sourceWatcher = [CZAFileWatcher fileWatcherForURLs:@[		self.site.sourceDirectory,
																														self.site.postsDirectory,
																														self.site.templatesDirectory] changesHandler:^(NSA*changedURLs) {

			MAWeakSelfImport(); NSLog(@"URL changed: %@", changedURLs);  [self reloadSite];
	}];
	return _sourceWatcher;
}
- (CZAFileWatcher*) postsWatcher 	{	if (_postsWatcher) return _postsWatcher;	MAWeakSelfDeclare();

	return _postsWatcher = [CZAFileWatcher fileWatcherForURLs:@[self.site.postsDirectory] changesHandler:^(NSA*changedURLs) {	MAWeakSelfImport();																																	 [self reloadSite];	}];
}

- (void) reloadSite { if (self.server.isRunning) { MAWeakSelfDeclare();

		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{			MAWeakSelfImport();	NSError *error;
			
			[AZPROCINFO disableSuddenTermination];	if (![self.site process:&error]) return [NSApp tb_presentErrorOnMainQueue:error];
			[AZPROCINFO enableSuddenTermination];																						[self.server refreshPages];
		});
	}
	else {		NSError *parsingError;	if (![self.site parsePosts:&parsingError])		[NSApp tb_presentErrorOnMainQueue:parsingError];	}
}

- (void) runNewSiteSheet { self.siteSheetController = TBNewSiteSheetController.new;

	[self.siteSheetController runModalForWindow:self.windowForSheet completionHandler:^(NSString *name, NSString *author, NSURL *URL) {
		
		if (!URL) return [self performSelector:@selector(close) withObject:nil afterDelay:0.4]; 		// Close the window after a small delay, so that the sheet has time to close.

		NSError *error 		= nil;
		NSURL *defaultSite 	= [NSBundle.mainBundle URLForResource:@"Default" withExtension:@"tribo"];
		![AZFILEMANAGER copyItemAtURL:defaultSite toURL:URL error:&error] ? [NSApp tb_presentErrorOnMainQueue:error] :
		![self readFromURL:URL ofType:@"tribo" error:&error]              ? [NSApp tb_presentErrorOnMainQueue:error] : nil;
		self.fileURL = URL;
		[self.postsWatcher startWatching];
	}];
}

#pragma mark - NSDocument

//- (BOOL)applicationShouldOpenUntitledFile:(NSAPP*)sender { return NO;  }

+ (BOOL)canConcurrentlyReadDocumentsOfType:(NSString*)typeName 	{ return YES; }

- (void)makeWindowControllers 												{

	TBSiteWindowController *windowController = [TBSiteWindowController new];
	[self windowControllerWillLoadNib:windowController];
	[self addWindowController:windowController];
	[self windowControllerDidLoadNib:windowController];
}
//- (void)windowControllerDidLoadNib:(NSWindowController*)wc			{

//	!self.fileURL ? [self runNewSiteSheet] : [self.postsWatcher startWatching];
//	self.welcome = [AZWelcomeWindowController.alloc initWithWindowNibName:@"AZWelcomeWindow"];
//	[_welcome.window makeKeyAndOrderFront:self];

//}
- (void)updateChangeCount:			  (NSDocumentChangeType)chg		{
	// Do nothing. We don't save things.
}
- (void)updateChangeCountWithToken:(id)chgCtTkn 
						forSaveOperation:(NSSaveOperationType)svOp		{	
	// Again, do nothing. See -updateChangeCount:.
}
- (BOOL)readFromURL:(NSURL*)URL ofType:(NSString*)typeName 
											error:(NSError*__autoreleasing*)outError{
	
	self.site 				= [TBSite siteWithRoot:URL];
	self.site.delegate 	= self;
	
	if ([self.site parsePosts:outError]) return YES;

	[NSApp tb_presentErrorOnMainQueue:*outError];
	*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
	return NO;
}
#pragma mark - TBSiteDelegate
- (void)metadataDidChangeForSite:(TBSite*)site {	[self reloadSite]; }

@end
