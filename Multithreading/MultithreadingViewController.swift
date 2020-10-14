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
    
    let intArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let intArray2 = [21, 22, 23, 24, 25, 26, 27, 28, 29]
    let charArray = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    
    
    let concurrentQueue = DispatchQueue(label: "cqueue",attributes: .concurrent) // concurrent queue operation done in concurrently  depending on the system's current conditions and resources. The decision on when to start a task is up to GCD
    
    let serialQueue = DispatchQueue(label: "squeue") // serial queue operation done in sequence output will be task 1, task 2,task 3
    
    // enum indicating the 3 tasks
    enum Tasks:String{
        case Task1 = "Task 1"
        case Task2 = "Task 2"
        case Task3 = "Task 3"
    }
    
    @IBOutlet weak var progress1: UIProgressView!
    @IBOutlet weak var progress2: UIProgressView!
    @IBOutlet weak var progress3: UIProgressView!
    @IBOutlet weak var taskF1: UILabel!
    @IBOutlet weak var taskF2: UILabel!
    @IBOutlet weak var taskF3: UILabel!
    @IBAction func serialButtonTapped(_ sender: Any) {
        
        // MARK:- add serial tasks for different progressview
        serialQueue.async {
            self.performCalculation(5000, tag: Tasks.Task1, taskProgress: self.progress1)
        }
        serialQueue.async {
            self.performCalculation(80000, tag: Tasks.Task2, taskProgress: self.progress2)
        }
        serialQueue.async {
            self.performCalculation(500, tag: Tasks.Task3, taskProgress: self.progress3)
        }
        
    }
    @IBAction func concurrentButtonTapped(_ sender: Any) {
        // MARK:- add concurrent tasks for different progressview
        
        concurrentQueue.async {
            self.performCalculation(5000, tag: Tasks.Task1, taskProgress: self.progress1)
        }
        concurrentQueue.async {
            self.performCalculation(80000, tag: Tasks.Task2, taskProgress: self.progress2)
        }
        concurrentQueue.async {
            self.performCalculation(500, tag: Tasks.Task3, taskProgress: self.progress3)
        }
        
    }
    
    func performCalculation(_ iterations: Int, tag: Tasks,taskProgress:UIProgressView) {
        let start = CFAbsoluteTimeGetCurrent() // begin time for starting task
        for x in 0...iterations {
            // MARK:- Precantage for progressview calculation.
            
            let value:Float = Float((iterations - (iterations-x)))
            let ResultPrecntage = Float(value/Float(iterations))
            let ApproximatedValue = Float(String(format: "%.1f", ResultPrecntage))
            
            // MARK:- update the UI progressview using Main Thread
            DispatchQueue.main.async {
                
                taskProgress.setProgress(ApproximatedValue ?? 0.0, animated: true) // update progressView Indicator
                
            }
        }
        let end = CFAbsoluteTimeGetCurrent() // end time for starting task
        
        // MARK:- update tasks end time UI labels using Main Thread
        DispatchQueue.main.async {
            switch tag {
            case .Task1 :
                self.taskF1.text = "Task 1 Finished : Time \(end-start)"
            case .Task2:
                self.taskF2.text = "Task 2 Finished : Time \(end-start)"
            case .Task3:
                self.taskF3.text = "Task 3 Finished : Time \(end-start)"
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init table view with the frame of the view
        tableView = UITableView(frame: self.view.frame)
        
        //add table view to view as sub view
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
        return 6
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
            cell.textLabel?.text = "Operation Blocks"
            cell.detailTextLabel?.text = "Execute several blocks concurrently"
        case 3:
            cell.textLabel?.text = "Dispatch Groups"
            cell.detailTextLabel?.text = "Perform groups of task synchronously and be notified upon completion"
        case 4:
            cell.textLabel?.text = "Dispatch Barrier"
            cell.detailTextLabel?.text = "Create a synchronization point within a concurrent queue "
        case 5:
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
            doBlockOperations()
        case 3:
            doDispatchGroups()
        case 4:
            doDispatchBarrier()
        case 5:
            doDispatchSemaphore()
        default:
            break
        }
    }
}
