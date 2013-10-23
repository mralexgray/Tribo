//
//  TBTemplatesViewController.m
//  Tribo
//
//  Created by Samuel Goodwin on 2/20/12.
//  Copyright (c) 2012 Opt-6 Products, LLC. All rights reserved.
//

#import "TBTemplatesViewController.h"
#import "TBSiteDocument.h"
#import "TBAsset.h"
#import "TBSite.h"

@implementation TBTemplatesViewController

- (NSString*)defaultNibName {
	return @"TBTemplatesView";
}

- (NSString*)title {
	return @"Templates";
}

- (void)awakeFromNib {
    [self.tableView setTarget:self];
    [self.tableView setDoubleAction:@selector(doubleClickRow:)];
}

- (NSA*)templates {
    NSA*nameSort = @[[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES]];
    return [self.document.site.templateAssets sortedArrayUsingDescriptors:nameSort];
}

- (void)doubleClickRow:(NSOutlineView*)outlineView {
    NSA*assets = [self.assets selectedObjects];
    NSA*assetURLS = [assets valueForKey:@"URL"];
    [assetURLS enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSA*singleFileArray = @[obj];
        BOOL fileOpened = [[NSWorkspace sharedWorkspace] openURLs:singleFileArray withAppBundleIdentifier:nil options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifiers:NULL];
        if(!fileOpened){
            [[NSWorkspace sharedWorkspace] openURLs:singleFileArray withAppBundleIdentifier:@"com.apple.TextEdit" options:NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifiers:NULL];
        }
    }];
}

@end
