//
//  SelectATimeViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 11/1/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit

class SelectATimeViewController: UIViewController {
    
    @IBOutlet weak var primaryFocalView: UIView!
    @IBOutlet weak var earlyMorningSelectedIcon: UIImageView!
    @IBOutlet weak var morningSelectedIcon: UIImageView!
    @IBOutlet weak var afternoonSelectedIcon: UIImageView!
    @IBOutlet weak var eveningSelectedIcon: UIImageView!
    @IBOutlet weak var nightSelectedIcon: UIImageView!
    @IBOutlet weak var lateNightSelectedIcon: UIImageView!

    var gradient = CAGradientLayer()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGradient()
        
        switch appDelegate.selectedTime {
        case "earlyMorning":
            earlyMorningSelectedIcon.alpha = 1
        case "morning":
            morningSelectedIcon.alpha = 1
        case "afternoon":
            afternoonSelectedIcon.alpha = 1
        case "evening":
            eveningSelectedIcon.alpha = 1
        case "night":
            nightSelectedIcon.alpha = 1
        case "lateNight":
            lateNightSelectedIcon.alpha = 1
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

    @IBAction func didTapEarlyMorning(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.earlyMorningSelectedIcon.alpha = 1
            self.morningSelectedIcon.alpha = 0
            self.afternoonSelectedIcon.alpha = 0
            self.eveningSelectedIcon.alpha = 0
            self.nightSelectedIcon.alpha = 0
            self.lateNightSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedTime = "earlyMorning"
        
    }
    
    @IBAction func didTapMorning(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.earlyMorningSelectedIcon.alpha = 0
            self.morningSelectedIcon.alpha = 1
            self.afternoonSelectedIcon.alpha = 0
            self.eveningSelectedIcon.alpha = 0
            self.nightSelectedIcon.alpha = 0
            self.lateNightSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedTime = "morning"
        
    }
    
    @IBAction func didTapAfternoon(_ sender: UITapGestureRecognizer) {

        UIView.animate(withDuration: 0.3) { () -> Void in
            self.earlyMorningSelectedIcon.alpha = 0
            self.morningSelectedIcon.alpha = 0
            self.afternoonSelectedIcon.alpha = 1
            self.eveningSelectedIcon.alpha = 0
            self.nightSelectedIcon.alpha = 0
            self.lateNightSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedTime = "afternoon"
        
    }
    
    @IBAction func didTapEvening(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.earlyMorningSelectedIcon.alpha = 0
            self.morningSelectedIcon.alpha = 0
            self.afternoonSelectedIcon.alpha = 0
            self.eveningSelectedIcon.alpha = 1
            self.nightSelectedIcon.alpha = 0
            self.lateNightSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedTime = "evening"
        
    }

    @IBAction func didTapNight(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.earlyMorningSelectedIcon.alpha = 0
            self.morningSelectedIcon.alpha = 0
            self.afternoonSelectedIcon.alpha = 0
            self.eveningSelectedIcon.alpha = 0
            self.nightSelectedIcon.alpha = 1
            self.lateNightSelectedIcon.alpha = 0
        }
        
        appDelegate.selectedTime = "night"
        
    }
    
    @IBAction func didTapLateNight(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.earlyMorningSelectedIcon.alpha = 0
            self.morningSelectedIcon.alpha = 0
            self.afternoonSelectedIcon.alpha = 0
            self.eveningSelectedIcon.alpha = 0
            self.nightSelectedIcon.alpha = 0
            self.lateNightSelectedIcon.alpha = 1
        }
        
        appDelegate.selectedTime = "lateNight"
        
        
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
