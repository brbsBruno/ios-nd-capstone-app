//
//  QuestsSectionReusableView.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 26/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class PillLabel : UILabel {
    
    override var intrinsicContentSize: CGSize {
        let horizontalPadding: CGFloat = 2
        let verticalPadding: CGFloat = 3
        
        let superSize = super.intrinsicContentSize
        let newWidth = superSize.width + superSize.height + (2 * horizontalPadding)
        let newHeight = superSize.height + (2 * verticalPadding)
        let newSize = CGSize(width: newWidth, height: newHeight)
        return newSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        layer.cornerRadius = frame.height / 2
        backgroundColor = UIColor.darkGray
        
        layer.masksToBounds = true
        textAlignment = .center
        textColor = UIColor.white
    }
}

class QuestsSectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var title: PillLabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}
