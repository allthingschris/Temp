//
//  DailyDetailViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 11/1/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit
import CoreLocation
//import TTTAttributedLabel
import MapKit

class DailyDetailViewController: UIViewController {
    
    @IBOutlet weak var dailySummary: UILabel!
    @IBOutlet weak var currentTime1AM: UILabel!
    @IBOutlet weak var nowTemp: UILabel!
    @IBOutlet weak var apparentMinTempLabel: UILabel!
    @IBOutlet weak var apparentMaxTempLabel: UILabel!
    @IBOutlet weak var primaryFocalView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var selectedDay: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var horizontalDivTop: UIView!
    @IBOutlet weak var temperatureMaxLabel: UILabel!
    @IBOutlet weak var sunriseValue: UILabel!
    @IBOutlet weak var sunsetValue: UILabel!
    @IBOutlet weak var chanceOfRainValue: UILabel!
    @IBOutlet weak var dewPointValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var pressureValue: UILabel!
    @IBOutlet weak var ozoneValue: UILabel!
    @IBOutlet weak var visibilityValue: UILabel!
    @IBOutlet weak var windValue: UILabel!
    
    var todayDaily: [NSDictionary]! = []
    var todayHourly: [NSDictionary]! = []
    var todaysForecast: NSDictionary! = NSDictionary()
    var gradient = CAGradientLayer()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        apparentMaxTempLabel.alpha = 0
        apparentMinTempLabel.alpha = 0
        nowTemp.alpha = 0
        dailySummary.alpha = 0
        weatherIcon.alpha = 0
        selectedDay.alpha = 0
        selectedDate.alpha = 0
        horizontalDivTop.alpha = 0
        
        setupGradient()
        
        getWeather()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather() {
        
        let apiKey = "ed431aaf78bd9b48e6647d64b1271ebd"
        let coordinates = "\(appDelegate.staticLatitude!),\(appDelegate.staticLongitude!)"
        
        let currentDate = "\(appDelegate.detailDate)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let testDate = standardDay.date(from: currentDate)
        
        print("The new date is \(testDate)")
        
        let readableDate = DateFormatter()
        readableDate.dateStyle = .long
        selectedDate.text = readableDate.string(from: testDate!)
        
        let readableDay = DateFormatter()
        readableDay.dateFormat = "EEEE"
        selectedDay.text = readableDay.string(from: testDate!)
        
        let dayForAPI = DateFormatter()
        dayForAPI.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dayForAPIFinal = dayForAPI.string(from: testDate!)
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(dayForAPIFinal)")
        
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
                    
                    self.todaysForecast = responseDictionary["currently"] as! NSDictionary
                    
                    self.todayDaily = responseDictionary.value(forKeyPath: "daily.data") as! [NSDictionary]
                    
                    self.todayHourly = responseDictionary.value(forKeyPath: "hourly.data") as! [NSDictionary]
                    
                    
                    
                    let firstHour = self.todayHourly[0]
                    let apparentTemperature = firstHour["apparentTemperature"] as! Float
                    print("Apparent: \(apparentTemperature)")
                    
                    
                    
                    self.updateWeatherValues()
                    
                }
            }
        });
        task.resume()
        
        
    }
    
    func updateWeatherValues() {
        
        let currentTemp = Int(todaysForecast["apparentTemperature"] as! Float)
        
        let dailyData = self.todayDaily[0]
        let maxTemperature = Int(dailyData["temperatureMax"] as! Float)
        let minTemperature = Int(dailyData["temperatureMin"] as! Float)
        let sunrise = dailyData["sunriseTime"]
        let sunset = dailyData["sunsetTime"]
        let chanceOfRain = "\(dailyData["precipProbability"] as! Float)%"
        let humidity = dailyData["humidity"] as! Float
        let wind = dailyData["windSpeed"] as! Float
        let dewPoint = dailyData["dewPoint"] as! Float
        let visibility = dailyData["visibility"] as! Float
        let pressure = dailyData["pressure"] as! Float
        let ozone = dailyData["ozone"] as! Float
        let dailyIcon = dailyData["icon"] as! String
        
        let summary = dailyData["summary"] as! String
        
        let sunriseAsDate = DateFormatter()
        sunriseAsDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(sunrise!)
//        let sunriseAsDateActual = sunriseAsDate.date(from:"\(sunrise!)")
        let sunriseAsDateActual = Date(timeIntervalSince1970: sunrise as! Double)
        
        print("The new date is \(sunriseAsDateActual)")
        
        let readableSunrise = DateFormatter()
        readableSunrise.timeStyle = .short
        sunriseValue.text = readableSunrise.string(from: sunriseAsDateActual)
        
        let sunsetAsDate = DateFormatter()
        sunsetAsDate.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print(sunset!)
        let sunsetAsDateActual = Date(timeIntervalSince1970: sunset as! Double)
        
        print("The new date is \(sunsetAsDateActual)")
        
        let readableSunset = DateFormatter()
        readableSunset.timeStyle = .short
        sunsetValue.text = readableSunset.string(from: sunsetAsDateActual)

        apparentMaxTempLabel.text = "\(maxTemperature)°"
        apparentMinTempLabel.text = "\(minTemperature)°"
//        sunriseValue.text = "\(sunrise)"
//        sunsetValue.text = "\(sunset)"
        chanceOfRainValue.text = "\(chanceOfRain)"
        humidityValue.text = "\(humidity)"
        windValue.text = "\(wind)"
        dewPointValue.text = "\(dewPoint)"
        visibilityValue.text = "\(visibility)"
        pressureValue.text = "\(pressure)"
        ozoneValue.text = "\(ozone)"
        
        nowTemp.textColor = appDelegate.defaultColor
        dailySummary.text = summary
        nowTemp.text = "\(currentTemp)°"

        switch dailyIcon {
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

        presentUpdatedWeather()
        
    }
    
    
    
    func presentUpdatedWeather() {
        
        UIView.animate(withDuration: 0.9) { () -> Void in
            self.apparentMinTempLabel.alpha = 1
            self.apparentMaxTempLabel.alpha = 1
            self.nowTemp.alpha = 1
            self.dailySummary.alpha = 1
            self.weatherIcon.alpha = 1
            self.selectedDay.alpha = 1
            self.selectedDate.alpha = 1
            self.horizontalDivTop.alpha = 1
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
        let labelOrigin = CGPoint(x: primaryFocalView.bounds.origin.x,y: primaryFocalView.bounds.origin.y);
        // Convert the label origin to its origin in the superview coordinate system
        let topInScreen = primaryFocalView.convert(labelOrigin, to: view)
        // Set the gradient stop position above the label based on the y position in superview
        let topGradientStop = topInScreen.y
        // Compute the gradient stop number between 0 and 1 as ratio of screen height
        let topStopLocation = topGradientStop/screenHeight
        
        // Determine position for gradient to start below label by adding label height
        let bottomGradientStart = topGradientStop + primaryFocalView.bounds.size.height
        // Compute the gradient start number between 0 and 1 as ratio of screen height
        let bottomStartLocation = bottomGradientStart/screenHeight
        
        return [0.0, topStopLocation, bottomStartLocation, 1.0]
        
    }

    
    
    @IBAction func didClose(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
