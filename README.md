# SSDropDown

Its a view with tableView

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
[![Version](https://img.shields.io/cocoapods/v/SSDropDown.svg?style=flat)](http://cocoapods.org/pods/SSDropDown)
[![License](https://img.shields.io/cocoapods/l/SSDropDown.svg?style=flat)](http://cocoapods.org/pods/SSDropDown)
[![Platform](https://img.shields.io/cocoapods/p/SSDropDown.svg?style=flat)](http://cocoapods.org/pods/SSDropDown)
[![Join the chat at https://gitter.im/iOS-objectiveC-swift/SSDropDown](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/iOS-objectiveC-swift/SSDropDown?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

### [CocoaPods](https://cocoapods.org/)
````ruby
# For latest release in cocoapods
pod 'SSDropDown'
````

### Carthage
```
git "https://github.com/shebinkoshy/DropDown.git" "carthage"
```
### SwiftPM
To use SwiftPM, you should use Xcode 11 to open your project. Click File -> Swift Packages -> Add Package Dependency, enter [SSDropdown repo's URL](https://github.com/shebinkoshy/DropDown.git) 
After select the package, you can choose the dependency type as branch with ```swiftpackage```. Then Xcode will setup all the stuff for you.

<B>for simple use</B>

Objective C:
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

   #pragma mark - SSDropDownDelegate

   -(void)dropDown:(nonnull SSDropDown*)dropDownViewObj selectedAnObject:(nullable id)selectedDropDownItem dropDownForTheView:(nonnull UIView*)viewForDropDown;
  {
    NSLog(@"tag = %d selected obj %@",(int)dropDownViewObj.tag,selectedDropDownItem);
  }
```

Swift:

```
let dropDown = SSDropDown()
        dropDown.tag = 901
        dropDown.delegate = self
        dropDown.dropDownPosition = kSSDropDownPositionRight
        dropDown.needToShowArrow = true
        dropDown.cornerRadius = 5
        dropDown.dropDownHeight = 120
        dropDown.dropDownWidth = 100
        dropDown.arrayItemsToList = ["1","2","3"]
        dropDown.tableViewDropDownList.showsVerticalScrollIndicator = false
        dropDown.show(for: yourView, withSelectedObject: "1")

// MARK: - SSDropDownDelegate
    
    func dropDown(_ dropDownViewObj: SSDropDown, selectedAnObject selectedDropDownItem: Any?, dropDownForTheView viewForDropDown: UIView) {
        print("tag = \(dropDownViewObj.tag) selected obj \(selectedDropDownItem!)")
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
