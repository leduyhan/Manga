//
//  MangaCollectionViewCell.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/25/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import UIKit
import Kingfisher

class MangaCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "mangaCell"
    
    @IBOutlet weak var mangaImageView: UIImageView!
    @IBOutlet weak var mangaTitle: UILabel!
    
    func setUpCell(manga: Manga) {
        mangaTitle.text = manga.title
        mangaImageView.kf.indicatorType = .activity
        mangaImageView.kf.indicator?.startAnimatingView()
        
        if let imgUrl = URL(string: manga.imgLink)
        {
            
            mangaImageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholder_mg"), options: [.transition(.fade(0.25))], completionHandler: { [weak self] (img, error, cacheType, url) in
                guard let `self` = self else {return}
                //guard let img = img else {return}
                self.mangaImageView.kf.indicator?.stopAnimatingView()
            })
        }

    }
    
}
