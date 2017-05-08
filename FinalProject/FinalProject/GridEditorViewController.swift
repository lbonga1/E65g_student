//
//  GridEditorViewController.swift
//  Lecture11
//
//  Created by Van Simmons on 4/17/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class GridEditorViewController: UIViewController, GridViewDataSource {
    
// MARK - Outlets
    @IBOutlet weak var gridView: GridView!
    
// MARK - Variables
    var grid: Grid?
    var configuration: NSDictionary!
    var saveClosure: ((NSDictionary) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.gridDataSource = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpView()
    }
    
// MARK - Actions
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        if let saveClosure = saveClosure {
            let newPoints = ConfigHandler.pointsFromGrid(grid!)
            let changedConfig = NSMutableDictionary()
            changedConfig["contents"] = newPoints
            
            StandardEngine.engine.grid = grid!
            StandardEngine.engine.postUpdate()
            
            saveClosure(changedConfig as NSDictionary)
            self.navigationController!.popViewController(animated: true)
        }
    }

    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
// MARK - Helper Methods
    public subscript (row: Int, col: Int) -> CellState {
        get { return self.grid![row,col] }
        set { self.grid?[row,col] = newValue }
    }
    
    func setUpView() {
        navigationItem.title = configuration!["title"] as? String
        let configPoints = configuration!["contents"] as! [[Int]]
        grid = ConfigHandler.gridFromPoints(configPoints)
        gridView.gridSize = grid!.size
        StandardEngine.engine.grid = grid!
        gridView.setNeedsDisplay()
    }
}
