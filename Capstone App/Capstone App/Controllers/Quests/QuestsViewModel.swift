//
//  QuestsViewModel.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 26/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

struct QuestsViewModel {
    
    enum Status: String {
        case pending
        case complete
    }
    
    var status: Status
    var quests: [String]
}
