//
//  BackgroundPickerViewController.swift
//  Capstone App
//
//  Created by Bruno Barbosa on 27/03/19.
//  Copyright © 2019 Bruno Barbosa. All rights reserved.
//

import UIKit

let BackgroundCollectionViewCellIdentifier = "BackgroundCollectionViewCell"

enum CollectionViewState {
    case loading
    case populated(FlickrPhotos)
    case empty
    case error(NSError)
}

protocol BackgroundPickerDelegate: AnyObject {
    
    func selectedBackground(image: UIImage)
}

class BackgroundPickerViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: BackgroundPickerDelegate?
    
    var data: FlickrPhotos?
    
    var state = CollectionViewState.loading {
        didSet {
            data = nil
            
            switch state {
            case .loading:
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.center = collectionView.center
                collectionView.backgroundView  = activityIndicator
                activityIndicator.startAnimating()
                
            case .populated(let resultPhotos):
                data = resultPhotos
                collectionView.backgroundView = nil
                
            case .empty:
                let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
                let noDataLabel = UILabel(frame: frame)
                noDataLabel.text = NSLocalizedString("No images found", comment: "")
                noDataLabel.textAlignment = .center
                collectionView.backgroundView  = noDataLabel
                
            case .error(let error):
                let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
                let errorLabel = UILabel(frame: frame)
                errorLabel.text = error.localizedDescription
                errorLabel.textAlignment = .center
                collectionView.backgroundView  = errorLabel
            }
            
            self.collectionView.reloadData()
        }
    }
    
    // MARK: ViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        searchBar.delegate = self
    }
    
    // MARK: Setup
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // TODO:
        let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let noDataLabel = UILabel(frame: frame)
        noDataLabel.numberOfLines = 2
        noDataLabel.text = NSLocalizedString("Find a picture that best fit with your quest.", comment: "")
        noDataLabel.textAlignment = .center
        collectionView.backgroundView  = noDataLabel
        //
        
        setupCollectionViewLayout()
    }
    
    private func setupCollectionViewLayout() {
        let itemsPerRow: CGFloat = 2
        let itemsPadding: CGFloat = 5.0
        
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
    
    // MARK: Actions
    
    private func searchByTheme(_ theme: String) {
        state = .loading
        
        let loadTask = FlickrClient.shared.searchPhotos(text: theme, page: 0) { (data, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.state = .error(error!)
                    return
                }
                
                if let data = data {
                    if let resultPhotos = data.photo, resultPhotos.count > 0 {
                        self.state = .populated(data)
                        
                    } else {
                        self.state = .empty
                    }
                }
            }
        }
        
        loadTask?.resume()
    }
}

extension BackgroundPickerViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if let theme = searchBar.text {
            searchByTheme(theme)
        }
    }

}

extension BackgroundPickerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItemsInSection: Int = data?.photo?.count ?? 0
        return numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCollectionViewCellIdentifier, for: indexPath)
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.center = collectionView.center
        cell.backgroundView = activityIndicator
        activityIndicator.startAnimating()
        
        return cell
    }
    
}

extension BackgroundPickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photo = data?.photo?[indexPath.row] {
            let urlString = photo.url
            let imageURL = URL(string: urlString)!
            
            URLSession.shared.dataTask(with: imageURL) { (data, _, _) in
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        cell.backgroundView = UIImageView(image: image)
                    }
                }
                }.resume()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.alpha = 0.5
            
            if let imageView = cell.backgroundView as? UIImageView,
                let background = imageView.image,
                let delegate = delegate {
                
                delegate.selectedBackground(image: background)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.alpha = 1
        }
    }
    
}
