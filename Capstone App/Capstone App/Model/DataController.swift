//
//  DataController.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 26/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> ())? = nil) {
        persistentContainer.loadPersistentStores() { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
        
        completion?()
    }
    
}
