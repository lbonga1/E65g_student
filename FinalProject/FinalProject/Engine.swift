//
//  Engine.swift
//  FinalProject
//
//  Created by Lauren Bongartz on 5/7/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import Foundation


protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

protocol EngineProtocol {
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: Timer { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    init(_ rows: Int, _ cols: Int)
    func step() -> GridProtocol
}

class StandardEngine: EngineProtocol {
    var refreshTimer: Timer = Timer.init()
    var cols: Int
    var rows: Int
    var refreshRate: Double = 0.0
    var grid: GridProtocol
    var delegate: EngineDelegate?
    static let engine: StandardEngine = StandardEngine(10, 10)
    
    required init(_ rows: Int, _ cols: Int) {
        self.grid = Grid(rows,cols)
        self.rows = rows
        self.cols = cols
    }
    
    func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        postUpdate()
        return grid
    }
    
    func postUpdate() {
        delegate?.engineDidUpdate(withGrid: grid)
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nc.post(n)
    }
    
    func resetGrid() {
        grid = Grid(10,10)
        postUpdate()
    }
    
}
