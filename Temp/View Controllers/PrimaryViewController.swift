//
//  PrimaryViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 10/29/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit

class PrimaryViewController: UIViewController {
    @IBOutlet weak var tempFeelingLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
                
        tempCompare()
        
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
        
        let blueColor = UIColor.init(red: 0, green: 113/255, blue: 187/255, alpha: 1)
        let cyanColor = UIColor.init(red: 37/255, green: 171/255, blue: 225/255, alpha: 1)
        let greenColor = UIColor.init(red: 51/255, green: 181/255, blue: 75/255, alpha: 1)
        let orangeColor = UIColor.init(red: 242/255, green: 91/255, blue: 38/255, alpha: 1)
        let redColor = UIColor.init(red: 194/255, green: 41/255, blue: 46/255, alpha: 1)
        
        
        if temperatureDifference < -1 && temperatureDelta >= 10 {
        
            print("Blue")
            tempFeelingLabel.text = "a lot colder"
            tempFeelingLabel.textColor = blueColor
            
        } else if temperatureDifference < -1 && temperatureDelta < 10 {
            
            print("Light Blue")
            tempFeelingLabel.text = "a little cooler"
            tempFeelingLabel.textColor = cyanColor

        } else if temperatureDifference > 1 && temperatureDelta < 10 {
            
            print("Orange")
            tempFeelingLabel.text = "a little warmer"
            tempFeelingLabel.textColor = orangeColor
            
        } else if temperatureDifference > 1 && temperatureDelta >= 10 {
            
            print("Red")
            tempFeelingLabel.text = "a lot hotter"
            tempFeelingLabel.textColor = redColor

        } else {
            
            print("Green")
            tempFeelingLabel.text = "no different"
            tempFeelingLabel.textColor = greenColor
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var location = locations[0] as CLLocation
        
        print(location)
    }
    
}
