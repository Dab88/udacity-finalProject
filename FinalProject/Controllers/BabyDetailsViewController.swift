//
//  BabyDetailsViewController.swift
//  FinalProject
//
//  Created by Daniela Velasquez on 3/9/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class BabyDetailsViewController: UIViewController {
    
    //User information UI
    
    @IBOutlet weak var babyNameTxtField: UITextField!
    @IBOutlet weak var mommyNameTxtField: UITextField!
    @IBOutlet weak var daddyNameTxtField: UITextField!
    @IBOutlet weak var genderSwitch: UISwitch!
    
    @IBOutlet weak var bornDateLbl: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateToolbar: UIToolbar!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Add gesture from hide keyboard when the user touch the screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BabyDetailsViewController.hideKeyboard)))
        
        if let baby = PersistenceManager.instance.baby{
            
            babyNameTxtField.text = baby.name
            mommyNameTxtField.text = baby.momName
            daddyNameTxtField.text = baby.dadName
            
            genderSwitch.on = (baby.gender ==  GENDER.boy)
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        (self.tabBarController as! HomeTabBarViewController).setNavTitle(2)
        
        bornDateLbl.text = "- Tap here and select a day -"
        
        datePicker.setDate(NSDate().dateFromString(bornDateLbl.text!, format: NSDateFormatter.dateFormatFromTemplate("ddMMyyyy", options: 0, locale: NSLocale.currentLocale())!), animated: false)
    
        if let baby = PersistenceManager.instance.baby{
            
            babyNameTxtField.text = baby.name
            mommyNameTxtField.text = baby.momName
            daddyNameTxtField.text = baby.dadName
            
            genderSwitch.on = (baby.gender ==  GENDER.boy)
            
            bornDateLbl.text = baby.bornDate == "" ? "- Tap here and select a day -" : baby.bornDate
            
            print(baby.bornDate)
            
            if(bornDateLbl.text != "- Tap here and select a day -"){
                datePicker.setDate(NSDate().dateFromString(bornDateLbl.text!, format: NSDateFormatter.dateFormatFromTemplate("ddMMyyyy", options: 0, locale: NSLocale.currentLocale())!), animated: false)
            }
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Keyboard management Methods
    func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    //MARK: IBAction Methods
    
    @IBAction func changeBabyGender(sender: UISwitch) {
        
        if(sender.on){
            PersistenceManager.instance.baby!.gender = GENDER.boy
        }else{
            PersistenceManager.instance.baby!.gender = GENDER.girl
        }
        
        PersistenceManager.instance.saveBaby()
        
    }
    
    @IBAction func changeBornDate(sender: AnyObject) {
        showDatePicker(true)
    }
    
    @IBAction func bornDateSelected(sender: AnyObject) {
        showDatePicker(false)
        
        PersistenceManager.instance.baby!.bornDate = bornDateLbl.text!
        PersistenceManager.instance.saveBaby()
    }
    
    @IBAction func bornDateChanged(sender: UIDatePicker) {
        
        bornDateLbl.text = sender.date.stringFromDateInGeneralFormat()
        
    }
    
    //MARK: - Functions
    /**
     * @author: Daniela Velasquez
     * Show dateBorn datePicker view.
     */
    func showDatePicker(show: Bool){
        
        if(show){
            hideKeyboard()
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
            self.dateView.alpha = CGFloat(show)
            }, completion: nil)
        
    }
    
}

extension BabyDetailsViewController: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{
        
        if(textField == babyNameTxtField){
            PersistenceManager.instance.baby!.name = textField.text!
        }else if(textField == mommyNameTxtField){
            PersistenceManager.instance.baby!.momName = textField.text!
        }else if(textField == daddyNameTxtField){
            PersistenceManager.instance.baby!.dadName = textField.text!
        }
        
        PersistenceManager.instance.saveBaby()
        
        return true
    }
}
