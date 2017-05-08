//
//  InstrumentationViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 1/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
// MARK - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var sizeStepper: UIStepper!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var timedRefreshSwitch: UISwitch!

// MARK - Variables
    override func viewDidLoad() {
        super.viewDidLoad()
         addObserver()
        ConfigHandler.configurations.fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setUpView()
    }

// MARK: TableView DataSource and Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConfigHandler.configurations.configurationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "grid_cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let label = cell.contentView.subviews.first as! UILabel
        let jsonDictionary = ConfigHandler.configurations.configurationsArray.object(at: indexPath.row) as! NSDictionary
        label.text = jsonDictionary["title"] as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Configurations"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let config = ConfigHandler.configurations.configurationsArray.object(at: indexPath.row)
            ConfigHandler.configurations.configurationsArray.remove(config)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        if let indexPath = indexPath {
            var configuration = ConfigHandler.configurations.configurationsArray[indexPath.row]
            if let vc = segue.destination as? GridEditorViewController {
                vc.configuration = configuration as! NSDictionary
                vc.saveClosure = { newValue in
                    configuration = newValue
                    self.tableView.reloadData()
                }
            }
        }
    }
    
// MARK - Helper Methods
    func fetchComplete() {
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }
    
    func addObserver() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "ConfigUpdate")
        nc.addObserver(forName: name, object: nil, queue: nil) {(n) in
            self.fetchComplete()
        }
    }
    
    func setUpView() {
        sizeStepper.value = Double(StandardEngine.engine.rows)
        sizeTextField.text = String(StandardEngine.engine.rows)
        tableView.reloadData()
    }
    
//MARK: AlertController Handling
    func showErrorAlert(withMessage msg:String, action: (() -> Void)? ) {
        let alert = UIAlertController(
            title: "Alert",
            message: msg,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true) { }
            OperationQueue.main.addOperation { action?() }
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    
// MARK - Actions
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        sizeTextField.text = String(Int(sender.value))
        let size = Int(sender.value)
        StandardEngine.engine.grid = Grid(size, size)
        StandardEngine.engine.postUpdate()
    }
    
    @IBAction func sizeTextFieldDidEndEditing(_ sender: UITextField) {
        guard let text = sender.text else { return }
        guard let val = Int(text) else {
            showErrorAlert(withMessage: "Invalid value: \(text), please try again.") {
                sender.text = "\(StandardEngine.engine.rows)"
            }
            return
        }
        
        sizeStepper.value = Double(sender.text!)!
        StandardEngine.engine.grid = Grid(val, val)
        StandardEngine.engine.postUpdate()
        sender.resignFirstResponder()
    }
    
    
    @IBAction func refreshRateChanged(_ sender: UISlider) {
        StandardEngine.engine.refreshRate = TimeInterval(1 / sender.value)
    }
    
    @IBAction func timedRefreshValueChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            StandardEngine.engine.refreshTimer = Timer.scheduledTimer(
                withTimeInterval: TimeInterval(refreshSlider.value),
                repeats: true
            ) { (t: Timer) in
                _ = StandardEngine.engine.step()
                StandardEngine.engine.postUpdate()
            }
        } else {
            StandardEngine.engine.refreshTimer.invalidate()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let newConfig = NSMutableDictionary()
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy hh:mm"
        let dateString = formatter.string(from: date)
        
        newConfig["title"] = "New Config: \(dateString)"
        newConfig["contents"] = [[Int]]()
        
        ConfigHandler.configurations.configurationsArray.add(newConfig)
        tableView.reloadData()
    }
}

