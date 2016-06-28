//
//  KeyboardViewController.m
//  KeyboardExt
//
//  Created by Rajesh on 6/28/16.
//  Copyright © 2016 Org. All rights reserved.
//

#import "KeyboardViewController.h"

typedef enum {
    kCapsKey = 1,
    kPageKey,
    kSpaceKey,
    kReturnKey,
    kBackSpaceKey,
    kGlobeKey
}iKeyType;

@interface KeyboardViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *topPages;
@property (assign, nonatomic) BOOL isCapsOff;

@end

@implementation KeyboardViewController

- (void)loadView {
    [super loadView];
    [self setView:[[[UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0]];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)keyStroke:(UIButton *)sender {
    [UIView animateWithDuration:.2 animations:^{
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5, 1.5);
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    }];
    switch ([sender tag]) {
        case kCapsKey :
            [sender setSelected:!sender.selected];
            _isCapsOff = !_isCapsOff;
            [self configureForCaps:self.view];
            break;
        case kPageKey : {
            NSInteger selectedIndex = 0;
            for (UIView *view in _topPages) {
                if (!view.hidden) {
                    selectedIndex = [_topPages indexOfObject:view];
                }
            }
            [_topPages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj setHidden:YES];
            }];
            
            switch (selectedIndex) {
                case 0 :
                    [[_topPages objectAtIndex:1] setHidden:NO];
                    [sender setTitle:@"2/3" forState:UIControlStateNormal];
                    break;
                case 1 :
                    [[_topPages objectAtIndex:2] setHidden:NO];
                    [sender setTitle:@"3/3" forState:UIControlStateNormal];
                    break;
                case 2 :
                    [[_topPages objectAtIndex:0] setHidden:NO];
                    [sender setTitle:@"1/3" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
            break;
        case kSpaceKey :
            [[self textDocumentProxy] insertText:@" "];
            break;
        case kReturnKey :
            [[self textDocumentProxy] insertText:@"\n"];
            break;
        case kBackSpaceKey :
            [[self textDocumentProxy] deleteBackward];
            break;
        case kGlobeKey :
            [super advanceToNextInputMode];
            break;
        default:
            [[self textDocumentProxy] insertText:[sender titleForState:UIControlStateNormal]];
            break;
    }
}

- (void)configureForCaps:(UIView *)view {
    for (id aView in view.subviews) {
        if ([aView isKindOfClass:[UIButton class]]) {
            NSString *title = [aView titleForState:UIControlStateNormal];
            [aView setTitle:_isCapsOff ? [title lowercaseString] : [title uppercaseString]  forState:UIControlStateNormal];
        } else {
            [self configureForCaps:aView];
        }
    }
}

- (void)textWillChange:(id<UITextInput>)textInput {
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    /*
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
     */
}

@end
