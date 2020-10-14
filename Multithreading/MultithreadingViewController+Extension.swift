//
//  MultithreadingViewController+Extension.swift
//  Multithreading
//
//  Created by Trinh Thai on 10/15/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import Foundation

extension MultithreadingViewController {
    
    // MARK: - Synchronous Task
    
    func doSyncTasks() {
        //Synchronous task will perform sequentially in the order in which they are queued
        DispatchQueue.global().async { [unowned self] in
            
            for number in self.intArray {
                DispatchQueue.main.sync {
                    print(number)
                }
            }
            
            for number2 in self.intArray2 {
                DispatchQueue.main.sync {
                    print(number2)
                }
            }
            
            DispatchQueue.main.sync {
                print("Done Synchronous Task!")
            }
        }
    }
    
    // MARK: - Asynchronous Task
    func doAsyncTasks() {
        
        //Asynchronous task will be executed in any order, regardless of when being queued
        for number in intArray {
            DispatchQueue.global().async {
                print(number)
            }
        }
        
        for number2 in intArray2 {
            DispatchQueue.global().async {
                print(number2)
            }
        }
        
        DispatchQueue.main.async {
            print("Done Asynchronous Task")
        }
    }
    
    // MARK: - Block Operations
    func doBlockOperations() {
        
        // Use Block Operation to execute several blocks at once without having to create separate operation objects for each. Order executed is NOT guaranteed
        var blockOperations = [BlockOperation]()
        
        for number in intArray {
            let operation = BlockOperation(block: { print(number) })
            blockOperations.append(operation)
        }
        
        // You MUST add the block operation to an operation queue in order to execute it
        let operationQueue = OperationQueue()
        
        // Add operation blocks to our queue
        blockOperations.forEach {
            
            operationQueue.addOperation($0)
        }
    }
    
    //MARK: Dispatch Group
    
    func doDispatchGroups() {
        
        // Use Dispatch Groups for synchronization of work
        let dispatchGroup = DispatchGroup()
        
        // Each group that enters MUST also leave. Enter/Leave have a 1 to 1 relationship
        dispatchGroup.enter()
        for number in intArray {
            print(number)
        }
        dispatchGroup.leave()
        
        dispatchGroup.enter()
        for number2 in intArray2 {
            print(number2)
        }
        dispatchGroup.leave()
        
        // call dispatch group notify to perform a block of code after all groups are completed
        dispatchGroup.notify(queue: .global()) {
            print("Finished With Group Tasks!")
        }
        
    } // end function
    
    
    //MARK: Dispatch Barrier
    
    func doDispatchBarrier() {
        
        // All items submitted to the queue prior to the dispatch barrier must complete before the barrier will execute.
        
        //Create concurrent dispatch queue (labels are for debugging purposes)
        let concurrentQueue = DispatchQueue(label: "Concurrent", attributes: .concurrent)
        
        for i in 0..<charArray.count/2 {
            
            concurrentQueue.async { [unowned self] in
                print(self.charArray[i])
            }
        }
        
        //Create synchronization point between asynchronous tasks (solves read/write issues)
        concurrentQueue.async(flags: .barrier) {
            print("-----Synchronized Tasks------")
        }
                
        for j in charArray.count/2..<charArray.count {
            concurrentQueue.async { [unowned self] in
                print(self.charArray[j])
            }
        }
    }
    
    
    //MARK: - Dispatch Semaphore
    func doDispatchSemaphore() {
        
        //Semaphores gives us the ability to control access to a shared resource by multiple threads (FIFO order)
        
        //This gives us thread safety. code can be safely called from multiple threads without causing any issues.
        
        //Multiple Queues with different quality of service
        let utilityQueue = DispatchQueue.global(qos: .default)
        let defaultQueue = DispatchQueue.global(qos: .default)
        let userQueue = DispatchQueue.global(qos: .default)
        
        //value passed in signifies how many threads can use the resource at a time
        let semaphore = DispatchSemaphore(value: 1)
        
        //1
        utilityQueue.async {
            print("Kid 1 - wait")
            semaphore.wait() //call wait before using shared resource, this will decrement semaphore value by 1
            print("Kid 1 - wait finished")
            sleep(1) // Kid 1 playing with iPad
            semaphore.signal() // call signal after using resource, this will increase semaphore value by 1
            print("Kid 1 - done with iPad")
        }
        
        //2
        defaultQueue.async {
            print("Kid 2 - wait")
            semaphore.wait()
            print("Kid 2 - wait finished")
            sleep(1) // Kid 2 playing with iPad
            semaphore.signal()
            print("Kid 2 - done with iPad")
        }
        
        //3
        userQueue.async {
            print("Kid 3 - wait")
            semaphore.wait()
            print("Kid 3 - wait finished")
            sleep(1) // Kid 3 playing with iPad
            semaphore.signal()
            print("Kid 3 - done with iPad")
        }
    }
}
