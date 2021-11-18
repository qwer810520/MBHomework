//
//  TransactionDetailTableViewCell.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit

class TransactionDetailTableViewCell: UITableViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
