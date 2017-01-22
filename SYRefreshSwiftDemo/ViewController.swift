//
//  ViewController.swift
//  SYRefreshSwift
//
//  Created by reesun on 2017/1/6.
//  Copyright © 2017年 SY. All rights reserved.
//

import UIKit

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

