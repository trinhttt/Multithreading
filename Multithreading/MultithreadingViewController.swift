//
//  ViewController.swift
//  Multithreading
//
//  Created by Trinh Thai on 10/15/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit

class MultithreadingViewController: UIViewController {
    
    var tableView: UITableView!
    
    let CELL_IDENTIFIER = "CellID"
    
    var index = 0
    let urls: [String] = ["https://images5.alphacoders.com/689/689398.jpg",
                             "https://khoahocphattrien.vn/Images/Uploaded/Share/2019/03/13/dGhpZW5uaGllbg.jpg",
                             "https://post.greatist.com/wp-content/uploads/sites/3/2020/02/325466_1100-1100x628.jpg",
                             "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRCcdS8f6L5Aonc9oUP3UfD2PAPUmqF-_IBcw&usqp=CAU",
                             "https://images5.alphacoders.com/689/689398.jpg"]
    let intArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let intArray2 = [21, 22, 23, 24, 25, 26, 27, 28, 29]
    let charArray = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
  
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: self.view.frame)
        self.view.addSubview(tableView)
        editTableView()
    }
    
    func editTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
    }
}

extension MultithreadingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create reference to dequeuecell
        var dequeueCell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER)
        
        //check if cell is nil, if so instantiate cell
        if dequeueCell == nil {
            
            dequeueCell = UITableViewCell(style: .subtitle, reuseIdentifier: CELL_IDENTIFIER)
        }
        
        //set cell = to dequeueCell
        let cell = dequeueCell!
        
        //set cell text label and subtitle number of lines (0 = enclose text)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        
        //create switch to check indexPath.row
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Dispatch.main.sync"
            cell.detailTextLabel?.text = "Performs tasks sequentially on main thread"
        case 1:
            cell.textLabel?.text = "Dispatch.global.async"
            cell.detailTextLabel?.text = "Performs tasks concurrently on global thread"
        case 2:
            cell.textLabel?.text = "Serial tasks"
            cell.detailTextLabel?.text = "Execute Serial tasks"
        case 3:
            cell.textLabel?.text = "Concurrent tasks"
            cell.detailTextLabel?.text = "Execute Concurrent tasks"
        case 4:
            cell.textLabel?.text = "Download image serially"
            cell.detailTextLabel?.text = "Download image serially"
        case 5:
            cell.textLabel?.text = "Operations"
            cell.detailTextLabel?.text = "executes its queued Operation objects based on their priority and readiness"
        case 6:
            cell.textLabel?.text = "Operation Blocks"
            cell.detailTextLabel?.text = "Execute several blocks concurrently"
        case 7:
            cell.textLabel?.text = "Dispatch Groups"
            cell.detailTextLabel?.text = "Perform groups of task synchronously and be notified upon completion"
        case 8:
            cell.textLabel?.text = "Dispatch Barrier"
            cell.detailTextLabel?.text = "Create a synchronization point within a concurrent queue "
        case 9:
            cell.textLabel?.text = "Dispatch Semaphore"
            cell.detailTextLabel?.text = "Can be used to control access to a resource across multiple execution threads"
        default:
            break
        }
        
        return cell
    }
}

extension MultithreadingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            doSyncTasks()
        case 1:
            doAsyncTasks()
        case 2:
            doSerialTasks()
        case 3:
            doConcurrentTasks()
        case 4:
            downloadImage()
        case 5:
            doOperationQueue()
        case 6:
            doBlockOperations()
        case 7:
            doDispatchGroups()
        case 8:
            doDispatchBarrier()
        case 9:
            doDispatchSemaphore()
        default:
            break
        }
    }
}
