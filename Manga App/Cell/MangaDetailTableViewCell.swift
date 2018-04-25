//
//  MangaDetailTableViewCell.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/26/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import UIKit

class MangaDetailTableViewCell: UITableViewCell {

    static let reuseIdentifier = "chapterCell"
    
    @IBOutlet weak var chapterTitleLabel : UILabel!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    
    func setUpCell(shortChapterDetail: ShortChapterDetail) {
        chapterTitleLabel.text = shortChapterDetail.chapterName
        createdDateLabel.text = "\(formatDateToString(date: shortChapterDetail.updatedDate))"
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
