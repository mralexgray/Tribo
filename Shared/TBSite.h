//
//  TBSite.h
//  Tribo
//
//  Created by Carter Allen on 9/25/11.
//  Copyright (c) 2012 The Tribo Authors.
//  See the included License.md file.
//

#import "TBConstants.h"

@protocol TBSiteDelegate;

/*!
	@class TBSite
	@discussion The TBSite class is the central data structure of Tribo. A site 
	object is created based on a directory of files, typically with a ".tribo" 
	extension. The object includes posts (TBPost objects) which represent 
	written content, and assets (TBAsset objects) which represent both templates 
	and unprocessed files like stylesheets and images. The site object is then 
	responsible for compiling all of these resources, along with a small set of 
	user-specific metadata, into a finished set of files, suitable for uploading 
	to a standard web server.
 */

@interface TBSite : NSObject

/*!
	Create a new site object from the files found at the supplied directory.
	@param root
		The filesystem URL used to initialize the site object. Typically points
		to a ".tribo" file.
	@return 
		A TBSite instance, initialized to represent the site folder at the given 
		root directory.
 */
+ (instancetype)siteWithRoot:(NSURL *)root;

/*!
	Process the entire site, writing the output into the destination directory.
	@param error
		If the return value is NO, then this argument will contain an NSError
		object describing what went wrong.
	@return
		YES on successful processing, NO if an error was encountered.
 */
- (BOOL)process:(NSError **)error;

/*!
	Parse all post files into TBPost objects.
	@param error
		If the return value is NO, then this argument will contain an NSError 
		object describing what went wrong.
	@return 
		YES on successful parsing, NO if an error was encountered.
 */
- (BOOL)parsePosts:(NSError **)error;

/*!
	Add an empty post to the receiving site object.
	@param title
		The title of the post. Must not be nil.
	@param slug
		The slug of the post, i.e. the post title that will be used in URLs.
		Must be URL-encoded and not nil.
	@param error
		If the return value is nil, then this argument will contain an NSError 
		object describing what went wrong.
	@return
		A filesystem URL pointing to the newly-created post file.
	@discussion
		The new post file has no content, but is pre-filled with a Markdown 
		title on the first line. The date of the post is automatically set to 
		today's date.
 */
- (NSURL *)addPostWithTitle:(NSString *)title
					   slug:(NSString *)slug
					  error:(NSError **)error;

/*!
	@property root
		A filesystem URL pointing to the root directory of the site's source 
		files. Typically a .tribo file.
 */
@property (nonatomic, strong) NSURL *root;

/*!
	@property destination
		A filesystem URL pointing to the directory where the generated site 
		files will be written to. By default, this is initialized by appending 
		"Output" to the root directory.
 */
@property (nonatomic, strong) NSURL *destination;

/*!
	@property sourceDirectory
		A filesystem URL pointing to the source directory for the site. Any 
		files and folders in the source directory are copied into the 
		destination folder as-is, with the exception of ".mustache" files. 
		Mustache files have their contents put in place of the {{{contents}}}
		tag of the Default.mustache template in the templates directory, and 
		they are then run through the main templating engine.
 */
@property (nonatomic, strong) NSURL *sourceDirectory;

/*!
	@property postsDirectory
		A filesystem URL pointing to the posts directory for the site. Properly-
		named Markdown files in this directory are processed by the Sundown 
		Markdown parser into HTML. The proper naming convention for posts is  
		year-month-day-slug.md, for example, "2011-08-14-test-post.md" would be 
		a post created on the 14th of August 2011, with the slug "test-post".
		The HTML content is then placed in the {{content}} tag of the 
		Post.mustache template before being run through the main templating 
		engine.
 */
@property (nonatomic, strong) NSURL *postsDirectory;

/*!
	@property templatesDirectory
		A filesystem URL pointing to the templates directory for the site. The 
		templates directory contains ".mustache" files that are used to generate 
		the HTML for the site. Currently, only three templates are supported: 
		Default, Feed, and Post. The feed template is used to generate an RSS 
		feed for the site, the post template is used to give standardized 
		structure to every post page, and the default template is used 
		everywhere to provide universal elements to the site's pages, e.g. a 
		logo, header, navigation, and footer.
 */
@property (nonatomic, strong) NSURL *templatesDirectory;

/*!
	@property posts
		An array of parsed TBPost objects.
 */
@property (nonatomic, strong) NSMutableArray *posts;

@property (nonatomic, strong) NSArray *templateAssets;
@property (nonatomic, strong) NSArray *sourceAssets;
@property (nonatomic, strong) NSDictionary *metadata;
@property (nonatomic, weak) id <TBSiteDelegate> delegate;

@property (nonatomic, assign, getter=isPublished) BOOL published;

@end

@protocol TBSiteDelegate <NSObject>
@optional
- (void)metadataDidChangeForSite:(TBSite *)site;
@end
