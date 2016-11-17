//
//  SelectALocationViewController.swift
//  Temp
//
//  Created by Christopher Ryan on 11/1/16.
//  Copyright © 2016 Christopher Ryan. All rights reserved.
//

import UIKit

class SelectALocationViewController: UIViewController {
    
    @IBOutlet weak var chernobylSelectedIcon: UIImageView!
    @IBOutlet weak var hotlantaSelectedIcon: UIImageView!
    @IBOutlet weak var sanFranSelectedIcon: UIImageView!
    @IBOutlet weak var currentLocationSelectedIcon: UIImageView!
    @IBOutlet weak var primaryFocalView: UIView!
  
    var gradient = CAGradientLayer()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        chernobylSelectedIcon.alpha = 0
        hotlantaSelectedIcon.alpha = 0
        sanFranSelectedIcon.alpha = 0
        currentLocationSelectedIcon.alpha = 1
        
        
        setupGradient()

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

    @IBAction func didTapCurrentLocation(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.chernobylSelectedIcon.alpha = 0
            self.hotlantaSelectedIcon.alpha = 0
            self.sanFranSelectedIcon.alpha = 0
            self.currentLocationSelectedIcon.alpha = 1
        }
        
        appDelegate.staticLatitude = 33.016667
        appDelegate.staticLongitude =  -96.683333
        appDelegate.locationName = "Plano"
        
        
    }
    
    @IBAction func didTapSanFran(_ sender: UITapGestureRecognizer) {
 
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.chernobylSelectedIcon.alpha = 0
            self.hotlantaSelectedIcon.alpha = 0
            self.sanFranSelectedIcon.alpha = 1
            self.currentLocationSelectedIcon.alpha = 0
        }
        
        appDelegate.staticLatitude = 37.783333
        appDelegate.staticLongitude = -122.416667
        appDelegate.locationName = "San Francisco"

        
    }
    
    @IBAction func didTapThatHotlanta(_ sender: UITapGestureRecognizer) {
     
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.chernobylSelectedIcon.alpha = 0
            self.hotlantaSelectedIcon.alpha = 1
            self.sanFranSelectedIcon.alpha = 0
            self.currentLocationSelectedIcon.alpha = 0
        }
        
        appDelegate.staticLatitude = 33.755
        appDelegate.staticLongitude = -84.39
        appDelegate.locationName = "Atlanta"
        
    }
    
    @IBAction func didTapButNowDead(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.chernobylSelectedIcon.alpha = 1
            self.hotlantaSelectedIcon.alpha = 0
            self.sanFranSelectedIcon.alpha = 0
            self.currentLocationSelectedIcon.alpha = 0
        }
        
        appDelegate.staticLatitude = 51.272222
        appDelegate.staticLongitude = 30.224167
        appDelegate.locationName = "Chernobyl"
        
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
