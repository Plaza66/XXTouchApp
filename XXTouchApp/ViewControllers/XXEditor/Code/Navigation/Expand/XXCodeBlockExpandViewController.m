//
//  XXCodeBlockExpandViewController.m
//  XXTouchApp
//
//  Created by Zheng on 21/10/2016.
//  Copyright © 2016 Zheng. All rights reserved.
//

#import "XXCodeBlockExpandViewController.h"
#import "XXBaseTextView.h"
#import <Masonry/Masonry.h>

@interface XXCodeBlockExpandViewController () <UITextViewDelegate>
@property (strong, nonatomic) XXBaseTextView *textView;

@end

@implementation XXCodeBlockExpandViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.view addSubview:self.textView];
}

- (XXBaseTextView *)textView {
    if (!_textView) {
        UIFont *font = [UIFont fontWithName:@"CourierNewPSMT" size:14.0f];
        XXBaseTextView *textView = [[XXBaseTextView alloc] initWithFrame:self.view.bounds];
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.font = font;
        textView.alwaysBounceVertical = YES;
        textView.delegate = self;
        textView.tintColor = STYLE_TINT_COLOR;
        textView.selectedRange = NSMakeRange(0, 0);
        textView.contentOffset = CGPointZero;
        textView.editable = NO;
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        textView.highlightLuaSymbols = YES;
        _textView = textView;
    }
    return _textView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setInjectedCode:(NSString *)injectedCode {
    _injectedCode = injectedCode;
    self.textView.text = injectedCode;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
