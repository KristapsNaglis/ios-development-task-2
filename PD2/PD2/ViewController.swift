//
//  ViewController.swift
//  PD2
//
//  Created by Students on 30/04/2020.
//  Copyright © 2020 via. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // Outlet definitons
    @IBOutlet var mainHeading: UILabel!
    @IBOutlet var trafficLight: UIImageView!
    @IBOutlet var trafficLightTimePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set font color for UIDatePicker
        trafficLightTimePicker.setValue(UIColor.white, forKey: "textColor")
       
        // Default traffic light to green upon load
        trafficLight.image = UIImage(named: "traffic_light_green.png")
       
        // Update traffic light every time when UIDatePicker has changed its value
        trafficLightTimePicker.addTarget(self, action: #selector(changeTrafficLight), for: UIControl.Event.allEvents)
        
    }
    
    // PSA: this could probably be done way better and legit	
    @objc func changeTrafficLight(){
        
        // Get the time passed since start and calculate how much time has passed since that to the time on UIDatePicker. Divide by 60 to get minutes insted of seconds
        let timePassed = (trafficLightTimePicker.date.timeIntervalSince1970 - 10800.00) / 60
        
        // Coefficient is the variable which decides in what state should the traffic light be. 7 here is because there ar 7 unique states for traffic light which repeat over and over - 1.Green 2.Green 3.Orange 4.Red 5.Red 6.Red 7.Orange ...
        // Below is an example: g - green; o - orange; r - red; numbers - minutes since start
        // 0g    1g    2o    3r    4r    5r    6o
        // 7g    8g    9o    10r   11r   12r   13o
        // 14g   15g   16o   17r   18r   19r   20o
        // 21g   22g   23o   24r   25r   26r   27o
        // ...
        // for example let's take first red light (column 4)
        // when you take any of the numbers in that column and divide by the total column count you will get a result of *.429 where star will be represented by row number (starting from 0). That number becomes an identifier of which light to turn on. Every column will have its unique set of identifiers
        // Green  - *.0   and *.143
        // Orange - *.286 and *.857
        // Red    - *.429 and *.571 and *.714
        var coefficient = timePassed / 7
        
        // This variable is needed for later use but it essentially represents the "*" AKA the row number e.g. in 1.429 the "1" is this variable
        let trafficLightCycle = floor(coefficient)
        
        // Here we round coefficient variable to 3 digits begind comma
        coefficient = (coefficient * 1000).rounded() / 1000
        
        // If the "*" number is 0 then do nothing becauce we already have coefficient number in desired format, which is "0.XXX"
        // Else take the coefficient number and subtract it with the row number, for example, if we take 17th minute since start, we have coefficient of 2.429 and to get the desired format of "0.429" we just subtract the row number which is "2"
        if trafficLightCycle != 0 {
            coefficient = coefficient - trafficLightCycle
        }
        
        // Coefficient is rounded again because when the "*" number passes 0, it shits up the previous rounding
        coefficient = (coefficient * 1000).rounded() / 1000
        
        // Main satements of actually changing traffic light image based on their corresponding values
        if coefficient == 0.0 || coefficient == 0.143 {
            trafficLight.image = UIImage(named: "traffic_light_green.png")
        } else if coefficient == 0.286 || coefficient == 0.857 {
            trafficLight.image = UIImage(named: "traffic_light_orange.png")
        } else if coefficient == 0.429 || coefficient == 0.571 || coefficient == 0.714 {
                   trafficLight.image = UIImage(named: "traffic_light_red.png")
        } else {
            mainHeading.text = "Something went wrong"
            trafficLight.image = UIImage(named: "traffic_light_off.png")
        }
    }
}

