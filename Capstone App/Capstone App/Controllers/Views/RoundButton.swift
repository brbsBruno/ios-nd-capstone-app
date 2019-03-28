//
//  RoundButton.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 27/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override var intrinsicContentSize: CGSize {
        let horizontalPadding: CGFloat = 10
        let verticalPadding: CGFloat = 10
        
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
        backgroundColor = UIColor.white
        
        layer.masksToBounds = true
    }

}
