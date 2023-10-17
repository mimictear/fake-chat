//
//  ChatItemCell.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import UIKit

final class ChatItemCell: UICollectionViewCell {
    
    static let cellID = String(describing: ChatItemCell.self)
    
    private let cellBorderWidth = CGFloat(1)
    private let viewPadding = CGFloat(16)
    private let cellCornerRadius = CGFloat(16)
    private let cellShadowOffset = CGSize(width: 0, height: 5)
    private let cellShadowOpacity = Float(0.5)
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        textLabel.preferredMaxLayoutWidth = layoutAttributes.size.width - contentView.layoutMargins.left - contentView.layoutMargins.left
        layoutAttributes.bounds.size.height = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return layoutAttributes
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .systemBackground
        
        contentView.addSubview(numberLabel)
        contentView.addSubview(textLabel)
        
        layer.borderWidth = cellBorderWidth
        layer.cornerRadius = cellCornerRadius
        layer.shadowOffset = cellShadowOffset
        layer.shadowOpacity = cellShadowOpacity
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupConstraints() {
        let labelInset = UIEdgeInsets(top: viewPadding, left: viewPadding, bottom: -viewPadding, right: -viewPadding)
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: labelInset.top),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: labelInset.left),
            numberLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: labelInset.right),
            
            textLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: labelInset.top),
            textLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: labelInset.bottom),
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: labelInset.left),
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: labelInset.right)
        ])
    }
    
    func setData(_ item: ChatItem) {
        numberLabel.text = "#\(item.number)"
        textLabel.text = item.text
    }
}
