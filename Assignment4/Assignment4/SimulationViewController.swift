//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController, EngineDelegate {
    
    @IBOutlet weak var gridView: GridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StandardEngine.engine.delegate = self;
    }

    @IBAction func stepButtonTapped(_ sender: Any) {
        _ = StandardEngine.engine.step()
    }


    func engineDidUpdate(withGrid: GridProtocol) {
        gridView.setNeedsDisplay()
    }
}

