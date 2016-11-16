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
    @IBOutlet weak var hourlyScrollView: UIScrollView!
    @IBOutlet weak var primaryFocalView: UIView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var selectedDay: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var horizontalDivTop: UIView!
    @IBOutlet weak var horizontalDivBottom: UIView!
    
    var todayDaily: NSDictionary! = NSDictionary()
    var todayHourly: [NSDictionary]! = []
    var todaysForecast: NSDictionary! = NSDictionary()
    var gradient = CAGradientLayer()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        hourlyScrollView.contentSize = CGSize(width: 1479, height: 129)
        
        apparentMaxTempLabel.alpha = 0
        apparentMinTempLabel.alpha = 0
        nowTemp.alpha = 0
        dailySummary.alpha = 0
        weatherIcon.alpha = 0
        selectedDay.alpha = 0
        selectedDate.alpha = 0
        hourlyScrollView.alpha = 0
        horizontalDivTop.alpha = 0
        horizontalDivBottom.alpha = 0
        
        setupGradient()
        
        getWeather()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeather() {
        
        let apiKey = "c8ce828d290027eefc03bf39287d8589"
        let coordinates = "37.8267,-122.4233"
        let currentDate = "\(appDelegate.detailDate)"
        
        print(currentDate)
        
        let standardDay = DateFormatter()
        standardDay.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let testDate = standardDay.date(from: currentDate)
        
        let readableDate = DateFormatter()
        readableDate.dateStyle = .long
        selectedDate.text = readableDate.string(from: testDate!)
        
        let readableDay = DateFormatter()
        readableDay.dateFormat = "EEEE"
        selectedDay.text = readableDay.string(from: testDate!)
        
        print(coordinates)
        print("https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(currenltDate)")
        
        let url = URL(string:"https://api.darksky.net/forecast/\(apiKey)/\(coordinates),\(currentDate)")
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
                    
                    self.todayDaily = responseDictionary["daily"] as! NSDictionary
                    
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
        
        let summary = todayDaily["summary"]
        let apparentMinTemp = Int(61.4)
        let apparentMaxTemp = Int(78.5)
        let currentTemp = Int(todaysForecast["apparentTemperature"] as! Float)
        
        nowTemp.textColor = appDelegate.defaultColor
        dailySummary.text = summary as! String?
        nowTemp.text = "\(currentTemp)°"
        apparentMaxTempLabel.text = "\(apparentMaxTemp)°"
        apparentMinTempLabel.text = "\(apparentMinTemp)°"
        
        updateWeatherIcons()
        
    }
    
    func updateWeatherIcons() {
        
//      let suggestedIcon = todayDaily["icon"] as! String
    
//        switch suggestedIcon {
//        case "clear-day":
//            weatherIcon.image = #imageLiteral(resourceName: "iconSunny")
//        case "clear-night":
//            weatherIcon.image = #imageLiteral(resourceName: "iconNight")
//        case "rain":
//            weatherIcon.image = #imageLiteral(resourceName: "iconRain")
//        case "snow":
//            weatherIcon.image = #imageLiteral(resourceName: "iconSnow")
//        case "sleet":
//            weatherIcon.image = #imageLiteral(resourceName: "iconFlurry")
//        case "wind":
//            weatherIcon.image = #imageLiteral(resourceName: "iconWindy")
//        case "fog":
//            weatherIcon.image = #imageLiteral(resourceName: "iconWindy")
//        case "cloudy":
//            weatherIcon.image = #imageLiteral(resourceName: "iconCloudy")
//        case "partly-cloudy-day":
//            weatherIcon.image = #imageLiteral(resourceName: "iconPartlyCloudy")
//        case "partly-cloudy-night":
//            weatherIcon.image = #imageLiteral(resourceName: "iconPartlyCloudy")
//        default:
//            weatherIcon.image = #imageLiteral(resourceName: "iconNuclear")
//            break
//        }
        
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
            self.hourlyScrollView.alpha = 1
            self.horizontalDivTop.alpha = 1
            self.horizontalDivBottom.alpha = 1
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
