//
//  BaseViewController.swift
//  Manga App
//
//  Created by Hoàng Cửu Long on 10/28/16.
//  Copyright © 2016 IDE Academy. All rights reserved.



import UIKit

class BaseViewController: UIViewController {

    var isFirstLoad = true
    
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
        if isFirstLoad {
            dataForPage()
            isFirstLoad = false
        }
    }
    
    func dataForPage() {}
    func dataForNextPage() {}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
