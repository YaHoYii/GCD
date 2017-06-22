//
//  ViewController.swift
//  GCDDemo
//
//  Created by 太阳在线YHY on 2017/4/22.
//  Copyright © 2017年 太阳在线. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
	
	var inactiveQueue: DispatchQueue!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

	// 队列里的任务是并发还是串行,一个队列里边有很多任务的话，如果队列是串行的，那么这些任务就一个一个顺序执行，如果队列是并行的话，就同时执行
	// 队列和队列之间是同步执行还是异步，两个队列之间，如果第一个队列异步执行，那么它开始之后就会跳出来执行第二个。如果第一个是同步执行，那么他会等队列任务执行完之后再去执行第二个任务。
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
		// 串行队列顺序执行
		//	simpleSyncQueues()
		//	simpleAsyncQueues()
		//  simpleQueues()
		//  simpleQueues1()
        
		//  queuesWithQoS()
        
		
//			concurrentAsyncQueues()
//	
//		 if let queue = inactiveQueue {
//		    queue.activate()
//		}
		
		
		//	 queueWithDelay()
        
		  fetchImage()
        
		//  useWorkItem()
    }
    
    
	// 同步工作
    func simpleSyncQueues() {
		print("=============同步=============")
        let queue = DispatchQueue(label: "com.YaHoYi")
		
		queue.sync {
			for i in 0..<10 {
				print("😑",i)
			}
		}
		
		for i in 100..<110 {
			print("👻",i)
		}
    }
	// 异步工作
	func simpleAsyncQueues() {
		
		print("============异步=============")
		
		let queue = DispatchQueue(label: "com.YaHoYii")
		
		queue.async {
			
			for i in 0..<10 {
				print("💣",i)
			}
		}
		
		queue.async {
			
			for i in 20..<30 {
				print("✈️",i)
			}
		}

		for i in 100..<110 {
			
			print("🚀",i)
		}
		
		
	}
	
	// 串行队列，同步异步一起玩
	
	func simpleQueues() {
		
		print("===========先异步后同步===========")
		
		let queue = DispatchQueue(label: "com.YaHoYiii")
		let queue1 = DispatchQueue(label: "com.YaHoYiii1")
		
		queue.async {
			for i in 0..<10 {
				print("🍎",i)
			}
		}
		
		queue1.sync {
			for i in 0..<10 {
				print("🍑",i)
			}
		}
	
	}
	
	func simpleQueues1() {
		
		print("===========先同步后异步===========")
		
		let queue = DispatchQueue(label: "com.YaHoYiii")
		let queue1 = DispatchQueue(label: "com.YaHoYiii1")
		
		queue.sync {
			for i in 0..<10 {
				print("🍎",i)
			}
		}
		
		queue1.async {
			for i in 0..<10 {
				print("🍑",i)
			}
		}
		
	}
	
	
	
	
    
	// qos参数影响系统给予的优先级
    func queuesWithQoS() {
		
		// 高优先级队列
		let queue1 = DispatchQueue(label: "com.YaHoYi1", qos: .userInitiated)
		// 低优先级队列
		let queue2 = DispatchQueue(label: "com.YaHoYi2", qos: .utility)
		
	
		queue1.async {
			for i in 0..<10 {
				print("🙂",i)
			}
		}
		
		queue2.async {
			for i in 100..<110 {
				print("😂",i)
			}
		}
		
		// 主线程队列，优先级最高
		for i in 1000..<1010 {
			print("Ⓜ️", i)
		}
		
		//看到默认主队列具有高优先级，并且主队列与queue1主队同时执行。在queue2最后结束的同时正在执行其他两个队列的任务执行不会得到很多的机会，因为它的优先级最低。
		
    }
	
	// 以前的例子的共同之处在于我们的队列是串行的。这意味着如果我们将多个任务分配给任何队列，那么这些任务将一个接一个执行，而不是全部同时执行,接下来会研究多个任务同时执行，即并发队列
	
 // 新的参数：attributes参数的值concurrent，是并发队列的标记。如果不使用此参数，则队列是串行的。此外，QoS参数不是必需的，我们可以省略它在初始化中没有任何问题。
    func concurrentAsyncQueues() {
		//使用attributes的参数值 initiallyInactive，任务不会自动启动，必须手动触发，不然会发生运行错误
		// let anotherQueue = DispatchQueue(label: "com.YaHoYi3", qos: .utility,attributes: .concurrent)
		
		// 首先，声明一个文件内的类属性inactiveQueue，但是运行出来的是串行
		// let anotherQueue = DispatchQueue(label: "com.YaHoYi3", qos: .utility,attributes: .initiallyInactive)
		// 实现并发队列
		let anotherQueue = DispatchQueue(label: "com.YaHoYi3", qos: .utility,attributes: [.initiallyInactive,.concurrent])

		
		// 然后把初始化好的队列们把它分配给inactiveQueue 分配给 inactiveQueue
		// 原因很简单 因为需要手动启动嘛，anotherQueue是方法内的实例
		inactiveQueue = anotherQueue
		
		inactiveQueue.async {
			for i in 0..<10 {
				print("⚽️",i)
			}
		}
		
		inactiveQueue.async {
			for i in 100..<110 {
				print("🏀",i)
			}
		}
		
		inactiveQueue.async {
			for i in 1000..<1010 {
				print("🏐",i)
			}
		}
		
    }
    
    
    func queueWithDelay() {

		//创建一个并发队列
		let delayQueue = DispatchQueue(label: "com.YaHoYie", qos: .utility, attributes: .concurrent)
		// 输出当前时间，用于延迟对比
		print("1",Date())
		// 设置延迟时间
		let additionalTime: DispatchTimeInterval = .seconds(5)
		// 队列延迟执行5秒
		delayQueue.asyncAfter(deadline: .now() + additionalTime) {
			print("2",Date())
		}
		// 队列延迟执行10秒
		delayQueue.asyncAfter(deadline: .now() + 10) {
			print("3",Date())
		}
		
    }
    
    
    func fetchImage() {
		
		let imageURL: URL = URL(string: "http://img06.tooopen.com/images/20160921/tooopen_sy_179583447187.jpg")!
		
		(URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: { (imageData, response, error) in
			
			if let data = imageData {
				print("下载图片")
				// 更新 imageView 展示图片。切记更新 UI 要在主队列中
				DispatchQueue.main.async {
					self.imageView.image = UIImage(data: data)
				}
				
			}
		}).resume()
		
    }
	
	
    func useWorkItem() {
		var value = 10
		let workItem = DispatchWorkItem {
			value += 5
			print(value)
		}
		// 执行 workItem
		workItem.perform()
		// 全局队列
		let queue = DispatchQueue.global(qos: .utility)
		queue.async {
			workItem.perform()
		}
		
		// 通知一个队列，可以是主队列也可以是其他的队列
//		workItem.notify(queue: DispatchQueue.main) { 
//			print("value = ", value)
//		}
//		
    }
}

