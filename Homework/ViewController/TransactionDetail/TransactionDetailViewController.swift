//
//  TransactionDetailViewController.swift
//  Homework
//
//  Created by AlexanderPan on 2021/5/7.
//

import UIKit

class TransactionDetailViewController: UIViewController {

    #warning("DOTO: Transaction Detail ")

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        return label
    }()

    private lazy var detailTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
