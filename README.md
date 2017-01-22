# SYRefreshSwift
## SY Refresh Swift，简单易用的下拉刷新组件，低耦合，使用简单，几行代码即可实现下拉刷新，任何UIScrollView及子类可使用。

## 请使用UIScrollView及子类初始化SYRefresh
1. 属性
 * 各种状态下的提示信息（可以选择设置ready、pulling、refreshing）
 		* ready：松开立即刷新（默认）
 		* pulling：下拉即可刷新（默认）
 		* refreshing：努力刷新中…（默认）
 * imagePulling：展示的图片（默认箭头）
2. 方法
	* `func beginRefreshing() -> Void`（开始刷新，一般不需要手动调用）
	* `func endRefreshing() -> Void`（数据获取完成，调用这个方法以结束刷新动画）
	* `func isRefreshing() -> Bool`（是否正在刷新，默认NO）
   * `func setImagePulling(imagePull:UIImage!) -> Void`（设置图片，默认arrowDown）
3. 用法简单（几行代码即可实现下拉刷新）

```
refresh = SYRefresh.init(scrollView: tableview)
//refresh.pulling = "pulling"
//refresh.ready = "ready"
refresh.refreshing = "refreshing"
refresh.addTarget(self, action: #selector(refreshitems), for: .valueChanged)
```

## Example
```objc
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableview : UITableView!
    var items : Array<String>!
    var refresh : SYRefresh!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        items = ["s","w","i","f","t"]
        
        tableview = UITableView.init(frame: self.view.bounds, style: .plain)
        tableview.dataSource = self
        tableview.delegate = self
        self.view.addSubview(tableview)
        
        //刷新组件
        refresh = SYRefresh.init(scrollView: tableview)
        refresh.addTarget(self, action: #selector(refreshitems), for: .valueChanged)
        //refresh.pulling = "pulling"
        //refresh.ready = "ready"
        refresh.refreshing = "refreshing"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "idcell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: id)
        }
        cell?.textLabel?.text = items[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
    }
    
    func refreshitems() -> Void {
        items.removeAll()

        let count : UInt32 = (arc4random() % 10) + 1
        
        for i : UInt32 in 0 ..< count {
            items.append(String.init(i))
        }

        let delayTime = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * 2.5)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { () -> Void in
            //刷新结束
            self.refresh.endRefreshing()
            self.tableview.reloadData()
        }
    }
}

```

## UI

![intro png](https://github.com/reesun1130/SYRefreshSwift/blob/master/SYRefreshSwiftDemo/refresh.png)

## Installation

### CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like JSPatch in your projects. See the ["Getting Started"](https://guides.cocoapods.org/using/getting-started.html) guide for more information.

```ruby
# Your Podfile
platform :ios, '8.0'
pod 'SYRefreshSwift'
```
### Manually
1.	复制 `SYRefresh.swift` `arrowDown.png` 到你的project
2.	直接拷贝 `SYRefreshSwift/`目录到你的project.

## Usage

### Swift
1. 使用你的UIScrollView或者子类初始化

   `refresh = SYRefresh.init(scrollView: tableview)`
   
2. refresh添加target

   `refresh.addTarget(self, action: #selector(refreshitems), for: .valueChanged)`
   
3. optional可选设置
   * 设置刷新各种状态下的标题
   `refresh.pulling = "pulling"`
   `refresh.ready = "ready"`
   `refresh.refreshing = "refreshing"`
   
   * 设置显示图片
   `refresh.setImagePulling(imagePull:)`
   
4. 刷新结束，停止动画 `refresh.endRefreshing()`

## Enviroment
- iOS 8+
- Swift
- Support armv7/armv7s/arm64

## Misc

### Author

- Name: [Ree Sun](https://github.com/reesun1130)
- Email: <ree.sun.cn@hotmail.com>

### License

This code is distributed under the terms and conditions of the MIT license. 

### Contribution guidelines

**NB!** If you are fixing a bug you discovered, please add also a unit test so I know how exactly to reproduce the bug before merging.
