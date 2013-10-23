
//  TBSite.m

#import "TBSite.h"
#import "TBPost.h"
#import "TBAsset.h"
#import "TBError.h"
#import "GRMustache.h"
#import "NSDateFormatter+TBAdditions.h"

@interface 								 TBSite	 ( )
@property (nonatomic) GRMustacheTemplate * postTemplate;
@property (nonatomic) 			  NSString * rawDefaultTemplate;
@end

@implementation TBSite

#pragma mark - Initialization

+ (instancetype)siteWithRoot:(NSURL*)root {		TBSite *site = TBSite.new;
	
	site.root 					=  root;
	site.destination 			= [root URLByAppendingPathComponent:@"Output" 	 isDirectory:YES];
	site.sourceDirectory 	= [root URLByAppendingPathComponent:@"Source"	 isDirectory:YES];
	site.postsDirectory 		= [root URLByAppendingPathComponent:@"Posts"		 isDirectory:YES];
	site.templatesDirectory = [root URLByAppendingPathComponent:@"Templates" isDirectory:YES];
	NSURL   *metadataURL		= [root URLByAppendingPathComponent:@"Info.plist" isDirectory:NO];
	NSData *metadataData 	= [NSData dataWithContentsOfURL:metadataURL];
	site.metadata 				= [NSPropertyListSerialization propertyListFromData:metadataData 
																		  mutabilityOption:NSPropertyListMutableContainersAndLeaves 
																						format:nil errorDescription:nil];
	if (!site.metadata) [@{} writeToURL:metadataURL atomically:NO];
	return site;
}

#pragma mark - Site Processing

- (BOOL)process:(NSError **)error {
	
	return 	![self loadRawDefaultTemplate:error] || ![self loadPostTemplate:error]  || ![self parsePosts:error] 				 || 
	![self writePosts:error]				 || ![self writeFeed:error]         || ![self verifySourceDirectory:error]  ||
	![self processSourceDirectory:error] ? NO : YES;
}

#pragma mark - Template Loading

- (BOOL)loadRawDefaultTemplate:(NSError **)error {
	NSURL *defaultTemplateURL = [self.templatesDirectory URLByAppendingPathComponent:@"Default.mustache" isDirectory:NO];
	self.rawDefaultTemplate = [NSString stringWithContentsOfURL:defaultTemplateURL encoding:NSUTF8StringEncoding error:error];
	if (!self.rawDefaultTemplate) return NO;
	return YES;
}

- (BOOL)loadPostTemplate:(NSError **)error {
	NSURL *postPartialURL = [self.templatesDirectory URLByAppendingPathComponent:@"Post.mustache" isDirectory:NO];
	if (![AZFILEMANAGER fileExistsAtPath:postPartialURL.path]) {
		if (error)
			*error = TBError.missingPostPartial(postPartialURL);
		return NO;
	}
	NSString *rawPostPartial = [NSString stringWithContentsOfURL:postPartialURL encoding:NSUTF8StringEncoding error:error];
	if (!rawPostPartial) return NO;
	NSString *rawPostTemplate = [self.rawDefaultTemplate stringByReplacingOccurrencesOfString:@"{{{content}}}" withString:rawPostPartial];
	self.postTemplate = [GRMustacheTemplate templateFromString:rawPostTemplate error:error];
	if (!self.postTemplate) return NO;
	return YES;
}

#pragma mark - Post Processing

- (BOOL)parsePosts:(NSError **)error {
	
	// Verify that the Posts directory exists and is a directory.
	BOOL postsDirectoryIsDirectory = NO;
	BOOL postsDirectoryExists = [AZFILEMANAGER fileExistsAtPath:self.postsDirectory.path isDirectory:&postsDirectoryIsDirectory];
	if (!postsDirectoryIsDirectory || !postsDirectoryExists){
		if (error) {
			*error = TBError.missingPostsDirectory(self.postsDirectory);
		}
		return NO;
	}
	// Parse the contents of the Posts directory into individual TBPost objects.
	NSA*postsDirectoryContents;
	
	if (!(postsDirectoryContents = [AZFILEMANAGER contentsOfDirectoryAtURL:self.postsDirectory includingPropertiesForKeys:nil  options:NSDirectoryEnumerationSkipsHiddenFiles error:error]))
		return NO;
		
	NSA* posts = [postsDirectoryContents cw_mapArray:^id(NSURL *postURL){
		
		TBPost *post = [TBPost postWithURL:postURL inSite:self error:error];
		if (post) [post parseMarkdownContent];
		return post ?: nil;
	}];
	if (posts) self.posts = posts.reversed.mutableCopy;
	
   // Prepare the asset object tree
	return (!(self.templateAssets = [TBAsset assetsFromDirectory:self.templatesDirectory error:error]))
		||	 (!(self.sourceAssets = [TBAsset assetsFromDirectory:self.sourceDirectory error:error])) 
		? NO : (!self.sourceAssets) ? NO : YES;

}

- (BOOL)writePosts:(NSError **)error {
	
	for (TBPost *post in self.posts) {
		
		post.stylesheets = @[@{@"stylesheetName": @"post"}];
		
		// Create the path to the folder where we are going to write the post file.
		// The directory structure we create is /YYYY/MM/DD/slug/
		NSDateFormatter *postPathFormatter = [NSDateFormatter tb_cachedDateFormatterFromString:@"yyyy/MM/dd"];
		NSString *directoryStructure = [postPathFormatter stringFromDate:post.date];
		NSURL *destinationDirectory = [[self.destination URLByAppendingPathComponent:directoryStructure isDirectory:YES] URLByAppendingPathComponent:post.slug isDirectory:YES];
		if (![AZFILEMANAGER createDirectoryAtURL:destinationDirectory withIntermediateDirectories:YES attributes:nil error:error])
			return NO;
		
		// Filter the markdownContent of the post.
		NSString *originalContent = post.markdownContent;
		NSString *filteredMarkdownContent = [self filteredContent:(originalContent ?: @"") fromFile:post.URL error:error];
		if (!filteredMarkdownContent)
			return NO;
		post.markdownContent = filteredMarkdownContent;
		[post parseMarkdownContent];
		post.markdownContent = originalContent;
		
		// Set up the template loader with this post's content, and then render it all into the post template.
		NSString *renderedContent = [self.postTemplate renderObject:post error:error];
		if (!renderedContent)
			return NO;
		
		// Write the post to the destination directory.
		NSURL *destinationURL = [destinationDirectory URLByAppendingPathComponent:@"index.html" isDirectory:NO];
		if (![renderedContent writeToURL:destinationURL atomically:YES encoding:NSUTF8StringEncoding error:error])
			return NO;
		
	}
	
	return YES;
	
}

#pragma mark - Feed Processing

- (BOOL)writeFeed:(NSError **)error {
	NSURL *templateURL = [self.templatesDirectory URLByAppendingPathComponent:@"Feed.mustache"];
	if (![AZFILEMANAGER fileExistsAtPath:templateURL.path]) return YES;
	GRMustacheTemplate *template = [GRMustacheTemplate templateFromContentsOfURL:templateURL error:error];
	if (!template) return NO;
	NSString *contents = [template renderObject:self error:error];
	if (!contents) return NO;
	NSURL *destination = [self.destination URLByAppendingPathComponent:@"feed.xml"];
	if (![contents writeToURL:destination atomically:YES encoding:NSUTF8StringEncoding error:error])
		return NO;
	return YES;
}

#pragma mark - Source Directory Processing

- (BOOL)verifySourceDirectory:(NSError **)error {
	BOOL sourceDirectoryIsDirectory = NO;
	BOOL sourceDirectoryExists = [AZFILEMANAGER fileExistsAtPath:self.sourceDirectory.path isDirectory:&sourceDirectoryIsDirectory];
	if (!sourceDirectoryIsDirectory || !sourceDirectoryExists){
		if (error) *error = TBError.missingSourceDirectory(self.sourceDirectory);
		return NO;
	}
	return YES;
}

- (BOOL)processSourceDirectory:(NSError **)error {
	NSDirectoryEnumerator *enumerator = [AZFILEMANAGER enumeratorAtURL:self.sourceDirectory includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:^BOOL(NSURL *url, NSError *enumeratorError) {
		return YES;
	}];
	for (NSURL *URL in enumerator) {
		
		BOOL URLIsDirectory = NO;
		[AZFILEMANAGER fileExistsAtPath:URL.path isDirectory:&URLIsDirectory];
		if (URLIsDirectory) continue;
		
		if (![self processSourceFile:URL error:error])
			return NO;
		
	}
	return YES;
}

- (BOOL)processSourceFile:(NSURL*)URL error:(NSError **)error {
	NSString *extension = [URL pathExtension];
	NSString *relativePath = [URL.path stringByReplacingOccurrencesOfString:self.sourceDirectory.path withString:@""];
	NSURL *destinationURL = [[self.destination URLByAppendingPathComponent:relativePath] URLByStandardizingPath];
	NSURL *destinationDirectory = [destinationURL URLByDeletingLastPathComponent];
	if (![AZFILEMANAGER createDirectoryAtURL:destinationDirectory withIntermediateDirectories:YES attributes:nil error:error])
		return NO;
	[AZFILEMANAGER removeItemAtURL:destinationURL error:nil];
	
	if ([extension isEqualToString:@"mustache"]) {
		TBPage *page = [TBPage pageWithURL:URL inSite:self error:nil];
		NSURL *pageDestination = [[destinationURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"html"];
		if (![self writePage:page toDestination:pageDestination error:error])
			return NO;
	}
	else
		[AZFILEMANAGER copyItemAtURL:URL toURL:destinationURL error:error];
	return YES;
}

- (BOOL)writePage:(TBPage*)page toDestination:(NSURL*)destination error:(NSError **)error {
	if (!page) return NO;
	NSString *rawPageTemplate = [self.rawDefaultTemplate stringByReplacingOccurrencesOfString:@"{{{content}}}" withString:page.content];
	GRMustacheTemplate *pageTemplate = [GRMustacheTemplate templateFromString:rawPageTemplate error:error];
	if (!pageTemplate) return NO;
	NSString *renderedPage = [pageTemplate renderObject:page error:error];
	if (!renderedPage) return NO;
	if (![renderedPage writeToURL:destination atomically:YES encoding:NSUTF8StringEncoding error:error])
		return NO;
	return YES;
}

#pragma mark - Filters

- (NSString*)filteredContent:(NSString*)content fromFile:(NSURL*)file error:(NSError **)error {
	
	NSA*filterPaths = self.metadata[TBSiteFilters];
	if (!filterPaths || ![filterPaths count])
		return content;
	
	NSURL *scriptsURL = [AZFILEMANAGER URLsForDirectory:NSApplicationScriptsDirectory inDomains:NSUserDomainMask][0];
	NSA*arguments = @[self.root.path, file.path];
	
	for (NSString *filterPath in filterPaths) {
		
		NSURL *filterURL = [scriptsURL URLByAppendingPathComponent:filterPath];
		NSUserUnixTask *filter = [NSUserUnixTask.alloc initWithURL:filterURL error:error];
		if (!filter) return content;
		NSPipe *standardError = NSPipe.pipe;
		filter.standardError = standardError.fileHandleForWriting;
		NSPipe *standardInput = NSPipe.pipe;
		filter.standardInput = standardInput.fileHandleForReading;
		NSPipe *standardOutput = NSPipe.pipe;
		filter.standardOutput = standardOutput.fileHandleForWriting;
		[standardInput.fileHandleForWriting writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
		[standardInput.fileHandleForWriting closeFile];

		__block NSError *blockError = nil;
		dispatch_group_t group = dispatch_group_create();
		dispatch_async(dispatch_get_current_queue(), ^{	dispatch_group_enter(group);
			[filter executeWithArguments:arguments completionHandler:^(NSError *filterError) { blockError = filterError; 
				dispatch_group_leave(group);
			}];
		});
		dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
		if (blockError) {	if (error) *error = blockError;	return nil; }
		NSData *standardErrorData = standardError.fileHandleForReading.readDataToEndOfFile;
		if (standardErrorData.length) {
			if (error) *error = TBError.filterStandardError(filterURL, $UTF8(standardErrorData.bytes)); return nil;
		}
		NSData *standardOutputData = [standardOutput.fileHandleForReading readDataToEndOfFile];
		content = standardOutputData.length ?  [NSString.alloc initWithBytes:standardOutputData.bytes length:standardOutputData.length encoding:NSUTF8StringEncoding] : content;
	}
	return content;
}

#pragma mark - Site Modification

- (NSURL*)addPostWithTitle:(NSString*)title slug:(NSString*)slug error:(NSError **)error {

	NSString *filename 	= $(@"%@-%@", [[NSDateFormatter tb_cachedDateFormatterFromString:@"yyyy-MM-dd"] stringFromDate:NSDate.date], slug);
	NSURL *destination 	= [[self.postsDirectory URLByAppendingPathComponent:filename] URLByAppendingPathExtension:@"md"];
	NSString *contents 	= $(@"# %@ #\n\n", title);
	return ![contents writeToURL:destination atomically:YES encoding:NSUTF8StringEncoding error:error] ||
			 ![self parsePosts:error] ? nil : destination;
}
- (void)setMetadata:(NSD*)metadata {	_metadata = metadata;
	[self.metadata writeToURL:[self.root URLByAppendingPathComponent:@"Info.plist" isDirectory:NO] atomically:NO];
	if (self.delegate && [self.delegate respondsToSelector:@selector(metadataDidChangeForSite:)])
		[self.delegate metadataDidChangeForSite:self];
}

@end
