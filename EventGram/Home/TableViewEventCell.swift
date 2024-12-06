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
    func setupimageReceipt(){
        imageReceipt = UIImageView()
        imageReceipt.image = UIImage(systemName: "photo")
        imageReceipt.contentMode = .scaleToFill
        imageReceipt.clipsToBounds = true
        imageReceipt.layer.cornerRadius = 10
        imageReceipt.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(imageReceipt)
    }
    
    //MARK: defining the UI elements...
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 10.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.borderColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.borderWidth = 0.8
        wrapperCellView.layer.shadowRadius = 6.0
        wrapperCellView.layer.shadowOpacity = 0.7
        
        
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupLabelTitle(){
        labelTitle = UILabel()
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.font = UIFont.boldSystemFont(ofSize: 16)
        wrapperCellView.addSubview(labelTitle)
    }
    func setupLabelLocation(){
        labelLocation = UILabel()
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLocation)
    }
    func setupLabelDate(){
        labelDate = UILabel()
        labelDate.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelDate)
    }

    //MARK: initializing the constraints...
    func initConstraints(){
        NSLayoutConstraint.activate([
            
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 10),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            labelTitle.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 2),
            labelTitle.leadingAnchor.constraint(equalTo: imageReceipt.trailingAnchor, constant: 8),
            labelTitle.heightAnchor.constraint(equalToConstant: 32),
            labelTitle.widthAnchor.constraint(lessThanOrEqualTo: wrapperCellView.widthAnchor),
            
            labelLocation.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 2),
            labelLocation.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelLocation.heightAnchor.constraint(equalToConstant: 32),
            labelLocation.widthAnchor.constraint(lessThanOrEqualTo: labelTitle.widthAnchor),
            
            labelDate.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 2),
            labelDate.leadingAnchor.constraint(equalTo: labelTitle.leadingAnchor),
            labelDate.heightAnchor.constraint(equalToConstant: 32),
            labelDate.widthAnchor.constraint(lessThanOrEqualTo: labelTitle.widthAnchor),
            
            imageReceipt.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            imageReceipt.centerYAnchor.constraint(equalTo: wrapperCellView.centerYAnchor),
            //MARK: it is better to set the height and width of an ImageView with constraints...
            imageReceipt.heightAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
            imageReceipt.widthAnchor.constraint(equalTo: wrapperCellView.heightAnchor, constant: -20),
            

            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 104)
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
