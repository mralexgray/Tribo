//
//  AZWebPreviewViewController.h
//  Tribo
//
//  Created by Alex Gray on 9/25/13.
//  Copyright (c) 2013 Opt-6 Products, LLC. All rights reserved.
//

#import <ACEView/ACEView.h>
#import "TBViewController.h"

@interface AZWebPreviewViewController : TBViewController 
@end


@interface NSWindow (Fake)
@property (readonly) ACEView *aceView;
@end
@interface NSView (Fake)
@property (readonly) ACEView *aceView;
@end


@interface  ACEView (AZACEView) // <ACEViewDelegate>
//@property NSNumber *syntaxMode, *theme;
//@property (nonatomic)ACEView *aceView;
//- (void) setContent:(id)stuff mode:(ACEMode)m;
//- (ACEMode) mode;
//@property (nonatomic) id content;
- (void) setURL:(NSURL*)url;
@end
