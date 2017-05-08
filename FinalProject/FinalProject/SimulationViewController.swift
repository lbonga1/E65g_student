//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {
    
    @IBOutlet weak var gridView: GridView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserver()
    }

// MARK - Actions
    @IBAction func stepButtonTapped(_ sender: Any) {
        StandardEngine.engine.refreshTimer.invalidate()
        _ = StandardEngine.engine.step()
    }

    @IBAction func resetTapped(_ sender: UIBarButtonItem) {
        StandardEngine.engine.resetGrid()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        showSaveAlert()
    }
    
//MARK: AlertController Handling 
    func showSaveAlert() {
        let alert = UIAlertController(title: "Save Grid", message: "Enter title to save configuration:", preferredStyle: .alert)
        
        let saveAlertAction = UIAlertAction(title: "Save", style: .default) {_ in
            let textField = alert.textFields![0] as UITextField
            let points = ConfigHandler.pointsFromGrid(StandardEngine.engine.grid as! Grid)
            let configuration = NSMutableDictionary()
            
            configuration["title"] = textField.text
            configuration["contents"] = points
            
            ConfigHandler.configurations.configurationsArray.add(configuration)
            
            let defaults = UserDefaults.standard
            defaults.set(configuration, forKey: "simulationConfiguration")
        }
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAlertAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
        
        self.present(alert, animated: true, completion: nil)
    }
    
// MARK - Helper Methods
    func addObserver() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) {(n) in
            self.updateGrid()
        }
    }
    
    func updateGrid() {
        gridView.setNeedsDisplay()
    }
}

