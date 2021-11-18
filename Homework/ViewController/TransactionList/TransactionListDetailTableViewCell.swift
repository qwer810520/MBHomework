//
//  TransactionListDetailTableViewCell.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/6.
//

import UIKit

class TransactionListDetailTableViewCell: UITableViewCell {

    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)

        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        priceLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(8)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func updateView(_ viewOject: TransactionListCellViewObject) {
        priceLabel.text = viewOject.priceWithQuantity
        nameLabel.text = viewOject.name
    }

}
