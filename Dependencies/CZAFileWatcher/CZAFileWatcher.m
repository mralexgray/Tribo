
#import "CZAFileWatcher.h"

@interface 								 CZAFileWatcher () {	BOOL _eventStreamIsRunning;	}
@property (readonly) TBFileWatcherChangesHandler  changesHandler;
@property (nonatomic)			  FSEventStreamRef  eventStream;

static void eventCallback (	     ConstFSEventStreamRef eStrRf,  void *cbkInfo, size_t nEvs, void*ePths,
									const FSEventStreamEventFlags eFlgs[], const FSEventStreamEventId eIds[]);
@end

@implementation CZAFileWatcher

#pragma mark - Initialization and Deallocation

+ (instancetype) fileWatcherForURLs:(NSA*)URLs changesHandler:(TBFileWatcherChangesHandler)changesHandler {
	return [self.class.alloc initForURLs:URLs changesHandler:changesHandler];
}

- (id)initForURLs:(NSA*)URLs changesHandler:(TBFileWatcherChangesHandler)changesHandler {
	if (self != super.init) return nil;
	_URLs = [URLs copy];
	_changesHandler = [changesHandler copy];
	[self cza_createEventStream];
	if (!_eventStream) return nil;
	return self;
}

- (void)dealloc {	if (_eventStreamIsRunning)	FSEventStreamStop(_eventStream);	FSEventStreamInvalidate(_eventStream);	FSEventStreamRelease(_eventStream);	}

#pragma mark - Event Stream Interaction

- (void)startWatching {
	if (!_eventStreamIsRunning) {
		FSEventStreamSetDispatchQueue(self.eventStream, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
		FSEventStreamStart(self.eventStream);
	}
	_eventStreamIsRunning = YES;
}

- (void)stopWatching { if (_eventStreamIsRunning) { FSEventStreamStop(self.eventStream); FSEventStreamInvalidate(self.eventStream);	}

	_eventStreamIsRunning = NO;
}
#ifdef release
#undef release
#endif
- (void)cza_createEventStream {
	FSEventStreamContext context = {	.version 			= 0,
												.info 				= (__bridge void*)self,
												.retain 				= NULL,
												.release 			= NULL,
												.copyDescription 	= NULL		};
	CFArrayRef paths = (__bridge CFArrayRef)[self.cza_directoryURLs valueForKey:@"path"];
	FSEventStreamRef eventStream = FSEventStreamCreate(kCFAllocatorDefault, &eventCallback, &context, paths, kFSEventStreamEventIdSinceNow, 1.0, kFSEventStreamCreateFlagUseCFTypes);
	self.eventStream = eventStream;
}

#pragma mark - URL Processing

- (NSA*)cza_directoryURLs {

	NSA*URLs = self.URLs;
	NSMA *directoryURLs = [NSMA arrayWithCapacity:[URLs count]];
	for (NSURL *URL in self.URLs) {
		BOOL isDirectory 	= NO;
		BOOL exists 		= [AZFILEMANAGER fileExistsAtPath:URL.path isDirectory:&isDirectory];
		if (isDirectory && exists)				[directoryURLs addObject:URL];
		else if (!isDirectory && exists)		[directoryURLs addObject:[URL URLByDeletingLastPathComponent]];
	}
	return directoryURLs;
}

#pragma mark - FSEvents Callback Function

static void eventCallback(ConstFSEventStreamRef eventStreamRef, void *callbackInfo, size_t numberOfEvents, void *eventPaths,
						const FSEventStreamEventFlags eventFlags[], 	const FSEventStreamEventId eventIds[]) {

	CZAFileWatcher *fileWatcher 	= (__bridge CZAFileWatcher*)callbackInfo;
	NSA*paths 							= (__bridge NSA*)eventPaths;
	NSMA *URLs = [paths mapArray:^id(id obj) { // NSMA.new;// arrayWithCapacity:(NSUInteger)numberOfEvents];	for (NSString *path in ) { [URLs addObject:URL];
		return [NSURL fileURLWithPath:obj];
	}].mutableCopy;
	if (fileWatcher.changesHandler) fileWatcher.changesHandler(URLs);
}

@end
