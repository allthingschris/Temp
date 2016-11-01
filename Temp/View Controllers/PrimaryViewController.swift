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
    @IBOutlet weak var primaryMessageView: UIView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    
    var gradient = CAGradientLayer()
    var forecasts: [NSDictionary]! = []
    var todaysForecast: [NSDictionary]! = []
    var latitude: Double!
    var longitude: Double!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupGradient()
        
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
        appDelegate.locationManager.delegate = self
        
        tempFeelingLabel.lineHeightMultiple = 0.6
        tempFeelingLabel.text = tempFeelingLabel.text
        
        delay(2){ () -> () in
            
            self.getWeather()
            
            self.tempCompare()
            
        }
        
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        print("Latitude is", location.coordinate.latitude, "and longitude is", location.coordinate.longitude)
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let city = placeMark.locality, let state = placeMark.administrativeArea {
                self.selectedLocation.text = "\(city), \(state)"
                print("You are located in", city, state)
            }
            
        })
        
        // If location was updated within the last minute
        let timeInterval = Date().timeIntervalSince(location.timestamp)
        if timeInterval < 60 {
            appDelegate.locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("We were unable to get your location.")
        
    }
    
    
    func getWeather() {
        
        let apiKey = "c8ce828d290027eefc03bf39287d8589"
        let coordinates = "\(latitude!),\(longitude!)"
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.forecasts = responseDictionary.value(forKeyPath: "response.forecasts") as? [NSDictionary]
                    
                    self.todaysForecast = responseDictionary["currently"] as! [NSDictionary]
                    
                }
            }
        });
        task.resume()
        
    }
    
    
    func tempCompare() {
        
//      return todaysForecast.count
        
//      let today = todaysForecast[indexPath.row]
        
        let yesterdayTemp = 90
        let todayTemp = todaysForecast["apparentTemperature"] as! Int
//      let todayTemp = 90
        let temperatureDifference = todayTemp - yesterdayTemp
        let temperatureDelta = abs(temperatureDifference)
        
        
        currentTemperatureLabel.text = "\(todayTemp)"
        
        
        
        
        if temperatureDifference < -1 && temperatureDelta >= 10 {
            
            print("Blue")
            tempFeelingLabel.textColor = appDelegate.blueColor
            currentTemperatureLabel.textColor = appDelegate.blueColor
            tempFeelingLabel.text = "a lot colder"
            
        } else if temperatureDifference < -1 && temperatureDelta < 10 {
            
            print("Light Blue")
            tempFeelingLabel.textColor = appDelegate.cyanColor
            currentTemperatureLabel.textColor = appDelegate.cyanColor
            tempFeelingLabel.text = "a little cooler"
            
        } else if temperatureDifference > 1 && temperatureDelta < 10 {
            
            print("Orange")
            tempFeelingLabel.textColor = appDelegate.orangeColor
            currentTemperatureLabel.textColor = appDelegate.orangeColor
            tempFeelingLabel.text = "a little warmer"
            
        } else if temperatureDifference > 1 && temperatureDelta >= 10 {
            
            print("Red")
            tempFeelingLabel.textColor = appDelegate.redColor
            currentTemperatureLabel.textColor = appDelegate.redColor
            tempFeelingLabel.text = "a lot hotter"
            
        } else {
            
            print("Green")
            tempFeelingLabel.textColor = appDelegate.greenColor
            currentTemperatureLabel.textColor = appDelegate.greenColor
            tempFeelingLabel.text = "no different"
            
        }
        
    }
    
    func setupGradient()
    {
        let gradientDark = appDelegate.charcoalGradient
        let gradientLight = appDelegate.whiteGradient
        
        let color1 = gradientDark.cgColor as CGColor
        let color2 = gradientLight.cgColor as CGColor
        let color3 = gradientLight.cgColor as CGColor
        let color4 = gradientDark.cgColor as CGColor
        
        gradient.colors = [color1, color2, color3, color4]
        self.view.layer.insertSublayer(gradient, at: 0)
    }

    override func viewDidLayoutSubviews() {
        updateGradient()
    }

    func updateGradient()
    {
        gradient.frame = view.bounds
        gradient.locations = gradientLocations() as [NSNumber]?
    }
    
    func gradientLocations() -> [CGFloat]
    {
        // Determine screen size and height
        let screenSize: CGRect = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        // Get the origin of the label
        let labelOrigin = CGPoint(x: primaryMessageView.bounds.origin.x,y: primaryMessageView.bounds.origin.y);
        // Convert the label origin to its origin in the superview coordinate system
        let topInScreen = primaryMessageView.convert(labelOrigin, to: view)
        // Set the gradient stop position above the label based on the y position in superview
        let topGradientStop = topInScreen.y
        // Compute the gradient stop number between 0 and 1 as ratio of screen height
        let topStopLocation = topGradientStop/screenHeight
        
        // Determine position for gradient to start below label by adding label height
        let bottomGradientStart = topGradientStop + primaryMessageView.bounds.size.height
        // Compute the gradient start number between 0 and 1 as ratio of screen height
        let bottomStartLocation = bottomGradientStart/screenHeight
        
        return [0.0, topStopLocation, bottomStartLocation, 1.0]

    }
    
}
