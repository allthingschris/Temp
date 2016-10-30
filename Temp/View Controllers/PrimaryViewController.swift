//
//  PrimaryViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 10/29/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit
import CoreLocation
import TTTAttributedLabel
import MapKit

class PrimaryViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var tempFeelingLabel: TTTAttributedLabel!
    @IBOutlet weak var selectedLocation: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
        appDelegate.locationManager.delegate = self
        
        tempFeelingLabel.lineHeightMultiple = 0.6
        tempFeelingLabel.text = tempFeelingLabel.text
        
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
        let todayTemp = 96
        let temperatureDifference = todayTemp - yesterdayTemp
        let temperatureDelta = abs(temperatureDifference)
        
        
        if temperatureDifference < -1 && temperatureDelta >= 10 {
        
            print("Blue")
            tempFeelingLabel.textColor = appDelegate.blueColor
            tempFeelingLabel.text = "a lot colder"
            
        } else if temperatureDifference < -1 && temperatureDelta < 10 {
            
            print("Light Blue")
            tempFeelingLabel.textColor = appDelegate.cyanColor
            tempFeelingLabel.text = "a little cooler"

        } else if temperatureDifference > 1 && temperatureDelta < 10 {
            
            print("Orange")
            tempFeelingLabel.textColor = appDelegate.orangeColor
            tempFeelingLabel.text = "a little warmer"
            
        } else if temperatureDifference > 1 && temperatureDelta >= 10 {
            
            print("Red")
            tempFeelingLabel.textColor = appDelegate.redColor
            tempFeelingLabel.text = "a lot hotter"

        } else {
            
            print("Green")
            tempFeelingLabel.textColor = appDelegate.greenColor
            tempFeelingLabel.text = "no different"
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        
        print(location)

        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
         
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            let city = placeMark.addressDictionary!["City"] as? NSString
            
            print(city as Any)
            
        })
        
        appDelegate.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {

        print("We were unable to get your location.")
        
    }
    
}
