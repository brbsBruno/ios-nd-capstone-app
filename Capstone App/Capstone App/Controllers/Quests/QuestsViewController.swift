//
//  QuestsViewController.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 28/02/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

let QuestCollectionViewCellIdentifier = "QuestCollectionViewCell"

class QuestsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var data = [QuestsViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupCollectionViewLayout()
        setupData()
    }
    
    private func setupData() {
        let pendingQuests = QuestsViewModel.init(status: .pending, quests: ["🏆 Use Quests to build new habits", "☀️ Morning Routine", "📙 Read More Books", "🏃‍♂️ Better Shape"])
        
        let doneQuests = QuestsViewModel.init(status: .complete, quests: ["🎉 Finish my capstone App"])
        
        data = [pendingQuests, doneQuests]
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].quests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuestCollectionViewCellIdentifier, for: indexPath) as! QuestCollectionViewCell
        
        cell.title.text = data[indexPath.section].quests[indexPath.row]
        cell.progress.progress = 0
        return cell
    }
}

extension QuestsViewController: UICollectionViewDelegate {
    
}

