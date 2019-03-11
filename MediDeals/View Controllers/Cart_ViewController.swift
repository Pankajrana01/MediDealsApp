//
//  Cart_ViewController.swift
//  MediDeals
//
//  Created by SIERRA on 1/2/19.
//  Copyright © 2019 SIERRA. All rights reserved.
//

import UIKit
@available(iOS 11.0, *)
class Cart_ViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var emptyCartImage: UIImageView!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet weak var SubTotal: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cartTableView: UITableView!
    var cell = Cart_TableViewCell()
    var getCartData = [getCartListing]()
    var quantityArray = [String]()
    var countValue = Int()
    var minQuantitiy = [String]()
    var newminQuantitiy = [String]()
    var productIdsArray = [String]()
    var grandToTal = Float()
    var playTime = Timer()
    var strLabel = UILabel()
    var checkAction = ""
    //let id = self.getCartData[sender.tag].product_id
   let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.isHidden =  true
        countValue = 1
        self.getCartApi()
        emptyCartImage.isHidden = true
        Utilities.HideRightSideMenu()
      //®  self.cartTableView.reloadData(effect: .LeftAndRight)
        // Do any additional setup after loading the view.
    }
    @IBAction func deleteCartBtn(_ sender: UIButton){
        let id = self.getCartData[sender.tag].product_id
        self.deletCartApi(prodID: id)
    }
    
    @IBAction func backBtn(_ sender: UIBarButtonItem){
        if getCartData.count != 0{
        let ids = self.productIdsArray.joined(separator: ",")
        let finalQuantity = self.newminQuantitiy.joined(separator: ",")
        checkAction = "back"
        self.editCartApi(prodID: ids ,quantity: finalQuantity)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func checkoutBtn(_ sender: UIButton) {
      
        let ids = self.productIdsArray.joined(separator: ",")
        let finalQuantity = self.newminQuantitiy.joined(separator: ",")
        self.editCartApi(prodID: ids ,quantity: finalQuantity)
    }
    @IBAction func btnPlus(_ sender: UIButton){
        countValue = Int(self.newminQuantitiy[sender.tag])!
        countValue = (countValue + 1)
        print (countValue)
        self.newminQuantitiy[sender.tag] = "\(countValue)"
        let singlePrice:Float = Float(self.getCartData[sender.tag].price)!
        self.grandToTal = grandToTal + singlePrice
        print(self.grandToTal)
        self.totalPrice.text = "Total: Rs."
            +  "\(self.grandToTal)"
        self.SubTotal.text = "SubTotal: Rs."
            + "\(self.grandToTal)"
        cartTableView.reloadData()
     
               
    }
    @objc func runtiming(){
        playTime.invalidate()
    }
 
    @IBAction func btnMinus(_ sender: UIButton){
        countValue = Int(self.newminQuantitiy[sender.tag])!
        if countValue > Int(minQuantitiy[sender.tag])!
        {
            countValue -= 1
            cell.lblValue.text = "\(countValue)"
            self.newminQuantitiy[sender.tag] = "\(countValue)"
            print(countValue)
            let singlePrice:Float = Float(self.getCartData[sender.tag].price)!
            self.grandToTal = grandToTal - singlePrice
            print(self.grandToTal)
            self.totalPrice.text = "Total: Rs."
                +  "\(self.grandToTal)"
            self.SubTotal.text = "SubTotal: Rs."
                + "\(self.grandToTal)"
        }

        cartTableView.reloadData()
        //let id = self.getCartData[sender.tag].product_id
        //self.editCartApi(prodID: id, quantity: "\(countValue)")
 }
    func textFieldDidBeginEditing(_ textField: UITextField) {
      print(textField.tag)
      
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let productMinQ:Int = Int(self.newminQuantitiy[textField.tag])!
        if textField.text != ""  {
            if Int(textField.text!)! < productMinQ {
                Utilities.ShowAlertView2(title: "Alert", message: "Order quantity must me greater than minimum order quantity ", viewController: self)
            }else{
                print(textField.tag)
                let value = textField.text
                self.newminQuantitiy[textField.tag] = "\(value ?? "")"
                let singlePrice:Float = Float(self.getCartData[textField.tag].price)!
                let productQuantity:Float = Float(self.newminQuantitiy[textField.tag])!
                self.grandToTal = 0.0
                let newTotal:Float = singlePrice * productQuantity
                self.grandToTal = grandToTal + newTotal
                print(self.grandToTal)
                self.totalPrice.text = "Total: Rs."
                    +  "\(self.grandToTal)"
                self.SubTotal.text = "SubTotal: Rs."
                    + "\(self.grandToTal)"
            }
        }else if textField.text == ""{
            Utilities.ShowAlertView2(title: "Alert", message: "Please add some quantity", viewController: self)
        }
       
    }
    //MARK: GetProduct Cart API
    func getCartApi(){
        self.addLoadingIndicator()
        self.startAnim()
        let params = ["user_id": UserDefaults.standard.value(forKey: "USER_ID") as! String,
                      ]
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.get_cart.caseValue,parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.stopAnim()
                self.getCartData = [getCartListing]()
                self.emptyCartImage.isHidden = false
                self.cartTableView.isHidden = true
                self.cartTableView.reloadData()
            } else {
                   self.stopAnim()
                self.emptyCartImage.isHidden = true
                if let data = (dic.value(forKey: "record") as? NSArray)?.mutableCopy() as? NSMutableArray
                {
                    self.minQuantitiy = [String]()
                    self.newminQuantitiy = [String]()
                    self.getCartData = [getCartListing]()
                    
                    for index in 0..<data.count
                    {
                        self.getCartData.append(getCartListing(product_id: "\((data[index] as AnyObject).value(forKey: "product_id") ?? "")", title: "\((data[index] as AnyObject).value(forKey: "title") ?? "")", price: "\((data[index] as AnyObject).value(forKey: "price") ?? "")", quantity: "\((data[index] as AnyObject).value(forKey: "min_quantity") ?? "")", total: "\((data[index] as AnyObject).value(forKey: "total") ?? "")"))
                        
                        self.minQuantitiy.append("\((data[index] as AnyObject).value(forKey: "min_quantity") ?? "")")
                        self.newminQuantitiy.append("\((data[index] as AnyObject).value(forKey: "quantity") ?? "")")
                        self.productIdsArray.append("\((data[index] as AnyObject).value(forKey: "product_id") ?? "")")
                    }
//                    for
                   
                    self.totalPrice.text = "Total: Rs."
                        + "\(dic.value(forKey: "total") as! String)"
                    self.grandToTal = Float(dic.value(forKey: "total") as! String)!
                    self.SubTotal.text = "SubTotal: Rs."
                        + "\(dic.value(forKey: "subtotal") as! String)"
                    self.stopAnim()
                    self.cartTableView.reloadData()
                 }
            }
        }
    }
    func editCartApi(prodID:String,quantity:String){
        self.addLoadingIndicator()
        self.startAnim()
        let params = ["user_id": UserDefaults.standard.value(forKey: "USER_ID") as! String, "product_id": prodID,"quantity": quantity]
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.edit_cart.caseValue,parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.stopAnim()
                Utilities.ShowAlertView2(title: "Alert", message: dic.value(forKey: "message") as! String, viewController: self)
            } else {
                self.stopAnim()
                if self.checkAction == "back"{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.sague()}
            }
        }
    }
    
    func sague(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutViewController") as! CheckOutViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func deletCartApi(prodID:String){
        self.addLoadingIndicator()
        self.startAnim()
        let params = ["user_id": UserDefaults.standard.value(forKey: "USER_ID") as! String, "product_id": prodID]
        NetworkingService.shared.getData(PostName: APIEndPoint.userCase.delete_cart.caseValue,parameters: params) { (response) in
            print(response)
            let dic = response as! NSDictionary
            print(dic)
            if (dic.value(forKey: "status") as? String == "0")
            {
                self.stopAnim()
                Utilities.ShowAlertView2(title: "Alert", message: dic.value(forKey: "message") as! String, viewController: self)
            } else {
                self.stopAnim()
               self.getCartApi()
            }
        }
    }

 }
@available(iOS 11.0, *)
extension Cart_ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.getCartData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = cartTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cart_TableViewCell
        cell.lblValue.tag = indexPath.row
//        cell.lblValue.delegate = self
        cell.btnPlus.tag = indexPath.row
        cell.minusBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.lblValue.text =  newminQuantitiy[indexPath.row]
        cell.productName.text =  self.getCartData[indexPath.row].title
        cell.price.text =  "Rs: " + self.getCartData[indexPath.row].price
        cell.quantity.text = "Minimum Order Quantity: " + self.getCartData[indexPath.row].quantity
        return cell
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.delete
//    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("Deleted")
//            let id = self.getCartData[indexPath.row].product_id
//            self.deletCartApi(prodID: id)
//            //self.catNames.remove(at: indexPath.row)
//            //self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
//            //            self.cartTableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
    
}
