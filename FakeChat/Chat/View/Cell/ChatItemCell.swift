//
//  ChatItemCell.swift
//  FakeChat
//
//  Created by ANDREY VORONTSOV on 17.10.2023.
//

import UIKit

final class ChatItemCell: UICollectionViewCell {
    
    static let cellID = String(describing: ChatItemCell.self)
    
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
        contentView.addSubview(textLabel)
        
        layer.borderWidth = 2
        layer.cornerRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupConstraints() {
        let labelInset = UIEdgeInsets(top: 16, left: 16, bottom: -16, right: -16)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: labelInset.top),
            textLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: labelInset.bottom),
            textLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: labelInset.left),
            textLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: labelInset.right)
        ])
    }
    
    func setData(text: String) {
        textLabel.text = text
    }
}
