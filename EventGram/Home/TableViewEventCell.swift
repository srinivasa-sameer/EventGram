//
//  TableViewEventCell.swift
//  EventGram
//
//  Created by Nallapu Srikar on 12/4/24.
//

import UIKit

class TableViewEventCell: UITableViewCell {

    var wrapperCellView: UIView!
    var labelTitle: UILabel!
    var labelLocation: UILabel!
    var labelDate: UILabel!

    var imageReceipt: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupWrapperCellView()
        setupLabelTitle()
        setupLabelLocation()
        setupLabelDate()

        setupimageReceipt()

        initConstraints()
    }

    //Adding the ImageView for receipt...
    func setupimageReceipt() {
        imageReceipt = UIImageView()
        imageReceipt.image = UIImage(systemName: "photo")
        imageReceipt.contentMode = .scaleAspectFill
        imageReceipt.clipsToBounds = true
        imageReceipt.layer.cornerRadius = 8
        imageReceipt.backgroundColor = .systemGray5
        imageReceipt.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageReceipt)
    }

    //MARK: defining the UI elements...
    func setupWrapperCellView() {
        wrapperCellView = UITableViewCell()

        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 16.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = CGSize(width: 0, height: 3)
                wrapperCellView.layer.shadowRadius = 5.0
                wrapperCellView.layer.shadowOpacity = 0.2
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }

    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        labelTitle.textColor = .black
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTitle)
    }
    func setupLabelLocation() {
        labelLocation = UILabel()
        labelLocation.font = .systemFont(ofSize: 16)
        labelLocation.textColor = .darkGray
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLocation)
    }
    func setupLabelDate() {
        labelDate = UILabel()
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDate)
    }

    //MARK: initializing the constraints...
    func initConstraints() {
        NSLayoutConstraint.activate([

            wrapperCellView.topAnchor.constraint(
                equalTo: self.topAnchor, constant: 8),
            wrapperCellView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: 16),
            wrapperCellView.bottomAnchor.constraint(
                equalTo: self.bottomAnchor, constant: -8),
            wrapperCellView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -16),

            labelTitle.topAnchor.constraint(
                equalTo: wrapperCellView.topAnchor, constant: 12),
            labelTitle.leadingAnchor.constraint(
                equalTo: imageReceipt.trailingAnchor, constant: 15),
            labelTitle.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -15),

            labelDate.topAnchor.constraint(
                equalTo: labelTitle.bottomAnchor, constant: 8),
            labelDate.leadingAnchor.constraint(
                equalTo: labelTitle.leadingAnchor),
            labelDate.trailingAnchor.constraint(equalTo: labelTitle.trailingAnchor),
            
            labelLocation.topAnchor.constraint(equalTo: labelDate.bottomAnchor, constant: 8),
            labelLocation.leadingAnchor.constraint(equalTo: labelDate.leadingAnchor),
            labelLocation.trailingAnchor.constraint(equalTo: labelDate.trailingAnchor),

            imageReceipt.leadingAnchor.constraint(
                equalTo: wrapperCellView.leadingAnchor, constant: 14),
            imageReceipt.centerYAnchor.constraint(
                equalTo: wrapperCellView.centerYAnchor),
            imageReceipt.heightAnchor.constraint(equalToConstant: 80),
            imageReceipt.widthAnchor.constraint(equalToConstant: 100),

            wrapperCellView.heightAnchor.constraint(equalToConstant: 105),
        ])
    }

    //MARK: unused methods...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
