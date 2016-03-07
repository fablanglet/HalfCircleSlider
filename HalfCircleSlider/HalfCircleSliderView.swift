//
//  CustomSliderView.swift
//  TestCircle
//
//  Created by Fabian Langlet on 02/03/16.
//  Copyright © 2016 Fabian Langlet. All rights reserved.
//

import UIKit

protocol HalfCircleSliderViewDelegate {
    func customSliderView(customSliderView: HalfCircleSliderView, didChangedValue color: UIColor?)
}

@IBDesignable class HalfCircleSliderView: UIView {
    
   @IBInspectable var mainColor:UIColor = UIColor.redColor()
    
    var colorUI : UIColor?
    var delegate: HalfCircleSliderViewDelegate?
    
    let components : [CGFloat] = [
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
    

    
    
    #if TARGET_INTERFACE_BUILDER
    override func willMoveToSuperview(newSuperview: UIView?) {
    let slider:HalfCircleSlider = HalfCircleSlider(gradientColors: components, frame: self.bounds)
        self.addSubview(slider)
    
    }
    
    #else
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Build the slider
        let slider:HalfCircleSlider = HalfCircleSlider(gradientColors: components, frame: self.bounds)
        
        // Attach an Action and a Target to the slider
        slider.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Add the slider as subview of this view
        self.addSubview(slider)
        
    }
    #endif
    
    func valueChanged(slider:HalfCircleSlider){
        // Do something with the value...
        print("Value changed \(slider.angle)")
        self.delegate?.customSliderView(self, didChangedValue: slider.currentColor)
    }
}