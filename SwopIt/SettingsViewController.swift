//
//  SettingsViewController.swift
//  SwopIt
//
//  Created by Muhammad Sadiq Alvi on 3/13/17.
//  Copyright © 2017 Muhammad Sadiq Alvi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var distanceValueSlider: UISlider!
    @IBOutlet weak var currValueLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.distanceValueSlider.value = Float(Utils.getCurrentDistancePreference()!)!
        self.currValueLbl.text =  String(Int(self.distanceValueSlider.value)) + "k"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func onSliderValueChanged(_ sender: Any) {
        Utils.setCurrentDistancePreference(val: self.distanceValueSlider.value)
        self.currValueLbl.text =  String(Int(self.distanceValueSlider.value)) + "k"
    }
}
