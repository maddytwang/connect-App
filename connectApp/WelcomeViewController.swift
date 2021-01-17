//
//  WelcomeViewController.swift
//  connectApp
//
//  Created by Maddy Wang on 1/15/21.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController {
    
    @IBOutlet var holderView: UIView!
    
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configure()
    }
    
    
    let titles = ["Welcome to Connect!", "What's your name?", "Perfect! Your profile is all set."]
    private func configure() {
        // sets up scrollview
        scrollView.frame = holderView.bounds
        holderView.addSubview(scrollView)
        
        for x in 0..<3 {
            let pageView = UIView(frame: CGRect(x: CGFloat(x) * (holderView.frame.size.width), y: 0, width: holderView.frame.size.width, height: holderView.frame.size.height))
            scrollView.addSubview(pageView)
            
            // title
            let label = UILabel(frame: CGRect(x: 10, y: 10, width: pageView.frame.size.width-20, height: 120))
            
            //button
            let button = UIButton(frame: CGRect(x: 10, y: pageView.frame.size.height-60, width: pageView.frame.size.width-20, height: 50))
            
            //title attributes
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica-Bold", size: 24)
            pageView.addSubview(label)
            label.text = titles[x]
            
            
            //button attributes
            // not exact same colors as wireframe --> to use hexcode requires hexcode to swift color name function
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = .gray
            button.setTitle("Next", for: .normal)
            
            
            // welcome page attributes
            if x == 0 {
                let connectDescription = UILabel(frame: CGRect(x: 10, y: pageView.frame.size.height - 500, width: pageView.frame.size.width-30, height: 120))
                connectDescription.textAlignment = .center
                connectDescription.font = UIFont(name: "Helvetica", size: 20)
                pageView.addSubview(connectDescription)
                connectDescription.text = "Connect wants to make women’s needs and safety a priority by providing resources, education, and connecting you with your network in emergencies."
                connectDescription.numberOfLines = 5
                connectDescription.lineBreakMode = .byWordWrapping
            }
            
            //name page attributes
            if x == 1 {
                let nameTextField = UITextField(frame: CGRect(x: 10, y: pageView.frame.size.height - 450, width: 375.00, height: 30.00))
                nameTextField.borderStyle = .roundedRect
                nameTextField.placeholder = "Name"
                pageView.addSubview(nameTextField)
            }
            
//            //age --> currenly unneeded for MVP
//            if x == 2 {
//                let agePicker = UIPickerView(frame: CGRect(x: 10, y: pageView.frame.size.height - 450, width: 200, height: 30))
//                pageView.addSubview(agePicker)
//
//            }
//
//            //gender --> currenly unneeded for MVP
//            if x == 3 {
//                label.numberOfLines = 3
//                label.lineBreakMode = .byWordWrapping
//                let genderPicker = UIPickerView(frame: CGRect(x: 10, y: pageView.frame.size.height - 450, width: 200, height: 30))
//                pageView.addSubview(genderPicker)
//            }
            
            // changes next button to 'get started'
            if x == 2{
                button.setTitle("Get Started", for: .normal)
            }
            
            //request location access
            func hasLocationPermission() -> Bool {
                var hasPermission = false
                let manager = CLLocationManager()
                
                if CLLocationManager.locationServicesEnabled() {
                    switch manager.authorizationStatus {
                    case .notDetermined, .restricted, .denied:
                        hasPermission = false
                    case .authorizedAlways, .authorizedWhenInUse:
                        hasPermission = true
                    @unknown default:
                        break
                    }
                } else {
                    hasPermission = false
                }
                
                return hasPermission
            }
            
            if !hasLocationPermission() {
                let alertController = UIAlertController(title: "Location Permission Required", message: "Connect’s main feature includes a map to display resources, clinics, and other information. Please enable location permissions in settings.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alertController.addAction(cancelAction)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = x + 1
            pageView.addSubview(button)
        }
        
        
        
        
        scrollView.contentSize = CGSize(width: holderView.frame.size.width * 3, height: 0)
        scrollView.isPagingEnabled = true
    }
    
    @objc func didTapButton(_ button: UIButton) {
        guard button.tag < 3 else {
            //dismiss welcome page
            Core.shared.setIsNotNewUser()
            dismiss(animated: true, completion: nil)
            return
        }
        //scroll to next page
        
        
        scrollView.setContentOffset(CGPoint(x: holderView.frame.size.width * CGFloat(button.tag), y: 0), animated: true)
    }
    
    
}
