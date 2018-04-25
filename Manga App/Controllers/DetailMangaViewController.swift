//  DetailMangaViewController.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/26/16.
//  Copyright © 2016 IDE Academy. All rights reserved.


import UIKit
import Alamofire
import Kingfisher

class DetailMangaViewController: BaseViewController {

    static let identifier = "detailMangaVC"
    
    @IBOutlet weak var mangaImageView: UIImageView!
    
    @IBOutlet weak var mangaAuthorLabel: UILabel!
    
    @IBOutlet weak var mangaCreatedDateLabel: UILabel!
    
    @IBOutlet weak var mangaChaptersLabel: UILabel!
    
    
    @IBOutlet weak var mangaCategoriesLabel: UILabel!
    
    @IBOutlet weak var changeSourceViewSegment: UISegmentedControl!
    
    @IBOutlet weak var mangaDescriptionView: UIView!
    
    @IBOutlet weak var mangaDescriptionContentTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var id: String!
    var mangaDetail:MangaDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeSourceViewSegment.selectedSegmentIndex = 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.layer.zPosition = 1
    }
    
    override func dataForPage() {
        guard let id = self.id else {return}
        self.startLoading()
        
//        mangaImageView.image = #imageLiteral(resourceName: "placeholder_mg")
        
        Alamofire.request("\(apiHost)manga/\(id)/")
            .responseJSON { (response) in
                if let data = response.result.value as? JSONData {
                    if let mangaDetail = MangaDetail(data: data) {
                        self.title = mangaDetail.title
                        self.mangaDetail = mangaDetail
                        self.setUpScreen()
                        self.tableView.reloadData()
                        self.stopLoading()
                    }
                }
        }
    }
    
    @IBAction func changeSourceViewActionSegment(_ sender: AnyObject) {
        
        if changeSourceViewSegment.selectedSegmentIndex == 0 {
            tableView.layer.zPosition = 0
            mangaDescriptionView.layer.zPosition = 1
        } else {
            tableView.layer.zPosition = 1
            mangaDescriptionView.layer.zPosition = 0
        }
        
    }
    
    func setUpScreen() {
        guard let mangaDetail = self.mangaDetail else { return }
        
        mangaAuthorLabel.text = mangaDetail.author
        mangaCreatedDateLabel.text = formatDateToString(date: mangaDetail.createdDate)
        mangaChaptersLabel.text = "\(mangaDetail.shortChapterDetail.count)"
        mangaCategoriesLabel.text = mangaDetail.categories.joined(separator: ", ")
        
        mangaDescriptionContentTextView.text = mangaDetail.description
        
        mangaImageView.kf.indicatorType = .activity
        mangaImageView.kf.indicator?.startAnimatingView()
       
        guard let imgUrl = URL(string: mangaDetail.imageLink) else { return }
        
        mangaImageView.kf.setImage(with: imgUrl, placeholder: #imageLiteral(resourceName: "placeholder_mg"), options: [.transition(.fade(0.25))], progressBlock: { (process, total) in
                print(process, total)
            }, completionHandler: nil)
    }

}

extension DetailMangaViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mangaDetail != nil ? mangaDetail!.shortChapterDetail.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MangaDetailTableViewCell.reuseIdentifier, for: indexPath) as! MangaDetailTableViewCell
        guard let mangaDetail = self.mangaDetail else { return cell }
        
        if mangaDetail.shortChapterDetail.count <= 0 || mangaDetail.shortChapterDetail.count < indexPath.row {return cell}
        
        let shortDetail = mangaDetail.shortChapterDetail[indexPath.row]
        
        cell.setUpCell(shortChapterDetail: shortDetail)
        
        return cell
    }
    
    
}

extension DetailMangaViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.tableView.layer.zPosition == 0 {return}
        
        guard let mangaDetail = self.mangaDetail else {
            return
        }
        
        let shortChapter = mangaDetail.shortChapterDetail[indexPath.row]
        let vc = MangaChapterHolderVC.newVC(data: shortChapter)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
