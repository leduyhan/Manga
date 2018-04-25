//
//  ChapterViewController.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/27/16.
//  Copyright © 2016 IDE Academy. All rights reserved.
//

import UIKit
import Kingfisher

class ChapterViewController: UIViewController {

    static let identifier = "chapterVC"
    
//    @IBOutlet weak var chapterImageView: UIImageView!
    var chapterImageView: UIImageView!
    @IBOutlet weak var scrollVIew: UIScrollView!

    var chapterImage:ChapterImage!
    var index:Int = 0
    var isFirstLoad = true
    var containerHeight:CGFloat {
        return scrollVIew.bounds.size.height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollVIew.delegate = self
        
        let sizeImageScaleFollowScreenWidth = CGSize(width: screenWidth, height: getNewHeight())
        chapterImageView = createImageView(size: sizeImageScaleFollowScreenWidth)
        
        guard let imgURL = URL(string: chapterImage.imgLink) else {return}
        scrollVIew.addSubview(chapterImageView)
        //self.setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize()
        
        
        ImageCache.default.retrieveImage(forKey: chapterImage.imgLink, options: nil) { [weak self]
            image, cacheType in
            if let image = image {
                
                self?.chapterImageView.image = image
                
            } else {
                
                self?.chapterImageView.kf.indicatorType = .activity
                
                self?.chapterImageView.kf.setImage(with: imgURL, placeholder: nil, options: [.transition(.fade(0.25))], completionHandler: { (img, error, type, url) in
                    if img != nil {
                        self?.chapterImageView.kf.indicator?.stopAnimatingView()
                        self?.stopLoading()
                    }
                    
                    
                })
                
                
            }
            self?.setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize()
        }
        
        scrollVIew.minimumZoomScale = 1.0
        scrollVIew.maximumZoomScale = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isFirstLoad {
            return
        }
        isFirstLoad = false
        
        self.setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize()
    }
    
    func setScrollViewSizeMatchWithImageAfterScaleFollowScreenSize() {
        
        
        scrollVIew.contentSize = CGSize(width: screenWidth, height: getNewHeight())
        
        if getNewHeight() < containerHeight {
             //let point = CGPoint(x: 0, y: (containerHeight - getNewHeight())/2.0)
            //self.chapterImageView.frame.origin = point
            self.chapterImageView.contentMode = .scaleAspectFit
        }
        
        self.chapterImageView.frame.size = self.scrollVIew.contentSize
    }
    

    func createImageView(size: CGSize) -> UIImageView {
        let point = CGPoint.zero
        let imageView = UIImageView(frame: CGRect(origin: point, size: size))
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
    
    func getNewHeight() -> CGFloat {
        return CGFloat(chapterImage.height) * screenWidth / CGFloat(chapterImage.width)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
//        return self.imageView
//    }
}

extension ChapterViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return self.chapterImageView
    }
}
