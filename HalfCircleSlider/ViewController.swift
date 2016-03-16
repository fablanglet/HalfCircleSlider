//
//  ViewController.swift
//  HalfCircleSlider
//
//  Created by Fabian Langlet on 07/03/16.
//  Copyright © 2016 Fabian Langlet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var slider: HalfCircleSlider!
    @IBOutlet weak var colorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slider.delegate = self
        slider.datasource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: HalfCircleSliderDelegate {
    func halfCircleSlider(halfCircleSlider: HalfCircleSlider, didChangedValue color: UIColor?) {
        print("Got a color")
        colorView.backgroundColor = color
    }
}

extension ViewController: HalfCircleSliderDataSource {
    func halfCircleSlider(halfCircleSlider: HalfCircleSlider) -> [CGFloat] {
        return [
            255.0/255.0, 0.0/255.0, 0.0/255.0, 1.0,
            249.0/255.0, 192.0/255.0, 196.0/255.0, 1.0,
            253.0/255.0, 199.0/255.0, 159.0/255.0, 1.0,
            249.0/255.0, 203.0/255.0, 37.0/255.0, 1.0,
            208.0/255.0, 225.0/255.0, 120.0/255.0, 1.0,
            154.0/255.0, 220.0/255.0, 187.0/255.0, 1.0,
            1.0/255.0, 176.0/255.0, 216.0/255.0, 1.0,
            21.0/255.0, 99.0/255.0, 215.0/255.0, 1.0,
            106.0/255.0, 155.0/255.0, 229.0/255.0, 1.0,
            21.0/255.0, 99.0/255.0, 215.0/255.0, 1.0,
            1.0/255.0, 99.0/255.0, 215.0/255.0, 1.0,
            154.0/255.0, 220.0/255.0, 187.0/255.0, 1.0,
            208.0/255.0, 225.0/255.0, 120.0/255.0, 1.0,
            249.0/255.0, 203.0/255.0, 37.0/255.0, 1.0,
            253.0/255.0, 199.0/255.0, 159.0/255.0, 1.0,
            249.0/255.0, 192.0/255.0, 196.0/255.0, 1.0,
            255.0/255.0, 0.0/255.0, 0.0/255.0, 1.0
        ]
    }
}
