//
//  MangaChapterHolderVC.swift
//  Manga App
//
//  Created by Tran Viet on 10/31/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import UIKit
import Kingfisher

class MangaChapterHolderVC: BaseViewController {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var data:ShortChapterDetail!
    var pageView:ChapterPageViewController!
    
    static var identifier: String = "MangaChapterHolderVC"
    
    class func newVC(data:ShortChapterDetail) -> MangaChapterHolderVC {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: MangaChapterHolderVC.identifier) as! MangaChapterHolderVC
        vc.data = data
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.pageView = ChapterPageViewController.newVC(data: data)
        self.containerView.addSubview(pageView.view)
        self.pageView.customDelegate = self
        
        pageView.view.frame = self.containerView.bounds
        pageView.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pageView.didMove(toParentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        ImageCache.default.clearMemoryCache()
    }
    
}

extension MangaChapterHolderVC : ChapterPageViewControllerDelegate {
    func updateTitle(pageView: ChapterPageViewController, title: String) {
        self.title = title
    }
    
    func finishLoadingChapterPage(pageView: ChapterPageViewController, current: Int, total: Int) {
        self.progressView.progress = Float(current+1)/Float(total)
        
//        if (current+1) >= total {
//            self.progressView.progress = 0
//        }
    }
}
