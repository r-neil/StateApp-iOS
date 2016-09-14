//
//  MainVC.swift
//  State App
//
//  Created by Neil on 9/13/16.
//  Copyright © 2016 Neil. All rights reserved.
//  
// An App that pulls data from a REST API
// The user can enter either state code "ND" or full state name "North Dakota"
// to see some interesting facts about that state.

import UIKit

class MainVC: UIViewController,UITextFieldDelegate, FetchStateData{
    @IBOutlet weak var enterTextField: UITextField!
    @IBOutlet weak var showDetailsBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var stateAbbLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    @IBOutlet weak var popLabel: UILabel!
    @IBOutlet weak var popRankLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.hidden = true
        errorLabel.text = " "
        enterTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    }

    @IBAction func showDetailsAction() {
        if enterTextField.text == ""{
            errorLabel.text = "Please enter a value"
        }else{
            errorLabel.text = " "
            let noSpacesStr = enterTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "%20")
            let dataModel = APIHelper(stateValue: noSpacesStr)
            dataModel.dataDelegate = self
        }
        
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    //Delegate Methods for FetchStateData
    
    func stateDataReady(stateData: StateDataStruct) {
        scrollView.hidden = false
        
        stateLabel.text = stateData.stateName
        stateAbbLabel.text = stateData.stateAbbrev
        capitalLabel.text = stateData.capital
        popLabel.text = stateData.population
        popRankLabel.text = "\(stateData.popRank!)"
        joinedLabel.text = stateData.joinedUnion
        nicknameLabel.text = stateData.nicknames
    }
    
    func noDataReturned(){
        scrollView.hidden = true
        errorLabel.text = "No Data, please try another State"
    }
    
    //Delegate Methods for UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissKeyboard()
        showDetailsAction()
        return true
    }
}
