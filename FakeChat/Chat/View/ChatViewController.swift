//
//  ChatViewController.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import UIKit

class ChatViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChatItemCell.self, forCellWithReuseIdentifier: ChatItemCell.cellID)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var items: [ChatItem] = []
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        // TODO: fetch items from repository (call interactor.fetchData()) в него при старте подгружается 20 ячеек разной высоты
        items = ChatRepository().getChatItems()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatItemCell.cellID, for: indexPath) as! ChatItemCell
        cell.setData(text: items[indexPath.row].text)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceHeight: CGFloat = 100
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
        - sectionInset.left
        - sectionInset.right
        - collectionView.contentInset.left
        - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: referenceHeight)
    }
    
    // prefetch
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 10 && !self.isLoading {
            loadMoreData()
        }
    }
    
    // TODO: scroll to 1000th position -> scrollToItem(at:at:animated:)
}

extension ChatViewController: ChatViewProtocol {
    
    func show(items: [ChatItem]) {
        // TODO: append chat items
    }
}

// MARK: - Fetch data

extension ChatViewController {
    
    private func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(2)
                let start = self.items.count
                let end = start + 20
                self.isLoading = false
                    // TODO: load next 20
            }
        }
    }
}
