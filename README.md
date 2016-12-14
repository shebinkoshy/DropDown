# DropDown

Its a view with tableView

<B>for simple use</B>

```
   DropDown *dropDown = [[DropDown alloc]init];
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

   //#pragma mark - DropDownDelegate

   -(void)dropDown:(nonnull DropDown*)dropDownViewObj selectedAnObject:(nullable id)selectedDropDownItem dropDownForTheView:(nonnull UIView*)viewForDropDown;
   {
       NSLog(@"tag = %d selected obj %@",(int)dropDownViewObj.tag,selectedDropDownItem);
   }
```


<B>With custom cell</B>
Include below code

```
dropDown.needCustomCell = YES;
dropDown.dropDownBackgroundColor = [UIColor blueColor];

-(void)dropDown:(nonnull DropDown*)dropDownViewObj registerCustomCellForTheDropDownTableView:(nonnull UITableView*)dropDownTableView
{
    [dropDownTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"dropDownCell"];
}

-(nonnull UITableViewCell *)dropDown:(nonnull DropDown*)dropDownViewObj dropDownTableView:(nonnull UITableView *)dropDownTableView cellForRowAtIndexPath:(nonnull NSIndexPath *)dropDownIndexPath andSelectedItem:(nullable id)selectedObject;
{
    UITableViewCell *cell = [dropDownTableView dequeueReusableCellWithIdentifier:@"dropDownCell"];
    NSString *title = [dropDownViewObj.arrayItemsToList objectAtIndex:dropDownIndexPath.row];
    cell.textLabel.text = title;
    if ([selectedObject isEqual:title])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.contentView.backgroundColor = [UIColor greenColor];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}
```


<B>Advantages</B>
   can able to use with any subclass of UIView like UITextField, UIButton.

   also with any UI element inside a UITableViewCell or UICollectionViewCell NOTE: For this you should use 
```-(void)showDropDownForView:(nonnull UIView*)viewForDropDown insideTheCell:(nonnull id)cell withSelectedObject:(nullable id)selectedObject;```
