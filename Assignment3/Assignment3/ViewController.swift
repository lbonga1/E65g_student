//
//  ViewController.swift
//  Assignment3
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gridView: GridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridView.size = 20
        gridView.livingColor = UIColor.green
        gridView.bornColor = UIColor.green.withAlphaComponent(0.6)
        gridView.emptyColor = UIColor.darkGray
        gridView.diedColor = UIColor.darkGray.withAlphaComponent(0.6)
        gridView.gridColor = UIColor.black
        gridView.gridWidth = 2.0
    }

    @IBAction func stepAction(_ sender: Any) {
        gridView.grid = gridView.grid.next()
        gridView.setNeedsDisplay()
    }

}

