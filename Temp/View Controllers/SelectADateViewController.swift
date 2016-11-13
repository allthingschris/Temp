//
//  SelectADateViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 11/1/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit

class SelectADateViewController: UIViewController {

    @IBOutlet weak var primaryFocalView: UIView!
    @IBOutlet weak var yesterdayLabel: UILabel!
    @IBOutlet weak var dayBeforeYesterdayLabel: UILabel!
    @IBOutlet weak var tomorrowLabel: UILabel!
    @IBOutlet weak var dayAfterTomorrowLabel: UILabel!
    @IBOutlet weak var dayBeforeYesterdaySelectedIcon: UIImageView!
    @IBOutlet weak var yesterdaySelectedIcon: UIImageView!
    @IBOutlet weak var todaySelectedIcon: UIImageView!
    @IBOutlet weak var tomorrowSelectedIcon: UIImageView!
    @IBOutlet weak var dayAfterTomorrowSelectedIcon: UIImageView!
    
    var gradient = CAGradientLayer()

    let calendar = NSCalendar.current
    let yesterday = NSCalendar.current.date(byAdding: .day, value: -1, to: Date())
    let dayBeforeYesterday = NSCalendar.current.date(byAdding: .day, value: -2, to: Date())
    let tomorrow = NSCalendar.current.date(byAdding: .day, value: 1, to: Date())
    let dayAfterTomorrow = NSCalendar.current.date(byAdding: .day, value: 2, to: Date())
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradient()
        
        let yesterdayDay = DateFormatter()
        yesterdayDay.dateFormat = "EEEE"
        yesterdayLabel.text = yesterdayDay.string(from: yesterday!)
        
        let dayBeforeYesterdayDay = DateFormatter()
        dayBeforeYesterdayDay.dateFormat = "EEEE"
        dayBeforeYesterdayLabel.text = dayBeforeYesterdayDay.string(from: dayBeforeYesterday!)
        
        let tomorrowDay = DateFormatter()
        tomorrowDay.dateFormat = "EEEE"
        tomorrowLabel.text = tomorrowDay.string(from: tomorrow!)
 
        let dayAfterTomorrowDay = DateFormatter()
        dayAfterTomorrowDay.dateFormat = "EEEE"
        dayAfterTomorrowLabel.text = dayAfterTomorrowDay.string(from: dayAfterTomorrow!)

                switch appDelegate.selectedDate {
                case "dayBeforeYesterday":
                    dayBeforeYesterdaySelectedIcon.alpha = 1
                case "yesterday":
                    yesterdaySelectedIcon.alpha = 1
                case "today":
                    todaySelectedIcon.alpha = 1
                case "tomorrow":
                    tomorrowSelectedIcon.alpha = 1
                case "dayAfterTomorrow":
                    dayAfterTomorrowSelectedIcon.alpha = 1
                default:
                    break
                }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func didTapDayBeforeYesterday(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dayBeforeYesterdaySelectedIcon.alpha = 1
            self.yesterdaySelectedIcon.alpha = 0
            self.todaySelectedIcon.alpha = 0
            self.tomorrowSelectedIcon.alpha = 0
            self.dayAfterTomorrowSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedDate = "dayBeforeYesterday"
        
    }
    
    @IBAction func didTapYesterday(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dayBeforeYesterdaySelectedIcon.alpha = 0
            self.yesterdaySelectedIcon.alpha = 1
            self.todaySelectedIcon.alpha = 0
            self.tomorrowSelectedIcon.alpha = 0
            self.dayAfterTomorrowSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedDate = "yesterday"
        
    }
    
    @IBAction func didTapToday(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dayBeforeYesterdaySelectedIcon.alpha = 0
            self.yesterdaySelectedIcon.alpha = 0
            self.todaySelectedIcon.alpha = 1
            self.tomorrowSelectedIcon.alpha = 0
            self.dayAfterTomorrowSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedDate = "today"
        
    }
    
    
    @IBAction func didTapTomorrow(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dayBeforeYesterdaySelectedIcon.alpha = 0
            self.yesterdaySelectedIcon.alpha = 0
            self.todaySelectedIcon.alpha = 0
            self.tomorrowSelectedIcon.alpha = 1
            self.dayAfterTomorrowSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedDate = "tomorrow"
        
    }
    
    @IBAction func didTapDayAfterTomorrow(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.dayBeforeYesterdaySelectedIcon.alpha = 0
            self.yesterdaySelectedIcon.alpha = 0
            self.todaySelectedIcon.alpha = 0
            self.tomorrowSelectedIcon.alpha = 0
            self.dayAfterTomorrowSelectedIcon.alpha = 1
        }
        
        appDelegate.selectedDate = "dayAfterTomorrow"
        
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

