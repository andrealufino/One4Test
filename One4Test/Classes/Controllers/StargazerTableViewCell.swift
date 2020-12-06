//
//  StargazerTableViewCell.swift
//  One4Test
//
//  Created by Andrea Mario Lufino on 06/12/20.
//

import Foundation
import UIKit


// MARK: - Instance vars and IBOutlets

class StargazerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var lblLoginName: UILabel!
}


// MARK: - Awake from nib

extension StargazerTableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
