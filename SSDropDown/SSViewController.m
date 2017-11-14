//
//  ViewController.m
//  SSDropDown
//
//  Created by Shebin Koshy on 11/14/17.
//  Copyright © 2017 Shebin Koshy. All rights reserved.
//

#import "SSViewController.h"
#import "SSDropDown.h"

@interface SSViewController ()<SSDropDownDelegate>

@end

@implementation SSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 150, 200, 30)];
    textField.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:textField];
    
    
    
    SSDropDown *dropDown = [[SSDropDown alloc]init];
    dropDown.tag = 901;
    dropDown.delegate = self;
    dropDown.dropDownPosition = kSSDropDownPositionRight;
    dropDown.needToShowArrow = YES;
    dropDown.cornerRadius = 5.0;
    dropDown.dropDownHeight = 120;
    dropDown.dropDownWidth = 100;
    dropDown.arrayItemsToList = @[@"1",@"2",@"3"];
    [dropDown.tableViewDropDownList setShowsVerticalScrollIndicator:NO];
    [dropDown showDropDownForView:textField withSelectedObject:@"1"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSDropDownDelegate

-(void)dropDown:(nonnull SSDropDown*)dropDownViewObj selectedAnObject:(nullable id)selectedDropDownItem dropDownForTheView:(nonnull UIView*)viewForDropDown;
{
    NSLog(@"tag = %d selected obj %@",(int)dropDownViewObj.tag,selectedDropDownItem);
}

@end
