//
//  ChatViewController.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import UIKit

class ChatViewController: UIViewController {
    
    enum Section: Int {
        case main = 0
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ChatItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ChatItem>
    
    /// a tuple that contains a frame (index - (index + offset)) in which position we have a gap
    /// for example: [0...40] ...a gap is here... [980...1010]
    private var gapFrame: (start: Int, end: Int)? = nil
    
    private let pageCount = 20
    private let offsetBeforeFetching = 10
    private let pinnedItemPosition = 1000
    private var previousPresnetedCellIndex = 0
    
    private let viewPadding = CGFloat(16)
    private let approximateCellHeight = CGFloat(100)
    
    private var items: [ChatItem] = []
    private var isLoading = false
    
    var chatRepository: ChatRepositoryProtocol?
    
    var itemsCount: Int {
        dataSource.snapshot().numberOfItems
    }
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        collectionView = .init(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.contentInset = UIEdgeInsets(top: viewPadding, left: viewPadding, bottom: viewPadding, right: viewPadding)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(ChatItemCell.self, forCellWithReuseIdentifier: ChatItemCell.cellID)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChatItemCell.cellID,
                    for: indexPath) as? ChatItemCell
                cell?.setData(item)
                return cell
            })
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupViews()
        loadData(direction: .forward(start: 0, end: pageCount))
    }
}

// MARK: - View

extension ChatViewController {
    
    private func setupViewController() {
        title = "chat".localized
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "barButton".localized,
            style: .plain,
            target: self,
            action: #selector(scrollToItem)
        )
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

extension ChatViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInset = (collectionViewLayout as! UICollectionViewFlowLayout).sectionInset
        let referenceWidth = collectionView.safeAreaLayoutGuide.layoutFrame.width
        - sectionInset.left
        - sectionInset.right
        - collectionView.contentInset.left
        - collectionView.contentInset.right
        return CGSize(width: referenceWidth, height: approximateCellHeight)
    }
}

// MARK: - Fetching Data in Both Directions

extension ChatViewController {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
        if !isLoading {
            
            let isBackwardScrolling = indexPath.row < previousPresnetedCellIndex
            
            if isBackwardScrolling {
                if indexPath.row > pageCount {
                    let itemBeforeOffset = items[indexPath.row - offsetBeforeFetching]
                    if let gapFrame, itemBeforeOffset.number == gapFrame.end {
                        
                        loadData(direction: .backward(start: gapFrame.end - pageCount, end: gapFrame.end - 1, beforeItem: itemBeforeOffset)) {
                            
                            self.gapFrame = (start: gapFrame.start, end: gapFrame.end - self.pageCount)
                        }
                    }
                }
            } else {
                if indexPath.row == itemsCount - offsetBeforeFetching {
                    let lastItem = dataSource.snapshot().itemIdentifiers(inSection: Section.main).last
                    let lastItemNumber = lastItem == nil ? nil : (lastItem?.number ?? 0) + 1
                    let start = lastItemNumber ?? itemsCount
                    let end = start + pageCount
                    loadData(direction: .forward(start: start, end: end))
                }
            }
            previousPresnetedCellIndex = indexPath.row
        }
    }
}

// MARK: - Actions
extension ChatViewController {

    @objc
    private func scrollToItem() {
        
        let lastIndex = itemsCount
        let pinnedItem = items.first { $0.number == pinnedItemPosition }
        if gapFrame == nil {
            gapFrame = (start: lastIndex, end: pinnedItemPosition - pageCount)
        }
        if let pinnedItem, let pinnedItemIndex = dataSource.snapshot().indexOfItem(pinnedItem) {
            scrollWithAnimation(to: pinnedItemIndex)
        } else {
            loadData(direction: .forward(start: pinnedItemPosition - pageCount, end: pinnedItemPosition + pageCount)) {
                
                self.scrollWithAnimation(to: lastIndex + self.pageCount)
            }
        }
    }
    
    private func scrollWithAnimation(to index: Int) {
        let indexPath = IndexPath(item: index, section: Section.main.rawValue)
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally, .centeredVertically], animated: true)
    }
}

// MARK: - Requesting Randomly Generated Data from Repository
extension ChatViewController {
    
    private func loadData(direction: DataFetchingDirection, completion: (() -> Void)? = nil) {
        guard let chatRepository else { return }
        
        if !isLoading {
            isLoading = true
            DispatchQueue.global().async { [weak self] in
                
                guard let self else { return }
                
                var snapshot: Snapshot? = nil
                switch direction {
                case .backward(let start, let end, let beforeItem):
                    if start > 0 {
                        if let beforeIndex = self.dataSource.snapshot().indexOfItem(beforeItem) {
                            let newItems = chatRepository.getChatItems(range: start...end)
                            self.items.insert(contentsOf: newItems, at: beforeIndex)
                            snapshot = self.dataSource.snapshot()
                            snapshot?.insertItems(newItems, beforeItem: beforeItem)
                        }
                    }
                case .forward(let start, let end):
                    let newItems = chatRepository.getChatItems(range: start...end)
                    self.items.append(contentsOf: newItems)
                    snapshot = Snapshot()
                    snapshot?.appendSections([Section.main])
                    snapshot?.appendItems(self.items, toSection: Section.main)
                }
                
                DispatchQueue.main.async {
                    if let snapshot {
                        self.dataSource.apply(snapshot, animatingDifferences: true)
                    }
                    self.isLoading = false
                    completion?()
                }
            }
        }
    }
}
