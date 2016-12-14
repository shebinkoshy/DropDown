//
//  DropDown.h
//  DropDownTest
//
//  Created by Shebin Koshy on 4/13/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    kDropDownPositionBottom,
    kDropDownPositionTop,
    kDropDownPositionLeft,
    kDropDownPositionRight
} DropDownPositions;

@class DropDown;
@protocol DropDownDelegate <NSObject>

@required

/**
 selected an object from drop down view
 */
-(void)dropDown:(nonnull DropDown*)dropDownViewObj selectedAnObject:(nullable id)selectedDropDownItem dropDownForTheView:(nonnull UIView*)viewForDropDown;

@optional

/**
 register Custom UITableViewCell for Drop down table view
 NOTE: should implement when 'needCustomCell = YES'
 */
-(void)dropDown:(nonnull DropDown*)dropDownViewObj registerCustomCellForTheDropDownTableView:(nonnull UITableView*)dropDownTableView;

/**
 cellForRowAtIndexPath like UITableViewDelegate
 NOTE: should implement when 'needCustomCell = YES'
 @param selectedObject you should handle the selected item in your custom UITableViewCell
 */
-(nonnull UITableViewCell *)dropDown:(nonnull DropDown*)dropDownViewObj dropDownTableView:(nonnull UITableView *)dropDownTableView cellForRowAtIndexPath:(nonnull NSIndexPath *)dropDownIndexPath andSelectedItem:(nullable id)selectedObject;

/**
 NOTE: should implement when 'needCustomCell = YES'
 heightForRowAtIndexPath for your custom UITableViewCell
 */
- (CGFloat)dropDownTableView:(nonnull UITableView *)dropDownTableView heightForRowAtIndexPath:(nonnull NSIndexPath *)dropDownIndexPath;


/**
 While changing orientation, if you need to do something to the drop down view
 */
-(void)dropDown:(nonnull DropDown *)dropDownViewObj orientationChanged:(BOOL)isPortrait;

@end

@interface DropDown : UIView


/**
 If you need to curve edges pass corner Radius
 */
@property (nonatomic) CGFloat cornerRadius;


/**
 If you need to adjust the Height of the drop down view
 */
@property (nonatomic) NSInteger dropDownHeight;


/**
 to adjust the width of the drop down view
 */
@property (nonatomic) NSInteger dropDownWidth;


/**
 to specify the position of the drop down view
 */
@property (nonatomic) DropDownPositions dropDownPosition;



/**
 if you need to add direction Arrow value should be YES.
 NOTE: Drop Down view's width or height will be reduced by arrow size.
 */
@property (nonatomic) BOOL needToShowArrow;




/** 
 NOTE: You should implement the dropDown delegates 'registerCustomCellForTheDropDownTableView' & 'cellForRowAtIndexPath'
 */
@property (nonatomic) BOOL needCustomCell;



@property (nonatomic) BOOL needAnimation;




/**
 array of items to list in dropDown view
 NOTE: if you are not using customCell, it will be array of NSString
 */
@property (nonatomic,strong,nonnull)  NSArray *arrayItemsToList;



/**
 diable super class property
 */
//@property (nonatomic,strong,nullable) UIColor *backgroundColor  __attribute__((nouse));

/**
 background color of dropDownView
 */
@property (nonatomic,strong,nullable) UIColor *dropDownBackgroundColor;


/**
 Drop Down items Listing table view object
 */
@property (nonatomic,strong,nonnull) UITableView *tableViewDropDownList;




/**
 If you are using Navigation controller in drop down showing page, pass the navigation controller object
 */
@property (nonatomic,strong,nullable) UINavigationController *navigationController;



/**
 delegate
 */
@property (nonatomic,weak,null_unspecified) id <DropDownDelegate> delegate;


@property (nonatomic) CGFloat WAFIERSPECIALCASEBottomCornerRadius;



/**
 invoke this method, If you need to show drop down for a UITextField,UIButton or any UIView that placed in UITableViewCell or UICollectionViewCell
 */
-(void)showDropDownForView:(nonnull UIView*)viewForDropDown insideTheCell:(nonnull id)cell withSelectedObject:(nullable id)selectedObject;

/**
 invoke this method, if you need to show drop down for a view(superView should be a UIView)
 */
-(void)showDropDownForView:(nonnull UIView*)viewForDropDown withSelectedObject:(nullable id)selectedObject;

@end
