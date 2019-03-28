//
//  EditQuestViewController.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 26/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

let showBackgroundPicker = "showBackgroundPicker"

class EditQuestViewController: UITableViewController, FailableView {
    
    // MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalStepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!    
    
    
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var creditsTextView: UITextView!
    
    @IBOutlet weak var deleteViewCell: UITableViewCell!
    var quest: Quest?
    
    var dataController: DataController!
    
    // MARK: ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showBackgroundPicker {
            if let destination = segue.destination as? BackgroundPickerViewController {
                destination.delegate = self
            }
        }
    }
    
    // MARK: Setup
    
    private func setupUI() {
        titleTextField.addTarget(self, action: #selector(toggleSaveButtonActive), for: .editingChanged)
        
        if let quest = quest {
            setupUIForEdit(quest: quest)
            
        } else {
            setupUIForAdd()
        }
        
        setupCreditsLabel()
    }
    
    private func setupUIForEdit(quest: Quest) {
        navigationItem.title = "Edit Quest"
        deleteViewCell.isHidden = false
        titleTextField.text = quest.name
        goalLabel.text = String(quest.goal)
        goalStepper.value = Double(quest.goal)
        if let imageData = quest.cover,
            let image = UIImage.init(data: imageData) {
            imageView.image = image
        }
    }
    
    private func setupUIForAdd() {
        navigationItem.title = "Add Quest"
        deleteViewCell.isHidden = true
    }
    
    private func setupCreditsLabel() {
        let authorURL = "https://www.flaticon.com/authors/daniel-bruce"
        let repoURL = "https://www.flaticon.com"
        
        let credits = NSAttributedString(string: NSLocalizedString("Camera Icon made by ", comment: ""))
        let author = NSAttributedString(string: NSLocalizedString("Daniel Bruce", comment: ""), attributes:[NSAttributedString.Key.link: URL(string: authorURL)!])
        let from = NSAttributedString(string: NSLocalizedString(" from ", comment: ""))
        let repo = NSAttributedString(string: NSLocalizedString("www.flaticon.com", comment: ""), attributes:[NSAttributedString.Key.link: URL(string: repoURL)!])
        
        let attributedText = NSMutableAttributedString()
        attributedText.append(credits)
        attributedText.append(author)
        attributedText.append(from)
        attributedText.append(repo)
        
        creditsTextView.attributedText = attributedText
        creditsTextView.textAlignment = .center
        creditsTextView.textColor = .gray
    }
    
    // MARK: Actions
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        goalLabel.text = Int(sender.value).description
        toggleSaveButtonActive()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if let title = titleTextField.text,
            let goalString = goalLabel.text,
            let goal = Int16(goalString) {
            
            if quest == nil {
                quest = Quest(context: dataController.viewContext)
            }
            
            if let quest = quest {
                quest.name = title
                quest.goal = goal
                
                if let image = imageView.image {
                    quest.cover = image.pngData()
                }
                
                quest.modified = Date()
            }
            
            do {
                try dataController.viewContext.save()
                self.dismiss(animated: true, completion: nil)
            } catch {
                let error = NSLocalizedString("Error", comment: "")
                let message = NSLocalizedString("Failed to Save Quest", comment: "")
                displayFailureAlert(title: error, error: message)
            }
        }
    }
    
    @IBAction func deleteQuest(_ sender: Any) {
        if let quest = quest {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: "Delete Quest", style: .destructive) { (action) in
                self.dataController.viewContext.delete(quest)
                do {
                    try self.dataController.viewContext.save()
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    let error = NSLocalizedString("Error", comment: "")
                    let message = NSLocalizedString("Failed to Delete Quest", comment: "")
                    self.displayFailureAlert(title: error, error: message)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Helpers
    
    @objc private func toggleSaveButtonActive() {
        var enable = false
        
        if let title = titleTextField.text,
            let goalString = goalLabel.text,
            let goal = Int(goalString), title.count > 0 && Int(goal) > 0  {
            enable = true
        }
        
        saveButton.isEnabled = enable
    }
    
}

extension EditQuestViewController: BackgroundPickerDelegate {
    
    func selectedBackground(image: UIImage) {
        imageView.image = image
        toggleSaveButtonActive()
    }
    
}
