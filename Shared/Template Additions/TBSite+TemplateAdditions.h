/*	

TBSite+TemplateAdditions.h	*  Tribo		Created by Carter Allen on 5/11/13.  Copyright (c) 2012 The Tribo Authors.

Template additions contain properties designed to be accessed by templates.
		No configuration "hooks" are provided, so all properties should be generated lazily, 
		caching anything expensive like date formatters. 																						*/

#import "TBSite.h"

@class                  TBPost ;
@interface 					TBSite   (TemplateAdditions)

@property (RO) TBPost * latestPost;
@property (RO) 	NSA * recentPosts;
@property (RO) 	NSS * XMLDate,
										 * baseURL,
										 * author,
										 * name;

@end
