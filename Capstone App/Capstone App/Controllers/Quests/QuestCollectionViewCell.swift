//
//  QuestCollectionViewCell.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 24/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

protocol QuestCollectionViewCellDelegate {
    
    func logQuest(_ quest: Quest)
    
}

class QuestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var logButton: RoundButton!
    
    var delegate: QuestCollectionViewCellDelegate?
    
    var quest: Quest? {
        didSet {
            setupUI()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setupUI()
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
        
        if let quest = quest {
            title.text = quest.name
            
            if let imageData = quest.cover,
                let imageFromData = UIImage.init(data: imageData) {
                image.image = imageFromData
            } else {
                image.image = nil
            }
            
            logButton.isHidden = false
            if let log = quest.log {
                let isToday = Calendar.current.isDateInToday(log)
                
                if isToday {
                    logButton.isHidden = true
                }
            }
            
            let buttonText = "+1/\(quest.goal)"
            logButton.titleLabel?.text = buttonText
            
            var currentProgress = Float(0)
            if quest.goal > 0 {
                currentProgress = Float(quest.streak)/Float(quest.goal)
            }
            
            progress.progress = currentProgress
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title.text = nil
        image.image = nil
        progress.progress = 0
        logButton.titleLabel?.text = "+1"
    }
    
    @IBAction func log(_ sender: Any) {
        if let quest = quest,
            let delegate = delegate{
            delegate.logQuest(quest)
            setupUI()
        }
    }
    
}
