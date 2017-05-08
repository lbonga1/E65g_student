//
//  ConfigHandler.swift
//  FinalProject
//
//  Created by Lauren Bongartz on 5/7/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation


public class ConfigHandler {
    let finalProjectURL = "https://dl.dropboxusercontent.com/u/7544475/S65g.json"
    static let configurations = ConfigHandler()
    public var configurationsArray = NSMutableArray()
    
    static func gridFromPoints(_ points: [[Int]]) -> Grid {
        var maxSize: Int = 0
        points.forEach { gridPosition in
            let row = gridPosition[0]
            let col = gridPosition[1]
            maxSize = max(row, col) * 2
        }

        var grid = Grid(maxSize, maxSize)
        points.forEach {gridPosition in
            let row = gridPosition[0]
            let col = gridPosition[1]
            grid[row, col] = .alive
        }
        
        return grid
    }
    
    static func pointsFromGrid(_ grid: Grid) -> [[Int]] {
        var points = [[Int]]()
        
        let gridSize = grid.size
        (0 ..< gridSize.rows)
            .forEach {row in
                (0 ..< gridSize.cols)
                    .forEach { col in
                        let gridCell = grid[row, col]
                        if (gridCell.isAlive) {
                            points.append([row, col])
                        }
                }
        }
        
        return points
    }
    
    public func fetch() {
        let fetcher = Fetcher()
        fetcher.fetchJSON(url: URL(string:finalProjectURL)!) { (json: Any?, message: String?) in
            guard message == nil else {
                print(message ?? "nil")
                return
            }
            guard let json = json else {
                print("no json")
                return
            }
            let configurations = json as! NSArray
            ConfigHandler.configurations.configurationsArray.addObjects(from: configurations as! [Any])
            
            self.postUpdate()
        }
    }
    
    func postUpdate() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ConfigUpdate")
        let n = Notification(name: name)
        nc.post(n)
    }

}
