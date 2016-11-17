//
//  LoadingViewController.swift
//  Temp
//
//  Created by Parker, Bryan on 11/7/16.
//  Copyright © 2016 Parker, Bryan. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var primaryMessageView: UIView!
    @IBOutlet weak var loadingAnimation: UIImageView!

    var gradient = CAGradientLayer()
    var fadeTransition: FadeTransition!
    
    var loading00: UIImage!
    var loading01: UIImage!
    var loading02: UIImage!
    var loading03: UIImage!
    var loading04: UIImage!
    var loading05: UIImage!
    var loading06: UIImage!
    var loading07: UIImage!
    var loading08: UIImage!
    var loading09: UIImage!
    
    var images: [UIImage]!
    var iconLoading: UIImage!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setupGradient()
        
        // Do any additional setup after loading the view.
        
        loading00 = UIImage(named: "iconLoading00.png")
        loading01 = UIImage(named: "iconLoading01.png")
        loading02 = UIImage(named: "iconLoading02.png")
        loading03 = UIImage(named: "iconLoading03.png")
        loading04 = UIImage(named: "iconLoading04.png")
        loading05 = UIImage(named: "iconLoading05.png")
        loading06 = UIImage(named: "iconLoading06.png")
        loading07 = UIImage(named: "iconLoading07.png")
        loading08 = UIImage(named: "iconLoading08.png")
        loading09 = UIImage(named: "iconLoading09.png")
    
        images = [loading00, loading00, loading00, loading00, loading00, loading00, loading01, loading02, loading03, loading04, loading05, loading06, loading07, loading08, loading09]
        
        
        iconLoading = UIImage.animatedImage(with: images, duration: 0.95)
        
        loadingAnimation.image = iconLoading
        
        // Delay for 2 seconds, then run the code between the braces.
        let secondsToDelay = 3.0
        run(after: secondsToDelay) {
            // This code will run after the delay
            self.performSegue(withIdentifier: "primaryVC", sender: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    func setupGradient()
    {
        let gradientDark = appDelegate.charcoalGradient
        
        let color1 = gradientDark.cgColor as CGColor
        let color2 = gradientDark.cgColor as CGColor
        
        gradient.colors = [color1, color2]
        self.view.layer.insertSublayer(gradient, at: 1)
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
