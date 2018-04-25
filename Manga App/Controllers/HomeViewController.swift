//
//  HomeViewController.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/28/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//  ViewController.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/25/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    var refeshing = UIRefreshControl()
    
    var page = 0
    var mangaList:[Manga] = [Manga]()
    var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.addSubview(refeshing)
    }
    
    
    override func dataForPage() {
        self.mangaList.removeAll()
        self.startLoading()
        Alamofire.request("\(apiHost)list/0/?p=\(page)&l=30", method: .get)
            .responseJSON(queue: DispatchQueue.global()) { [weak self] (response) in
                guard let `self` = self else {return}
                
                if let data = response.result.value as? JSONData {
                    if let mangaListData = data["manga"] as? [JSONData], mangaListData.count > 0 {
                        for mangaData in mangaListData {
                            if let manga = Manga(data: mangaData) {
                                self.mangaList.append(manga)
                            }
                        }
                        
                        //                        self.mangaList = self.mangaList.sorted() { $0.lastedDate.timeIntervalSince1970 > $1.lastedDate.timeIntervalSince1970 }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        self.isLoading = false
                        self.stopLoading()
                    }
                } else {
                    self.stopLoading()
                    self.noticeError("Error", autoClear: true, autoClearTime: 3)
                }
        }
    }
    
    override func dataForNextPage() {
        
        page += 1
        self.startLoading()
        Alamofire.request("\(apiHost)list/0/?p=\(page)&l=30", method: .get)
            .responseJSON(queue: DispatchQueue.global()) { [weak self] (response) in
                
                guard let `self` = self else {
                    return
                }
                self.isLoading = true
                if let data = response.result.value as? JSONData {
                    if let mangaListData = data["manga"] as? [JSONData], mangaListData.count > 0 {
                        for mangaData in mangaListData {
                            if let manga = Manga(data: mangaData) {
                                self.mangaList.append(manga)
                            }
                        }
                        
                        //                        self.mangaList = self.mangaList.sorted() { $0.lastedDate.timeIntervalSince1970 > $1.lastedDate.timeIntervalSince1970 }
                        self.collectionView.reloadData()
                    }
                } else {
                    self.page -= 1
                }
                
                self.isLoading = false
                self.stopLoading()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if screenWidth > 375 {
                layout.itemSize.width = (screenWidth - 40)/3
                layout.itemSize.height = (screenHeight - 50)/4
                collectionView.delegate = self
                collectionView.dataSource = self

            }else {
                layout.itemSize.width = (screenWidth - 30) / 2
                layout.itemSize.height = (screenHeight - 40)/3
                collectionView.delegate = self
                collectionView.dataSource = self

            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
}

extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mangaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MangaCollectionViewCell.reuseIdentifier, for: indexPath) as! MangaCollectionViewCell
        if mangaList.count < indexPath.item {return cell}
        let manga = mangaList[indexPath.item]
        
        cell.setUpCell(manga: manga)
        
        return cell
    }
}

extension HomeViewController : UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if refeshing.isRefreshing {
            page = 0
            self.dataForPage()
            self.refeshing.endRefreshing()
        }
        
        if isLoading {return}
        
        
        
        
        let offsetY = scrollView.contentOffset.y
        let heightOfContent = scrollView.contentSize.height
        if heightOfContent - offsetY - scrollView.bounds.size.height <= 1 {
            self.dataForNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let manga = mangaList[indexPath.item]
        
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: DetailMangaViewController.identifier) as? DetailMangaViewController else {return}
        
        detailVC.id = manga.id
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension UIViewController {
    func startLoading() {
        self.pleaseWait()
        self.view.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.view.isUserInteractionEnabled = true
    }
}

extension UIView {
    func startLoading() {
        self.pleaseWait()
        self.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        self.clearAllNotice()
        self.isUserInteractionEnabled = true
    }
}

