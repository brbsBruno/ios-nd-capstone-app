//
//  QuestCollectionViewCell.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 24/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class QuestCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var progress: UIProgressView!
    
    override var bounds: CGRect {
        didSet {
            setupUI()
        }
    }
    
    private func setupUI() {
        layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        title.text = nil
        image.image = nil
        progress.progress = 0
    }
}
