//
//  QuestsViewController.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 28/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit
import CoreData

let QuestCollectionViewCellIdentifier = "QuestCollectionViewCell"
let showAddQuestSegue = "showAddQuest"
let showEditQuestSegue = "showEditQuest"

class QuestsViewController: UIViewController {
    
    // MARK: Properties

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataController: DataController!
    var data = [QuestsViewModel]()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAddQuestSegue {
            if let destinationNavigationController = segue.destination as? UINavigationController,
                let targetController = destinationNavigationController.topViewController as? EditQuestViewController {
                targetController.dataController = dataController
            }
        
        } else if segue.identifier == showEditQuestSegue {
            if let destinationNavigationController = segue.destination as? UINavigationController,
                let targetController = destinationNavigationController.topViewController as? EditQuestViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first {
                let quest = data[indexPath.section].quests[indexPath.row]
                targetController.dataController = dataController
                targetController.quest = quest
            }
        }
    }
    
    // MARK: Setup
    
    private func loadData() {
        let questsRequest: NSFetchRequest<Quest> = Quest.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "modified", ascending: false)
        questsRequest.sortDescriptors = [sortDescriptor]
        
        if let result = try? dataController.viewContext.fetch(questsRequest), result.count > 0 {
            let doneQuests = QuestsViewModel.init(status: .complete, quests: result)
            data = [doneQuests]
        } else {
            data = [QuestsViewModel]()
        }
        
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        let itemsPerRow: CGFloat = 1
        let itemsPadding: CGFloat = 10.0
        
        let paddingSpace = itemsPadding * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem / 2
        
        if let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            collectionViewLayout.itemSize = CGSize(width: widthPerItem, height: heightPerItem)
            collectionViewLayout.minimumLineSpacing = itemsPadding
            collectionViewLayout.minimumInteritemSpacing = itemsPadding
            collectionViewLayout.sectionHeadersPinToVisibleBounds = true
        }
        
        collectionView.contentInset = UIEdgeInsets(top: itemsPadding,
                                                   left: itemsPadding,
                                                   bottom: itemsPadding,
                                                   right: itemsPadding)
    }
}

extension QuestsViewController: UICollectionViewDataSource {
    
    // MARK: Sessions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if (data.count == 0) {
            let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
            let noDataLabel = UILabel(frame: frame)
            noDataLabel.numberOfLines = 2
            noDataLabel.text = NSLocalizedString("Start building new habits with Quest. \n Tap the '+' button to start.", comment: "")
            noDataLabel.textAlignment = .center
            collectionView.backgroundView  = noDataLabel
        } else {
            collectionView.backgroundView = nil
        }
        
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "QuestsSectionReusableView",
                                                                   for: indexPath) as! QuestsSectionReusableView
        
        let section = indexPath.section
        
        view.title.text = data[section].status.rawValue
        return view
    }
    
    // MARK: Cells
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].quests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestCollectionViewCellIdentifier, for: indexPath) as! QuestCollectionViewCell
        
        let quest = data[indexPath.section].quests[indexPath.row]
        cell.title.text = quest.name
        
        if let imageData = quest.cover,
            let image = UIImage.init(data: imageData) {
            cell.backgroundView = UIImageView(image: image)
        }
        
        cell.progress.progress = 0
        return cell
    }
}

extension QuestsViewController: UICollectionViewDelegate {
    
}

