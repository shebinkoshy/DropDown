# DropDown

Its a view with tableView

<B>for simple use</B>

`    DropDown *dropDown = [[DropDown alloc]init];
    dropDown.tag = 901;
    dropDown.delegate = self;
    dropDown.dropDownPosition = kDropDownPositionRight;
    dropDown.needToShowArrow = YES;
    dropDown.cornerRadius = 5.0;
    dropDown.dropDownHeight = 120;
    dropDown.dropDownWidth = 100;
    dropDown.arrayItemsToList = @[@"1",@"2",@"3"];
    [dropDown.tableViewDropDownList setShowsVerticalScrollIndicator:NO];
    [dropDown showDropDownForView:yourView withSelectedObject:@"1"];
    return;


//#pragma mark - DropDownDelegate

-(void)dropDown:(nonnull DropDown*)dropDownViewObj selectedAnObject:(nullable id)selectedDropDownItem dropDownForTheView:(nonnull UIView*)viewForDropDown;
{
    NSLog(@"tag = %d selected obj %@",(int)dropDownViewObj.tag,selectedDropDownItem);
}
`


<B>With custom cell</B>

