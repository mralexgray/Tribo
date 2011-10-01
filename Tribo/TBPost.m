//
//  TBPost.m
//  Tribo
//
//  Created by Carter Allen on 9/25/11.
//  Copyright (c) 2011 Opt-6 Products, LLC. All rights reserved.
//

#import "TBPost.h"
#import "markdown.h"
#import "html.h"

@interface TBPost ()
- (void)parse;
@property (readonly) NSString *dateString;
@property (readonly) NSString *summary;
@property (readonly) NSString *relativeURL;
@end

@implementation TBPost
@synthesize URL=_URL;
@synthesize title=_title;
@synthesize author=_author;
@synthesize date=_date;
@synthesize slug=_slug;
+ (TBPost *)postWithURL:(NSURL *)URL {
	return (TBPost *)[super pageWithURL:URL inSite:nil];
}
- (NSString *)dateString {
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"dMMMyyyy" options:0 locale:[NSLocale currentLocale]];
	return [formatter stringFromDate:self.date];
}
- (NSString *)summary {
	NSUInteger paraStart = 0, paraEnd = 0, contentsEnd = 0;
	[self.content getParagraphStart:&paraStart end:&paraEnd contentsEnd:&contentsEnd forRange:NSMakeRange(0, 0)];
	NSRange paragraphRange = NSMakeRange(paraStart, contentsEnd - paraStart);
	return [self.content substringWithRange:paragraphRange];
}
- (NSString *)relativeURL {
	NSDateFormatter *formatter = [NSDateFormatter new];
	formatter.dateFormat = @"/yyyy/MM/dd";
	NSString *directoryStructure = [formatter stringFromDate:self.date];
	return [directoryStructure stringByAppendingPathComponent:self.slug];
}
- (void)parse {
	NSMutableString *markdownContent = [NSMutableString stringWithContentsOfURL:self.URL encoding:NSUTF8StringEncoding error:nil];
	
	// Titles are optional.
	// A single # header on the first line of the document is regarded as the title.
	NSRegularExpression *headerRegex = [NSRegularExpression regularExpressionWithPattern:@"#[ \\t](.*)[ \\t]#" options:0 error:nil];
	NSRange firstLineRange = NSMakeRange(0, [markdownContent rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location);
	NSString *firstLine = [markdownContent substringWithRange:firstLineRange];
	NSTextCheckingResult *titleResult = [headerRegex firstMatchInString:firstLine options:0 range:NSMakeRange(0, firstLine.length)];
	if (titleResult) {
		self.title = [firstLine substringWithRange:[titleResult rangeAtIndex:1]];
		[markdownContent deleteCharactersInRange:firstLineRange];
	}
	
	// Dates are generated by a pattern in the post file name.
	NSRegularExpression *fileNameRegex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d+-\\d+-\\d+)-(.*)" options:0 error:nil];
	NSString *fileName = [self.URL.lastPathComponent stringByDeletingPathExtension];
	NSTextCheckingResult *fileNameResult = [fileNameRegex firstMatchInString:fileName options:0 range:NSMakeRange(0, fileName.length)];
	if (fileNameResult) {
		self.date = [NSDate dateWithNaturalLanguageString:[fileName substringWithRange:[fileNameResult rangeAtIndex:1]]];
		self.slug = [fileName substringWithRange:[fileNameResult rangeAtIndex:2]];
	}
	
	// Create and fill a buffer for with the raw markdown data.
	struct sd_callbacks callbacks;
	struct html_renderopt options;
	const char *rawMarkdown = [markdownContent cStringUsingEncoding:NSUTF8StringEncoding];
	struct buf *inputBuffer = bufnew(strlen(rawMarkdown));
	bufputs(inputBuffer, rawMarkdown);
	
	// Parse the markdown into a new buffer using Sundown.
	struct buf *outputBuffer = bufnew(64);
	sdhtml_renderer(&callbacks, &options, 0);
	struct sd_markdown *markdown = sd_markdown_new(0, 16, &callbacks, &options);
	sd_markdown_render(outputBuffer, inputBuffer->data, inputBuffer->size, markdown);
	sd_markdown_free(markdown);
	
	self.content = [NSString stringWithCString:bufcstr(outputBuffer) encoding:NSUTF8StringEncoding];
	
	bufrelease(inputBuffer);
	bufrelease(outputBuffer);

}
@end