//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Lauren Bongartz on 4/16/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var aliveLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var diedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addObserver()
        updateStatistics()
    }

    func addObserver() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) {(n) in
            self.updateStatistics()
        }
    }
    
    func updateStatistics() {
        let grid = StandardEngine.engine.grid
        
        var empty = 0
        var alive = 0
        var born = 0
        var died = 0
        
        (0 ..< StandardEngine.engine.rows)
            .forEach {i in
                (0 ..< StandardEngine.engine.cols)
                    .forEach {j in
                        switch grid[i, j] {
                        case .empty:
                            empty += 1
                        case .alive:
                            alive += 1
                        case .born:
                            born += 1
                        case .died:
                            died += 1
                        }
                }
        }
        
        emptyLabel.text = "Empty: \(empty)"
        aliveLabel.text = "Alive: \(alive)"
        bornLabel.text = "Born: \(born)"
        diedLabel.text = "Died: \(died)"
    }


}
