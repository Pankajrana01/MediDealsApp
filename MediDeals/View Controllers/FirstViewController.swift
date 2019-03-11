//
//  FirstViewController.swift
//  MediDeals
//
//  Created by SIERRA on 2/16/19.
//  Copyright © 2019 SIERRA. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
class FirstViewController: UIViewController,UIScrollViewDelegate , UIPageViewControllerDelegate {
    @IBOutlet var pageController: UIPageControl!
    @IBOutlet var sliderCollectionView: UICollectionView!
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet weak var letsStartedBtn: DesignableButton!
    var imgArr = [UIImage]()
    var offSet: CGFloat = 0
    var timer = Timer()
    var headingArr = [String]()
    var descriptionArr = [String]()
   override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.HideLeftSideMenu()
        Utilities.HideRightSideMenu()
        self.navigationController?.isNavigationBarHidden = true
        self.letsStartedBtn.isHidden = true
        self.headingArr = ["SIGNUP AND ACTIVATE","LIST PRODUCTS","SELL ACROSS INDIA","INSTANT PAYMENTS"]
        self.descriptionArr = ["Fill all the details, get verified & activated in few minutes","Uploading your products is really simple through our self-serve tool.","Maximise online sales, attract buyers & achieve higher conversions.","Our payments processed instantly after goods delivered!"]
        self.imgArr = [UIImage(named: "clipboard (1)"),UIImage(named: "list (1)"),UIImage(named: "seller-1"),UIImage(named: "hand (1)")] as! [UIImage]
   
        self.offSet = 0
        pageController.numberOfPages = self.headingArr.count
    
    UserDefaults.standard.set("51", forKey: "USER_ID")
    //UserDefaults.standard.set(user_accessToken, forKey: "TOKEN")
    UserDefaults.standard.synchronize()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(slider), userInfo: nil, repeats: true)
    }
    @IBAction func skipBtn(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: "USER_ID") == nil
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
            vc.checkSagueActon = "yes"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
            vc.checkSagueActon = "yes"
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    @IBAction func letsStartBTn(_ sender: DesignableButton) {
        if UserDefaults.standard.value(forKey: "USER_ID") == nil
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
            vc.checkSagueActon = "yes"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home_ViewController") as! Home_ViewController
             vc.checkSagueActon = "yes"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func slider(){
        let cells = sliderCollectionView.visibleCells
        for cell in  cells {
            if let index = sliderCollectionView.indexPath(for: cell){
                if index.row == headingArr.count - 1{
                   // self.nextbutton()
                    self.letsStartedBtn.isHidden = false
                }else{
                    sliderCollectionView.scrollToItem(at: IndexPath(item: index.row + 1, section: 0), at: .centeredHorizontally, animated: true)
                    pageController.currentPage = index.row + 1
                    index.row + 1 == 4 ? self.nextbutton() : self.skipButton()
                }
            }
        }
    }
    //MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: sliderCollectionView.contentOffset, size: sliderCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let index = sliderCollectionView.indexPathForItem(at: visiblePoint)
        {
            print(index.row)
            self.pageController.currentPage = Int(index.row)
            
        }
    }
    func nextbutton(){
       navigationItem.rightBarButtonItem?.tintColor = UIColor.blue
    }
    
    func skipButton(){
        navigationItem.rightBarButtonItem?.tintColor = UIColor.lightGray
    }
    @IBAction func nextBtn(_ sender: UIButton){
        let cells = sliderCollectionView.visibleCells
        for cell in  cells {
            if let index = sliderCollectionView.indexPath(for: cell){
                if index.row == headingArr.count - 1{
                    //                    collectionViewLive.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                    //                    pageController.currentPage = 0
                    self.nextbutton()
                    
                }else{
                    sliderCollectionView.scrollToItem(at: IndexPath(item: index.row + 1, section: 0), at: .centeredHorizontally, animated: true)
                    pageController.currentPage = index.row + 1
                    
                    index.row + 1 == 4 ? self.nextbutton() : self.skipButton()
                    
                }
            }
        }
    }
    
   

}
@available(iOS 11.0, *)
extension FirstViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return headingArr.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! firstViewCell
        cell.lblDescription.text = descriptionArr[indexPath.row]
        cell.lblHeading.text = headingArr[indexPath.row]
        cell.imageView.image = imgArr[indexPath.row]
        return cell
    }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
}
class firstViewCell : UICollectionViewCell{
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblHeading: UILabel!
    @IBOutlet var shadowView: DesignableView!
    @IBOutlet var imageView: UIImageView!
    
}
