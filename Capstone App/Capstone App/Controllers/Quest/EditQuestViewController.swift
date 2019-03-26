//
//  EditQuestViewController.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 26/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class EditQuestViewController: UITableViewController {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalStepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!    
    
    @IBOutlet weak var deleteViewCell: UITableViewCell!
    var quest: Quest?
    
    // MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: Setup
    
    private func setupUI() {
        if let _ = quest {
            setupUIForEdit()
            
        } else {
            setupUIForAdd()
        }
    }
    
    private func setupUIForEdit() {
        navigationItem.title = "Edit Quest"
        deleteViewCell.isHidden = false
    }
    
    private func setupUIForAdd() {
        navigationItem.title = "Add Quest"
        deleteViewCell.isHidden = true
    }
    
    // MARK: Actions
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        goalLabel.text = Int(sender.value).description
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
    }
    
    @IBAction func deleteQuest(_ sender: Any) {
        
    }
}
