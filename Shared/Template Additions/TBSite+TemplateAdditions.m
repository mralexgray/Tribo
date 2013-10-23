

#import "TBSite+TemplateAdditions.h"
#import "NSDateFormatter+TBAdditions.h"

@implementation TBSite (TemplateAdditions)

- (TBPost*) latestPost 	{	return self.posts[0];	}

- (NSA*) recentPosts 	{	if (!self.posts.count) return @[];

	NSUInteger recentPostCount 			  = [self.metadata[TBSiteNumberOfRecentPostsMetadataKey] unsignedIntegerValue];
	if (!recentPostCount) recentPostCount = 5;
	if (self.posts.count < recentPostCount) recentPostCount = self.posts.count;
	return [self.posts subarrayWithRange:NSMakeRange(0, recentPostCount)];
}

- (NSS*) XMLDate 	{

	NSMS *mutableDateString = [[NSDateFormatter tb_cachedDateFormatterFromString:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"]
																													stringFromDate:NSDate.date].mutableCopy;
	[mutableDateString insertString:@":" atIndex:mutableDateString.length - 2];
	return mutableDateString;
}

- (NSS*) name 		{	return self.metadata[   TBSiteNameMetadataKey];	}

- (NSS*) author 	{	return self.metadata[ TBSiteAuthorMetadataKey];	}

- (NSS*) baseURL 	{	return self.metadata[TBSiteBaseURLMetadataKey];	}
@end
