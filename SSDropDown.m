//
//  SSDropDown.m
//
//
//  Created by Shebin Koshy on 4/13/16.
//  Copyright © 2016 Shebin Koshy. All rights reserved.
//

#import "SSDropDown.h"


#define kDefaultSSDropDownViewColor [UIColor colorWithWhite:0.4 alpha:1.0]
#define kDefaultSSDropDownHeight 80.0f
#define kDefaultFontSize 13.0f
#define kDefaultSSDropDownTableViewCellHeight 40.0f
#define kDefaultGapBetweenSSDropDownAndViewForDropDown 0.5f
#define kDefaultArrowWidth 8.0f
#define kDefaultAnimationDuration 0.3


#define kCellIdentifier @"CellIdentifier"
//#define kCoveringViewColor [UIColor colorWithWhite:0.7 alpha:0.5]
#define kCoveringViewColor [UIColor clearColor]



@interface SSDropDown ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    CAShapeLayer *shapeLayer;
    CAShapeLayer *shapeArrow;
    
    id selectedItem;
    
    UIView *viewBackground;
    UIView *viewToShowDropDown;
    UIView *superViewToShowDropDown;
}
@end


@implementation SSDropDown

-(instancetype)init
{
    if(self == [super init])
    {
        self.tableViewDropDownList = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableViewDropDownList.delegate = self;
        self.tableViewDropDownList.dataSource = self;
        self.tableViewDropDownList.tableFooterView = [[UIView alloc] init];
        return self;
    }
    return nil;
}

-(void)showDropDownForView:(UIView*)viewForDropDown insideTheCell:(nonnull id)cell withSelectedObject:(nullable id)selectedObject
{
    selectedItem = selectedObject;
    UIView *superView;
    if([cell isKindOfClass:[UITableViewCell class]])
    {
        UITableViewCell *tableCell = cell;
        superView = tableCell.contentView;
    }
    else if ([cell isKindOfClass:[UICollectionViewCell class]])
    {
        UICollectionViewCell *collectionCell = cell;
        superView = collectionCell.contentView;
    }
    [self showDropDownForView:viewForDropDown insideTheView:superView animation:_needAnimation];
}

-(void)showDropDownForView:(UIView *)viewForDropDown withSelectedObject:(id)selectedObject
{
    selectedItem = selectedObject;
    [self showDropDownForView:viewForDropDown insideTheView:viewForDropDown.superview animation:_needAnimation];
}

-(void)showDropDownForView:(UIView *)viewForDropDown insideTheView:(UIView *)superView animation:(BOOL)animate
{
    viewToShowDropDown = viewForDropDown;
    superViewToShowDropDown = superView;
    if (_needCustomCell)
    {
        [self.delegate dropDown:self registerCustomCellForTheDropDownTableView:self.tableViewDropDownList];
    }
    else
    {
        [self.tableViewDropDownList registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    }
    if (!self.dropDownHeight || self.dropDownHeight == 0.0f)
    {
        /**
         if its null or zero,
         setting default value.
         */
        self.dropDownHeight = kDefaultSSDropDownHeight;
    }
    if (!self.dropDownWidth || self.dropDownWidth == 0.0f)
    {
        self.dropDownWidth = viewForDropDown.frame.size.width;
    }
    self.backgroundColor = _dropDownBackgroundColor;
    if (!self.backgroundColor || [self.backgroundColor isEqual:[UIColor clearColor]])
    {
        self.backgroundColor = kDefaultSSDropDownViewColor;
    }
    
    viewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [viewBackground setBackgroundColor:kCoveringViewColor];
    if (_navigationController)
    {
        [_navigationController.view addSubview:viewBackground];
    }
    else if([UIApplication sharedApplication].keyWindow.rootViewController)
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:viewBackground];
    }
    else
    {
        id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.window.rootViewController.view addSubview:viewBackground];
    }
    
    CGPoint point = [superView convertPoint:viewForDropDown.frame.origin toView:viewBackground];
    if (self.dropDownPosition == kSSDropDownPositionBottom)
    {
        [self setFrame:CGRectMake(point.x - ((self.dropDownWidth - viewForDropDown.frame.size.width)/2), point.y + viewForDropDown.frame.size.height, self.dropDownWidth, self.dropDownHeight)];
    }
    else if (self.dropDownPosition == kSSDropDownPositionTop)
    {
        [self setFrame:CGRectMake(point.x - ((self.dropDownWidth - viewForDropDown.frame.size.width)/2), point.y - self.dropDownHeight, self.dropDownWidth, self.dropDownHeight)];
    }
    else if (self.dropDownPosition == kSSDropDownPositionLeft)
    {
        [self setFrame:CGRectMake(point.x - self.dropDownWidth, (point.y+(viewForDropDown.frame.size.height)/2) - (self.dropDownHeight/2), self.dropDownWidth, self.dropDownHeight)];
    }
    else if (self.dropDownPosition == kSSDropDownPositionRight)
    {
        [self setFrame:CGRectMake(point.x + viewForDropDown.frame.size.width, (point.y+(viewForDropDown.frame.size.height)/2) - (self.dropDownHeight/2), self.dropDownWidth, self.dropDownHeight)];
    }
    [self.tableViewDropDownList setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self creatShape];
    [self.tableViewDropDownList setBackgroundColor:self.backgroundColor];
    [self.tableViewDropDownList reloadData];
    [self addSubview:self.tableViewDropDownList];
    [viewBackground addSubview:self];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.delegate = self;
    [viewBackground addGestureRecognizer:tapGesture];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    if (animate)
    {
        [self showingAnimation];
    }
}


-(void)deviceRotated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self needToDoOnRemove];
        if ([self.delegate respondsToSelector:@selector(dropDown:orientationChanged:)])
        {
            [self.delegate dropDown:self orientationChanged:UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)];
        }
        [self showDropDownForView:viewToShowDropDown insideTheView:superViewToShowDropDown animation:NO];
        
    });
}


-(void)showingAnimation
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIColor *colorOld = viewBackground.backgroundColor;
    viewBackground.backgroundColor = [UIColor clearColor];
    //    [self setAlpha:0.0f];
    //    [viewBackground setAlpha:0.0f];
    CGRect frameOld = self.frame;
    self.clipsToBounds = YES;
    if (self.dropDownPosition == kSSDropDownPositionBottom)
    {
        self.frame = CGRectMake(frameOld.origin.x, frameOld.origin.y, frameOld.size.width, 0);
    }
    else if (self.dropDownPosition == kSSDropDownPositionTop)
    {
        self.frame = CGRectMake(frameOld.origin.x, frameOld.origin.y + frameOld.size.height, frameOld.size.width, 0);
    }
    else if (self.dropDownPosition == kSSDropDownPositionLeft)
    {
        self.frame = CGRectMake(frameOld.origin.x + frameOld.size.width, frameOld.origin.y,0, frameOld.size.height);
    }
    else if (self.dropDownPosition == kSSDropDownPositionRight)
    {
        self.frame = CGRectMake(frameOld.origin.x, frameOld.origin.y, 0, frameOld.size.height);
    }
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        //        [self setAlpha:1.0f];
        //        [viewBackground setAlpha:1.0f];
        self.frame = frameOld;
        viewBackground.backgroundColor = colorOld;
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self setClipsToBounds:NO];
    }];
}

-(void)tapGestureAction:(UITapGestureRecognizer*)tapGesture
{
    [tapGesture setCancelsTouchesInView:NO];
    CGPoint point = [tapGesture locationInView:tapGesture.view];
    if (CGRectContainsPoint(self.frame, point) == NO)
    {
        [self removeDropDown];
    }
}

-(void)creatShape
{
    /**
     Removing the previous changes
     */
    if (shapeLayer)
    {
        [shapeLayer removeFromSuperlayer];
    }
    if (shapeArrow)
    {
        [shapeArrow removeFromSuperlayer];
    }
    self.layer.cornerRadius = 0.0;
    self.tableViewDropDownList.layer.cornerRadius = 0.0;
    
    
    if (_needToShowArrow)
    {
        CGFloat static arrowWidth = kDefaultArrowWidth;
        
        /**
         if need to show arrow, then dropDownView frame will change.
         so, calculating tableView frame
         */
        CGRect frameTable = CGRectZero;
        if (self.dropDownPosition == kSSDropDownPositionLeft)
        {
            frameTable = CGRectMake(0, 0, self.dropDownWidth - arrowWidth, self.dropDownHeight);
        }
        else if (self.dropDownPosition == kSSDropDownPositionBottom)
        {
            frameTable = CGRectMake(0, arrowWidth, self.dropDownWidth, self.dropDownHeight - arrowWidth);
        }
        else if (self.dropDownPosition == kSSDropDownPositionTop)
        {
            frameTable = CGRectMake(0, 0, self.dropDownWidth, self.dropDownHeight - arrowWidth);
        }
        else if (self.dropDownPosition == kSSDropDownPositionRight)
        {
            frameTable = CGRectMake(arrowWidth, 0, self.dropDownWidth - arrowWidth, self.dropDownHeight);
        }
        
        [self.tableViewDropDownList setFrame:frameTable];
        
        if (_cornerRadius)
        {
            /**
             need to show Arrow and CornerRadius
             */
            shapeLayer = [CAShapeLayer layer];
            shapeArrow = [CAShapeLayer layer];
            if (self.dropDownPosition == kSSDropDownPositionLeft)
            {
                UIBezierPath *pathRoundRect = [UIBezierPath bezierPathWithRoundedRect:frameTable cornerRadius:_cornerRadius];
                shapeLayer.path = pathRoundRect.CGPath;
                
                UIBezierPath *pathArrow = [UIBezierPath bezierPath];
                [pathArrow moveToPoint:CGPointMake(self.dropDownWidth - arrowWidth, self.dropDownHeight/2 - arrowWidth)];
                [pathArrow addLineToPoint:CGPointMake(self.dropDownWidth, self.dropDownHeight/2)];
                [pathArrow addLineToPoint:CGPointMake(self.dropDownWidth - arrowWidth, self.dropDownHeight/2 + arrowWidth)];
                [pathArrow closePath];
                shapeArrow.path = pathArrow.CGPath;
            }
            else if (self.dropDownPosition == kSSDropDownPositionBottom)
            {
                UIBezierPath *pathRoundRect = [UIBezierPath bezierPathWithRoundedRect:frameTable cornerRadius:_cornerRadius];
                shapeLayer.path = pathRoundRect.CGPath;
                
                UIBezierPath *pathArrow = [UIBezierPath bezierPath];
                [pathArrow moveToPoint:CGPointMake(self.dropDownWidth/2 - arrowWidth, arrowWidth)];
                [pathArrow addLineToPoint:CGPointMake(self.dropDownWidth/2, 0)];
                [pathArrow addLineToPoint:CGPointMake(self.dropDownWidth/2 + arrowWidth, arrowWidth)];
                [pathArrow closePath];
                shapeArrow.path = pathArrow.CGPath;
            }
            else if (self.dropDownPosition == kSSDropDownPositionTop)
            {
                UIBezierPath *pathRoundRect = [UIBezierPath bezierPathWithRoundedRect:frameTable cornerRadius:_cornerRadius];
                shapeLayer.path = pathRoundRect.CGPath;
                
                UIBezierPath *pathArrow = [UIBezierPath bezierPath];
                [pathArrow moveToPoint:CGPointMake((self.dropDownWidth/2) - arrowWidth, self.dropDownHeight - arrowWidth)];
                [pathArrow addLineToPoint:CGPointMake((self.dropDownWidth/2), self.dropDownHeight)];
                [pathArrow addLineToPoint:CGPointMake((self.dropDownWidth/2) + arrowWidth, self.dropDownHeight - arrowWidth)];
                [pathArrow closePath];
                shapeArrow.path = pathArrow.CGPath;
            }
            else if (self.dropDownPosition == kSSDropDownPositionRight)
            {
                UIBezierPath *pathRoundRect = [UIBezierPath bezierPathWithRoundedRect:frameTable cornerRadius:_cornerRadius];
                shapeLayer.path = pathRoundRect.CGPath;
                
                UIBezierPath *pathArrow = [UIBezierPath bezierPath];
                [pathArrow moveToPoint:CGPointMake(arrowWidth, (self.dropDownHeight/2) - arrowWidth)];
                [pathArrow addLineToPoint:CGPointMake(0, self.dropDownHeight/2)];
                [pathArrow addLineToPoint:CGPointMake(arrowWidth, (self.dropDownHeight/2) + arrowWidth)];
                [pathArrow closePath];
                shapeArrow.path = pathArrow.CGPath;
            }
            shapeLayer.fillColor = self.backgroundColor.CGColor;
            [self.layer addSublayer:shapeLayer];
            shapeArrow.fillColor = self.backgroundColor.CGColor;
            [self.layer addSublayer:shapeArrow];
            [self.tableViewDropDownList.layer setCornerRadius:_cornerRadius];
            [self setClipsToBounds:YES];
            [self.tableViewDropDownList setClipsToBounds:YES];
        }
        else
        {
            /**
             need to show Arrow WITHOUT CornerRadius
             */
            UIBezierPath *path = [UIBezierPath bezierPath];
            if (self.dropDownPosition == kSSDropDownPositionLeft)
            {
                [path moveToPoint:CGPointZero];
                [path addLineToPoint:CGPointMake(self.dropDownWidth - arrowWidth, 0)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth - arrowWidth, (self.dropDownHeight/2)-arrowWidth)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth, self.dropDownHeight/2)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth - arrowWidth, (self.dropDownHeight/2)+arrowWidth)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth - arrowWidth, self.dropDownHeight)];
                [path addLineToPoint:CGPointMake(0, self.dropDownHeight)];
            }
            else if (self.dropDownPosition == kSSDropDownPositionBottom)
            {
                [path moveToPoint:CGPointMake(0, arrowWidth)];
                [path addLineToPoint:CGPointMake((self.dropDownWidth/2) - arrowWidth, arrowWidth)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth/2, 0)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth/2 + arrowWidth, arrowWidth)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth, arrowWidth)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth, self.dropDownHeight)];
                [path addLineToPoint:CGPointMake(0, self.dropDownHeight)];
            }
            else if (self.dropDownPosition == kSSDropDownPositionTop)
            {
                [path moveToPoint:CGPointZero];
                [path addLineToPoint:CGPointMake(self.dropDownWidth, 0.0)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth, self.dropDownHeight - arrowWidth)];
                [path addLineToPoint:CGPointMake((self.dropDownWidth/2) + arrowWidth, self.dropDownHeight - arrowWidth)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth/2, self.dropDownHeight)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth/2 - arrowWidth, self.dropDownHeight - arrowWidth)];
                [path addLineToPoint:CGPointMake(0, self.dropDownHeight - arrowWidth)];
            }
            else if (self.dropDownPosition == kSSDropDownPositionRight)
            {
                [path moveToPoint:CGPointMake(arrowWidth, 0)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth/* - arrowWidth*/, 0)];
                [path addLineToPoint:CGPointMake(self.dropDownWidth/* - arrowWidth*/, self.dropDownHeight)];
                [path addLineToPoint:CGPointMake(arrowWidth, self.dropDownHeight)];
                [path addLineToPoint:CGPointMake(arrowWidth, (self.dropDownHeight/2) + arrowWidth)];
                [path addLineToPoint:CGPointMake(0, self.dropDownHeight/2)];
                [path addLineToPoint:CGPointMake(arrowWidth, (self.dropDownHeight/2) - arrowWidth)];
            }
            [path closePath];
            shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = path.CGPath;
            shapeLayer.fillColor = self.backgroundColor.CGColor;
            [self.layer addSublayer:shapeLayer];
        }
        self.backgroundColor = [UIColor clearColor];
    }
    else
    {
        /**
         No Arrow
         */
        if(_cornerRadius)
        {
            [self.layer setCornerRadius:_cornerRadius];
            [self setClipsToBounds:YES];
            [self.tableViewDropDownList.layer setCornerRadius:_cornerRadius];
            [self.tableViewDropDownList setClipsToBounds:YES];
        }
        
        if (self.dropDownPosition == kSSDropDownPositionLeft)
        {
            [self setFrame:CGRectMake(self.frame.origin.x - kDefaultGapBetweenSSDropDownAndViewForDropDown, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        }
        else if (self.dropDownPosition == kSSDropDownPositionBottom)
        {
            
            
            if (_SPECIALCASEBottomCornerRadius)
            {            
                UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(_SPECIALCASEBottomCornerRadius, _SPECIALCASEBottomCornerRadius)];
                shapeLayer = [CAShapeLayer layer];
                shapeLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                shapeLayer.path = bezierPath.CGPath;
                shapeLayer.fillColor = self.backgroundColor.CGColor;
                self.backgroundColor = [UIColor clearColor];
                [self.layer addSublayer:shapeLayer];
                self.tableViewDropDownList.frame = CGRectMake(self.tableViewDropDownList.frame.origin.x, self.tableViewDropDownList.frame.origin.y, self.tableViewDropDownList.frame.size.width, self.tableViewDropDownList.frame.size.height - _SPECIALCASEBottomCornerRadius);
            }
            else
            {
                [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + kDefaultGapBetweenSSDropDownAndViewForDropDown, self.frame.size.width, self.frame.size.height)];
            }
        }
        else if (self.dropDownPosition == kSSDropDownPositionTop)
        {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y - kDefaultGapBetweenSSDropDownAndViewForDropDown, self.frame.size.width, self.frame.size.height)];
        }
        else if (self.dropDownPosition == kSSDropDownPositionRight)
        {
            [self setFrame:CGRectMake(self.frame.origin.x + kDefaultGapBetweenSSDropDownAndViewForDropDown, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        }

    }
}


-(void)removeDropDown
{
    if (_needAnimation)
    {
        [self dismissingAnimation];
    }
    else
    {
        [self needToDoOnRemove];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
}

-(void)needToDoOnRemove
{    
    [viewBackground removeFromSuperview];
    [self removeFromSuperview];
}

-(void)dismissingAnimation
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UIColor *colorOld = viewBackground.backgroundColor;
    CGRect frameOld = self.frame;
    [UIView animateWithDuration:kDefaultAnimationDuration animations:^{
        //        [self setAlpha:1.0f];
        //        [viewBackground setAlpha:1.0f];
        self.clipsToBounds = YES;
        viewBackground.backgroundColor = [UIColor clearColor];
        if (self.dropDownPosition == kSSDropDownPositionBottom)
        {
            self.frame = CGRectMake(frameOld.origin.x, frameOld.origin.y, frameOld.size.width, 0);
        }
        else if (self.dropDownPosition == kSSDropDownPositionTop)
        {
            self.frame = CGRectMake(frameOld.origin.x, frameOld.origin.y + frameOld.size.height, frameOld.size.width, 0);
        }
        else if (self.dropDownPosition == kSSDropDownPositionLeft)
        {
            self.frame = CGRectMake(frameOld.origin.x + frameOld.size.width, frameOld.origin.y,0, frameOld.size.height);
        }
        else if (self.dropDownPosition == kSSDropDownPositionRight)
        {
            self.frame = CGRectMake(frameOld.origin.x, frameOld.origin.y, 0, frameOld.size.height);
        }
        
    }completion:^(BOOL finished) {
        self.frame = frameOld;
        viewBackground.backgroundColor = colorOld;
        [self setClipsToBounds:NO];
        [self needToDoOnRemove];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];

}

#pragma mark - TableView Data Source and Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayItemsToList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (_needCustomCell)
    {
        cell = [self.delegate dropDown:self dropDownTableView:tableView cellForRowAtIndexPath:indexPath andSelectedItem:selectedItem];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        cell.textLabel.text = [_arrayItemsToList objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
        if (selectedItem && [selectedItem isEqual:[_arrayItemsToList objectAtIndex:indexPath.row]])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.backgroundColor = self.backgroundColor;
        cell.contentView.backgroundColor = self.backgroundColor;
    }    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate dropDown:self selectedAnObject:[_arrayItemsToList objectAtIndex:indexPath.row] dropDownForTheView:viewToShowDropDown];
    [self removeDropDown];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_needCustomCell && [self.delegate respondsToSelector:@selector(dropDownTableView: heightForRowAtIndexPath:)])
    {
        return [self.delegate dropDownTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    else
    {
        return kDefaultSSDropDownTableViewCellHeight;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
