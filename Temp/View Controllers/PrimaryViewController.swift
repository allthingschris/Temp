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
    
    @IBOutlet weak var primaryMessageView: UIView!
    @IBOutlet weak var tempListView: UIView!
    @IBOutlet weak var selectedLocation: UILabel!
    @IBOutlet weak var itFeelsLabel: TTTAttributedLabel!
    @IBOutlet weak var tempFeelingLabel: TTTAttributedLabel!
    @IBOutlet weak var comparisonLabel: UILabel!
    @IBOutlet weak var currentDayView: UIView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayBeforeYesterdayView: UIView!
    @IBOutlet weak var dayBeforeYesterdayLabel: UILabel!
    @IBOutlet weak var dayBeforeYesterdayTempLabel: UILabel!
    @IBOutlet weak var yesterdayView: UIView!
    @IBOutlet weak var yesterdayLabel: UILabel!
    @IBOutlet weak var yesterdayTempLabel: UILabel!
    @IBOutlet weak var tomorrowView: UIView!
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var tomorrowTempLabel: UILabel!
    @IBOutlet weak var dayAfterTomorrowView: UIView!
    @IBOutlet weak var dayAfterTomorrowLabel: UILabel!
    @IBOutlet weak var dayAfterTomorrowTempLabel: UILabel!
    
    var gradient = CAGradientLayer()
    var forecasts: [NSDictionary]! = []
    var todaysForecast: NSDictionary! = NSDictionary()
    var todayDaily: NSDictionary! = NSDictionary()
    var yesterdaysForecast: NSDictionary! = NSDictionary()
    var yesterdaysDaily: NSDictionary! = NSDictionary()
    var dayBeforeYesterdaysForecast: NSDictionary! = NSDictionary()
    var dayBeforeYesterdaysDaily: NSDictionary! = NSDictionary()
    var tomorrowsForecast: NSDictionary! = NSDictionary()
    var tomorrowsDaily: NSDictionary! = NSDictionary()
    var dayAfterTomorrowsForecast: NSDictionary! = NSDictionary()
    var dayAfterTomorrowsDaily: NSDictionary! = NSDictionary()
    var latitude: Double!
    var longitude: Double!
    var comparisonTemp = Int(80)
    
    let calendar = NSCalendar.current
    let today = NSCalendar.current.date(byAdding: .day, value: 0, to: Date())
    let yesterday = NSCalendar.current.date(byAdding: .day, value: -1, to: Date())
    let dayBeforeYesterday = NSCalendar.current.date(byAdding: .day, value: -2, to: Date())
    let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())
    let dayAfterTomorrow = NSCalendar.current.date(byAdding: .day, value: 2, to: Date())
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setupGradient()
        
        appDelegate.locationManager.requestAlwaysAuthorization()
        appDelegate.locationManager.startUpdatingLocation()
        appDelegate.locationManager.delegate = self
        
        tempFeelingLabel.lineHeightMultiple = 0.8
        tempFeelingLabel.text = tempFeelingLabel.text
        
        selectedLocation.alpha = 0
        weatherIcon.alpha = 0
        primaryMessageView.alpha = 0
        tempListView.alpha = 0
        
        itFeelsLabel.verticalAlignment = .bottom
        
        let yesterdayDay = DateFormatter()
        yesterdayDay.dateFormat = "EEE"
        yesterdayLabel.text = yesterdayDay.string(from: yesterday!).uppercased()
        
        let dayBeforeYesterdayDay = DateFormatter()
        dayBeforeYesterdayDay.dateFormat = "EEE"
        dayBeforeYesterdayLabel.text = dayBeforeYesterdayDay.string(from: dayBeforeYesterday!).uppercased()
        
        
        let tomorrowDay = DateFormatter()
        tomorrowDay.dateFormat = "EEE"
        tomorrowLabel.text = tomorrowDay.string(from: tomorrow!).uppercased()
        
        let dayAfterTomorrowDay = DateFormatter()
        dayAfterTomorrowDay.dateFormat = "EEE"
        dayAfterTomorrowLabel.text = dayAfterTomorrowDay.string(from: dayAfterTomorrow!).uppercased()
 

        
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
        
        appDelegate.staticLatitude = location.coordinate.latitude
        appDelegate.staticLongitude = location.coordinate.longitude
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            if let city = placeMark.locality, let state = placeMark.administrativeArea {
                self.selectedLocation.text = "\(city), \(state)"
                print("You are located in", city, state)
            }
            
            
            
        })
        
        self.getWeather()
        
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
        
        
        let apiKey = "ed431aaf78bd9b48e6647d64b1271ebd"
        let coordinates = "\(appDelegate.staticLatitude!),\(appDelegate.staticLongitude!)"
        
        let currentDate = "\(today!)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let testDate = standardDay.date(from: currentDate)
        
        print("The new date is \(testDate)")
        
        let dayForAPI = DateFormatter()
        dayForAPI.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dayForAPIFinal = dayForAPI.string(from: testDate!)
       
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(dayForAPIFinal)")
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
                    
                    self.todaysForecast = responseDictionary["currently"] as! NSDictionary
                    
                    self.todayDaily = responseDictionary["daily"] as! NSDictionary
                    
//                    self.tempCompare()
//                    
//                    self.updateTimeofDay()
//                    
//                    self.updateReferenceDate()
                    
                    self.getYesterdaysWeather()
                }
            }
        });
        task.resume()
        
    }
 
    
    func getYesterdaysWeather(){
        
        let apiKey = "ed431aaf78bd9b48e6647d64b1271ebd"
        let coordinates = "\(appDelegate.staticLatitude!),\(appDelegate.staticLongitude!)"
        
        let currentDate = "\(yesterday!)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let testDate = standardDay.date(from: currentDate)
        
        print("The new date is \(testDate)")
        
        let yesterdayAsUNIXString = DateFormatter()
        yesterdayAsUNIXString.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let yesterdayForAPI = yesterdayAsUNIXString.string(from: testDate!)
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(yesterdayForAPI)")
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
                    
                    self.yesterdaysForecast = responseDictionary["currently"] as! NSDictionary
                    
                    self.yesterdaysDaily = responseDictionary["daily"] as! NSDictionary

                    self.getDayBeforeYesterdaysWeather()
                   
                }
            }
        });
        task.resume()
        
    }
    
    
    func getDayBeforeYesterdaysWeather(){
        
        let apiKey = "ed431aaf78bd9b48e6647d64b1271ebd"
        let coordinates = "\(appDelegate.staticLatitude!),\(appDelegate.staticLongitude!)"
        
        let currentDate = "\(dayBeforeYesterday!)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let testDate = standardDay.date(from: currentDate)
        
        print("The new date is \(testDate)")
        
        let dayBeforeYesterdayAsUNIXString = DateFormatter()
        dayBeforeYesterdayAsUNIXString.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dayBeforeYesterdayForAPI = dayBeforeYesterdayAsUNIXString.string(from: testDate!)
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(dayBeforeYesterdayForAPI)")
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
                    
                    self.dayBeforeYesterdaysForecast = responseDictionary["currently"] as! NSDictionary
                    
                    self.dayBeforeYesterdaysDaily = responseDictionary["daily"] as! NSDictionary
                    
                    self.getTomorrowsWeather()
                    
                }
            }
        });
        task.resume()
        
    }
    
    
    func getTomorrowsWeather(){
        
        let apiKey = "ed431aaf78bd9b48e6647d64b1271ebd"
        let coordinates = "\(appDelegate.staticLatitude!),\(appDelegate.staticLongitude!)"
        
        let currentDate = "\(tomorrow!)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let testDate = standardDay.date(from: currentDate)
        
        print("The new date is \(testDate)")
        
        let tomorrowAsUNIXString = DateFormatter()
        tomorrowAsUNIXString.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let tomorrowForAPI = tomorrowAsUNIXString.string(from: testDate!)
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(tomorrowForAPI)")
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
                    
                    self.tomorrowsForecast = responseDictionary["currently"] as! NSDictionary
                    
                    self.tomorrowsDaily = responseDictionary["daily"] as! NSDictionary
                    
                    self.getDayAfterTomorrowsWeather()
                    
                }
            }
        });
        task.resume()
        
    }
    
    
    func getDayAfterTomorrowsWeather(){
        
        let apiKey = "ed431aaf78bd9b48e6647d64b1271ebd"
        let coordinates = "\(appDelegate.staticLatitude!),\(appDelegate.staticLongitude!)"
        
        let currentDate = "\(dayAfterTomorrow!)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let testDate = standardDay.date(from: currentDate)
        
        print("The new date is \(testDate)")
        
        let dayAfterTomorrowAsUNIXString = DateFormatter()
        dayAfterTomorrowAsUNIXString.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dayAfterTomorrowForAPI = dayAfterTomorrowAsUNIXString.string(from: testDate!)
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(dayAfterTomorrowForAPI)")
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
                    
                    self.dayAfterTomorrowsForecast = responseDictionary["currently"] as! NSDictionary
                    
                    self.dayAfterTomorrowsDaily = responseDictionary["daily"] as! NSDictionary
                    
                    self.tempCompare()
                    
                    self.updateTimeofDay()
                    
                    self.updateReferenceDate()
                    
                }
            }
        });
        task.resume()
        
    }
    
    
    func tempCompare() {
        
//      var comparisonTemp = Int(80)
        let todayTemp = Int(todaysForecast["apparentTemperature"] as! Float)
        let yesterdayTemp = Int(yesterdaysForecast["apparentTemperature"] as! Float)
        let dayBeforeYesterdayTemp = Int(dayBeforeYesterdaysForecast["apparentTemperature"] as! Float)
        let tomorrowTemp = Int(tomorrowsForecast["apparentTemperature"] as! Float)
        let dayAfterTomorrowTemp = Int(dayAfterTomorrowsForecast["apparentTemperature"] as! Float)
 
        
        appDelegate.staticTodayTemp = Int(todaysForecast["apparentTemperature"] as! Float)
        appDelegate.staticYesterdaysTemp = Int(yesterdaysForecast["apparentTemperature"] as! Float)
        appDelegate.staticDayBeforeYesterdaysTemp = Int(dayBeforeYesterdaysForecast["apparentTemperature"] as! Float)
        appDelegate.staticTomorrowsTemp = Int(tomorrowsForecast["apparentTemperature"] as! Float)
        appDelegate.staticDayAfterTomorrowsTemp = Int(dayAfterTomorrowsForecast["apparentTemperature"] as! Float)
        
        currentTemperatureLabel.text = "\(todayTemp)°"
        yesterdayTempLabel.text = "\(yesterdayTemp)°"
        dayBeforeYesterdayTempLabel.text = "\(dayBeforeYesterdayTemp)°"
        tomorrowTempLabel.text = "\(tomorrowTemp)°"
        dayAfterTomorrowTempLabel.text = "\(dayAfterTomorrowTemp)°"
        
        if appDelegate.locationName == "San Francisco" {
            
            selectedLocation.text = "San Francisco, CA"
            
        } else if appDelegate.locationName == "Atlanta" {
            
            selectedLocation.text = "Atlanta, GA"
            
        } else if appDelegate.locationName == "Chernobyl" {
            
            selectedLocation.text = "Chernobyl, Ukraine"
            weatherIcon.image = #imageLiteral(resourceName: "iconNuclear")
            
        } else {
            
            selectedLocation.text = "Plano, TX"
            
        }
        
        
        if appDelegate.selectedDate == "yesterday" {
            
            comparisonTemp = yesterdayTemp
            
        } else if appDelegate.selectedDate == "dayBeforeYesterday" {
            
            comparisonTemp = dayBeforeYesterdayTemp
            
        } else if appDelegate.selectedDate == "tomorrow" {
            
            comparisonTemp = tomorrowTemp
            
        } else if appDelegate.selectedDate == "dayAfterTomorrow" {
            
            comparisonTemp = dayAfterTomorrowTemp
            
        } else {
        
            comparisonTemp = todayTemp
            
        }
        
        
        let temperatureDifference = todayTemp - comparisonTemp
        let temperatureDelta = abs(temperatureDifference)

        
        if temperatureDifference < -10 && temperatureDelta >= 10 {
            
            print("Blue")
            tempFeelingLabel.textColor = appDelegate.blueColor
            currentTemperatureLabel.textColor = appDelegate.blueColor
            tempFeelingLabel.text = "a lot colder"
            appDelegate.defaultColor = appDelegate.blueColor
            
        } else if temperatureDifference < -3 && temperatureDelta < 10 {
            
            print("Light Blue")
            tempFeelingLabel.textColor = appDelegate.cyanColor
            currentTemperatureLabel.textColor = appDelegate.cyanColor
            tempFeelingLabel.text = "a bit cooler"
            appDelegate.defaultColor = appDelegate.cyanColor
            
        } else if temperatureDifference > 3 && temperatureDelta < 10 {
            
            print("Orange")
            tempFeelingLabel.textColor = appDelegate.orangeColor
            currentTemperatureLabel.textColor = appDelegate.orangeColor
            tempFeelingLabel.text = "a bit warmer"
            appDelegate.defaultColor = appDelegate.orangeColor
            
        } else if temperatureDifference > 10 && temperatureDelta >= 10 {
            
            print("Red")
            tempFeelingLabel.textColor = appDelegate.redColor
            currentTemperatureLabel.textColor = appDelegate.redColor
            tempFeelingLabel.text = "a lot hotter"
            appDelegate.defaultColor = appDelegate.redColor
            
        } else {
            
            print("Green")
            tempFeelingLabel.textColor = appDelegate.greenColor
            currentTemperatureLabel.textColor = appDelegate.greenColor
            tempFeelingLabel.text = "no different"
            appDelegate.defaultColor = appDelegate.greenColor
            
        }
        
        self.updateWeatherIcons()
        
    }
    
    func tempCompareSecondTime(){
        
        print(appDelegate.staticTodayTemp)
        print(appDelegate.staticYesterdaysTemp)
        
        
        if appDelegate.locationName == "San Francisco" {
            
            selectedLocation.text = "San Francisco, CA"
            
        } else if appDelegate.locationName == "Atlanta" {
            
            selectedLocation.text = "Atlanta, GA"
            
        } else if appDelegate.locationName == "Chernobyl" {
            
            selectedLocation.text = "Chernobyl, Ukraine"
            weatherIcon.image = #imageLiteral(resourceName: "iconNuclear")
            
        } else {
            
            selectedLocation.text = "Plano, TX"
            
        }

        
        if appDelegate.selectedDate == "yesterday" {
            
            comparisonTemp = appDelegate.staticYesterdaysTemp
            
        } else if appDelegate.selectedDate == "dayBeforeYesterday" {
            
            comparisonTemp = appDelegate.staticDayBeforeYesterdaysTemp
            
        } else if appDelegate.selectedDate == "tomorrow" {
            
            comparisonTemp = appDelegate.staticTomorrowsTemp
            
        } else if appDelegate.selectedDate == "dayAfterTomorrow" {
            
            comparisonTemp = appDelegate.staticDayAfterTomorrowsTemp
            
        } else {
            
            comparisonTemp = appDelegate.staticTodayTemp
            
        }
        
        
        let temperatureDifference = appDelegate.staticTodayTemp - comparisonTemp
        let temperatureDelta = abs(temperatureDifference)
        
        
        if temperatureDifference < -10 && temperatureDelta >= 10 {
            
            print("Blue")
            tempFeelingLabel.textColor = appDelegate.blueColor
            currentTemperatureLabel.textColor = appDelegate.blueColor
            tempFeelingLabel.text = "a lot colder"
            appDelegate.defaultColor = appDelegate.blueColor
            
        } else if temperatureDifference < -3 && temperatureDelta < 10 {
            
            print("Light Blue")
            tempFeelingLabel.textColor = appDelegate.cyanColor
            currentTemperatureLabel.textColor = appDelegate.cyanColor
            tempFeelingLabel.text = "a bit cooler"
            appDelegate.defaultColor = appDelegate.cyanColor
            
        } else if temperatureDifference > 3 && temperatureDelta < 10 {
            
            print("Orange")
            tempFeelingLabel.textColor = appDelegate.orangeColor
            currentTemperatureLabel.textColor = appDelegate.orangeColor
            tempFeelingLabel.text = "a bit warmer"
            appDelegate.defaultColor = appDelegate.orangeColor
            
        } else if temperatureDifference > 10 && temperatureDelta >= 10 {
            
            print("Red")
            tempFeelingLabel.textColor = appDelegate.redColor
            currentTemperatureLabel.textColor = appDelegate.redColor
            tempFeelingLabel.text = "a lot hotter"
            appDelegate.defaultColor = appDelegate.redColor
            
        } else {
            
            print("Green")
            tempFeelingLabel.textColor = appDelegate.greenColor
            currentTemperatureLabel.textColor = appDelegate.greenColor
            tempFeelingLabel.text = "no different"
            appDelegate.defaultColor = appDelegate.greenColor
            
        }
        
        self.presentUpdatedWeather()
        
    }

    
    func updateWeatherIcons() {
        
          let suggestedIcon = todaysForecast["icon"] as! String
    
            switch suggestedIcon {
            case "clear-day":
                weatherIcon.image = #imageLiteral(resourceName: "iconSunny")
            case "clear-night":
                weatherIcon.image = #imageLiteral(resourceName: "iconNight")
            case "rain":
                weatherIcon.image = #imageLiteral(resourceName: "iconRain")
            case "snow":
                weatherIcon.image = #imageLiteral(resourceName: "iconSnow")
            case "sleet":
                weatherIcon.image = #imageLiteral(resourceName: "iconSleet")
            case "wind":
                weatherIcon.image = #imageLiteral(resourceName: "iconWindy")
            case "fog":
                weatherIcon.image = #imageLiteral(resourceName: "iconFoggy")
            case "cloudy":
                weatherIcon.image = #imageLiteral(resourceName: "iconCloudy")
            case "partly-cloudy-day":
                weatherIcon.image = #imageLiteral(resourceName: "iconPartlyCloudy")
            case "partly-cloudy-night":
                weatherIcon.image = #imageLiteral(resourceName: "iconPartlyCloudyNight")
            default:
                weatherIcon.image = #imageLiteral(resourceName: "iconNuclear")
                break
            }
        
        if appDelegate.locationName == "Chernobyl" {
            
            weatherIcon.image = #imageLiteral(resourceName: "iconNuclear")
            
        } else {}
        
        presentUpdatedWeather()
        
    }

    
    func presentUpdatedWeather() {
        
        UIView.animate(withDuration: 0.9) { () -> Void in
            self.selectedLocation.alpha = 1
            self.weatherIcon.alpha = 1
            self.primaryMessageView.alpha = 1
            self.tempListView.alpha = 1
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

    
    func updateTimeofDay(){
        
        if appDelegate.selectedTime == "earlyMorning" {
            
            itFeelsLabel.text = "Early morning,\nit felt"
            
        } else if appDelegate.selectedTime == "morning" {
            
            itFeelsLabel.text = "This morning,\nit felt"
            
        } else if appDelegate.selectedTime == "afternoon" {
            
            itFeelsLabel.text = "This afternoon,\nit will feel"
            
        } else if appDelegate.selectedTime == "evening" {
            
            itFeelsLabel.text = "This evening,\nit will feel"
            
        } else if appDelegate.selectedTime == "night" {
            
            itFeelsLabel.text = "Tonight,\nit will feel"
            
        } else if appDelegate.selectedTime == "lateNight" {
            
            itFeelsLabel.text = "Late tonight,\nit will feel"
            
        } else {
            
            itFeelsLabel.text = "Right now,\nit feels"
            
        }
        
        
    }
 
    
    func updateReferenceDate(){
        
        let dayBeforeYesterdayExtended = DateFormatter()
        dayBeforeYesterdayExtended.dateFormat = "EEEE"

        let dayAfterTomorrowExtended = DateFormatter()
        dayAfterTomorrowExtended.dateFormat = "EEEE"
       
        
        if appDelegate.selectedDate == "dayBeforeYesterday" {
            
            comparisonLabel.text = "than\n\(dayBeforeYesterdayExtended.string(from: dayBeforeYesterday!))"
            
        } else if appDelegate.selectedDate == "yesterday" {
            
            comparisonLabel.text = "than\nyesterday"
            
        } else if appDelegate.selectedDate == "tomorrow" {
            
            comparisonLabel.text = "than\ntomorrow"
            
        } else if appDelegate.selectedDate == "dayAfterTomorrow" {
            
            comparisonLabel.text = "than\n\(dayAfterTomorrowExtended.string(from: dayAfterTomorrow!))"
            
        } else {
            
            print("No change!")
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("I'm appearing!")
    
        updateTimeofDay()
        
        updateReferenceDate()
        
        getWeather()
        
        
//      tempCompareSecondTime()
            
    }
    
    
    @IBAction func didTapDayBeforeYesterday(_ sender: UITapGestureRecognizer) {
  
        appDelegate.detailDate = "\(dayBeforeYesterday!)"
        performSegue(withIdentifier: "toDailyDetailView", sender: nil)
        
    }
    
    
    @IBAction func didTapYesterday(_ sender: UITapGestureRecognizer) {
 
        appDelegate.detailDate = "\(yesterday!)"
        performSegue(withIdentifier: "toDailyDetailView", sender: nil)
        
    }
    
    @IBAction func didtapCurrentDate(_ sender: UITapGestureRecognizer) {

        appDelegate.detailDate = "\(today!)"
        performSegue(withIdentifier: "toDailyDetailView", sender: nil)
        
    }
    
    @IBAction func didTapTomorrow(_ sender: UITapGestureRecognizer) {
  
        appDelegate.detailDate = "\(tomorrow!)"
        performSegue(withIdentifier: "toDailyDetailView", sender: nil)
        
    }
    
    @IBAction func didTapDayAfterTomorrow(_ sender: UITapGestureRecognizer) {
 
        appDelegate.detailDate = "\(dayAfterTomorrow!)"
        performSegue(withIdentifier: "toDailyDetailView", sender: nil)
        
    }
    
    @IBAction func onPressRefresh(_ sender: UIButton) {

        itFeelsLabel.text = "Right now,\nit feels"
        comparisonLabel.text = "than\nyesterday"
        
    }
    
}
