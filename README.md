# DropDown

Its a view with tableView

[![Version](https://img.shields.io/cocoapods/v/SSDropDown.svg?style=flat)](http://cocoapods.org/pods/SSDropDown)
[![License](https://img.shields.io/cocoapods/l/SSDropDown.svg?style=flat)](http://cocoapods.org/pods/SSDropDown)
[![Platform](https://img.shields.io/cocoapods/p/SSDropDown.svg?style=flat)](http://cocoapods.org/pods/SSDropDown)

### [CocoaPods](https://cocoapods.org/)

````ruby
# For latest release in cocoapods
pod 'SSDropDown'
````

<B>for simple use</B>

```
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
    [dropDown showDropDownForView:yourView withSelectedObject:@"1"];

   //#pragma mark - SSDropDownDelegate

   -(void)dropDown:(nonnull SSDropDown*)dropDownViewObj selectedAnObject:(nullable id)selectedDropDownItem dropDownForTheView:(nonnull UIView*)viewForDropDown;
  {
    NSLog(@"tag = %d selected obj %@",(int)dropDownViewObj.tag,selectedDropDownItem);
  }
```


<B>With custom cell</B>
Include below code

```
dropDown.needCustomCell = YES;
dropDown.dropDownBackgroundColor = [UIColor blueColor];

-(void)dropDown:(nonnull SSDropDown*)dropDownViewObj registerCustomCellForTheDropDownTableView:(nonnull UITableView*)dropDownTableView
{
    [dropDownTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"dropDownCell"];
}

-(nonnull UITableViewCell *)dropDown:(nonnull SSDropDown*)dropDownViewObj dropDownTableView:(nonnull UITableView *)dropDownTableView cellForRowAtIndexPath:(nonnull NSIndexPath *)dropDownIndexPath andSelectedItem:(nullable id)selectedObject;
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

   also with any UI element inside a UITableViewCell or UICollectionViewCell <B>NOTE:</B> For this you should use 

```-(void)showDropDownForView:(nonnull UIView*)viewForDropDown insideTheCell:(nonnull id)cell withSelectedObject:(nullable id)selectedObject;```
