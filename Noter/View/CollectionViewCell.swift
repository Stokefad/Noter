//
//  CollectionViewCell.swift
//  Noter
//
//  Created by Igor-Macbook Pro on 17/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    
    @IBOutlet var noteText: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: Note) {
        noteText.text = "dsfdsfds"
        dateLabel.text = "fdfsfdsfds"
    }
}
