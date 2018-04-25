//
//  ChapterPageViewController.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/27/16.
//  Copyright © 2016 IDE Academy. All rights reserved.



import UIKit
import Alamofire
import Kingfisher

protocol ChapterPageViewControllerDelegate:class {
    func updateTitle(pageView:ChapterPageViewController, title:String)
    func finishLoadingChapterPage(pageView:ChapterPageViewController, current:Int, total: Int)
}

class ChapterPageViewController: UIPageViewController {
    
    
    static let identifier = "chapterPageVC"
    weak var customDelegate:ChapterPageViewControllerDelegate?
    
    var shortChapter:ShortChapterDetail!
    
    var chapterImgList:[ChapterImage] = [ChapterImage]()
    var isFirstLoad = true
    
    var backgroundBarImg:UIImage?
    var shadowBarImg:UIImage?
    var barBackgroundColor: UIColor?
    
    var imgPrefetcher:ImagePrefetcher?
    
    class func newVC(data:ShortChapterDetail) -> ChapterPageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: ChapterPageViewController.identifier) as! ChapterPageViewController
        vc.shortChapter = data
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let shortChapter = self.shortChapter else { return }
        
        if isFirstLoad {
            self.startLoading()
            Alamofire.request("\(apiHost)chapter/\(shortChapter.chapterId)")
                .responseJSON { (response) in
                    if let dataJSON = response.result.value as? JSONData {
                        if let images = dataJSON["images"] as? [[Any]], images.count > 0 {
                            
                            for item in images {
                                if let chapterImage = ChapterImage(arr: item) {
                                    self.chapterImgList.append(chapterImage)
                                }
                            }
                            
                            if self.chapterImgList.count > 0 {
                                self.preloadImgs(from: 0, limit: 3)
                            }
                            
                            self.updateTitle(currentIndex: 1)
                            
                            if self.chapterImgList.count == 0 {
                                self.stopLoading()
                                return
                            }
                            self.chapterImgList = self.chapterImgList.reversed()
                            self.dataSource = self
                            self.delegate   = self
                            self.setFirstPage()
                        }
                    }
                    self.stopLoading()
            }
            isFirstLoad = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        backgroundBarImg = self.navigationController?.navigationBar.backgroundImage(for: .default)
        shadowBarImg = self.navigationController?.navigationBar.shadowImage
        barBackgroundColor = self.navigationController?.navigationBar.backgroundColor
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.init(white: 0.3, alpha: 0.4)
        
    }
    
    func updateTitle(currentIndex: Int) {
        
        customDelegate?.updateTitle(pageView: self, title: "\(currentIndex)/\(chapterImgList.count)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(backgroundBarImg, for: .default)
        self.navigationController?.navigationBar.shadowImage = shadowBarImg
        self.navigationController?.navigationBar.backgroundColor = barBackgroundColor
    }
    
    func setFirstPage() {
        let beforeVC = self.storyboard?.instantiateViewController(withIdentifier: ChapterViewController.identifier) as! ChapterViewController
        beforeVC.index = 0
        
        let chapterImg = chapterImgList[beforeVC.index]
        beforeVC.chapterImage = chapterImg
        self.setViewControllers([beforeVC], direction: .forward, animated: false, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func createNewChapterView(currentVC: UIViewController, isNextPage: Bool) -> UIViewController? {
        let currentVC = currentVC as! ChapterViewController
        let index = currentVC.index
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: ChapterViewController.identifier) as! ChapterViewController
        
        if isNextPage {
            if index == self.chapterImgList.count - 1 {return nil}
            newVC.index = index + 1
        } else {
            if index == 0 {return nil}
            newVC.index = index - 1
        }
        
        let chapterImg = chapterImgList[newVC.index]
        newVC.chapterImage = chapterImg
        
        return newVC
    }
    
    
    // Preload images for UI
    func preloadImgs(from index:Int, limit:Int) {
        
        //print(index, limit)
        
        if index >= chapterImgList.count {
            return
        }
        
        // Nếu start index + to index > số phần tử của mảng thì lấy cái cuối index cuối làm to index
        let toIndex = (index+limit) >= chapterImgList.count ? chapterImgList.count-1 : index+limit
        let subUrls = chapterImgList[index...toIndex]
        
        // Chuyển hóa mỗi phần tử trong subUrls thành ImageResource
        let imgURLs = subUrls.map({ (item) -> ImageResource in
            
            //print(item.imgLink)
            return ImageResource(downloadURL: URL(string: item.imgLink) ?? URL(string: "")!) 
        })
        
        self.imgPrefetcher = nil
        
        
        self.imgPrefetcher = ImagePrefetcher(resources: imgURLs, options: nil, progressBlock: { (skipedURLs, failedURLs, completedURLs)  in
            //
        }, completionHandler: { [weak self] (skipedURLs, failedURLs, completedURLs) in
            
            guard let `self` = self else { return }
            
            // Đệ quy gọi lại tăng from index
            self.customDelegate?.finishLoadingChapterPage(pageView: self, current: toIndex, total: self.chapterImgList.count)
            self.preloadImgs(from: toIndex+1, limit: limit)
        })
        self.imgPrefetcher?.start()
    }
}

extension ChapterPageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return createNewChapterView(currentVC: viewController, isNextPage: false)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return createNewChapterView(currentVC: viewController, isNextPage: true)
    }
}

extension ChapterPageViewController : UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            guard let currentVC = pageViewController.viewControllers?.first as? ChapterViewController else {
                return
            }
            
            self.updateTitle(currentIndex: currentVC.index + 1)
        }
    }
}

