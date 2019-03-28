//
//  QuestsSectionReusableView.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 26/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

class QuestsSectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var title: PillLabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}
