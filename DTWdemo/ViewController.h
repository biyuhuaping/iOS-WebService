//
//  ViewController.h
//  DTWdemo
//
//  Created by JYDMAC on 14-6-20.
//  Copyright (c) 2014年 zhoubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSString *currentElement;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@end
