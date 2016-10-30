//
//  PrimaryViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 10/29/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit
import CoreLocation

class PrimaryViewController: UIViewController, CLLocationManagerDelegate{
    @IBOutlet weak var tempFeelingLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
        appDelegate.locationManager.delegate = self

        tempCompare()
        
//        TTTAttributedLabel *tempFeelingLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
//        tempFeelingLabel.lineSpacing = 3
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tempCompare() {

        let yesterdayTemp = 90
        let todayTemp = 91
        let temperatureDifference = todayTemp - yesterdayTemp
        let temperatureDelta = abs(temperatureDifference)
        
        if temperatureDifference < -1 && temperatureDelta >= 10 {
        
            print("Blue")
            tempFeelingLabel.text = "a lot colder"
            tempFeelingLabel.textColor = appDelegate.blueColor
            
        } else if temperatureDifference < -1 && temperatureDelta < 10 {
            
            print("Light Blue")
            tempFeelingLabel.text = "a little cooler"
            tempFeelingLabel.textColor = appDelegate.cyanColor

        } else if temperatureDifference > 1 && temperatureDelta < 10 {
            
            print("Orange")
            tempFeelingLabel.text = "a little warmer"
            tempFeelingLabel.textColor = appDelegate.orangeColor
            
        } else if temperatureDifference > 1 && temperatureDelta >= 10 {
            
            print("Red")
            tempFeelingLabel.text = "a lot hotter"
            tempFeelingLabel.textColor = appDelegate.redColor

        } else {
            
            print("Green")
            tempFeelingLabel.text = "no different"
            tempFeelingLabel.textColor = appDelegate.greenColor
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        print(location)
        
        appDelegate.locationManager.stopUpdatingLocation()
    }
    
}
