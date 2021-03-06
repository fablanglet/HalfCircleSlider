//
//  CustomSlider.swift
//  TestCircle
//
//  Created by Fabian Langlet on 02/03/16.
//  Copyright © 2016 Fabian Langlet. All rights reserved.
//
import Foundation
import UIKit


protocol HalfCircleSliderDelegate {
    func halfCircleSlider(halfCircleSlider: HalfCircleSlider, didChangedValue color: UIColor?)
}

protocol HalfCircleSliderDataSource {
    func halfCircleSlider(halfCircleSlider: HalfCircleSlider) -> [CGFloat]
}

@IBDesignable class HalfCircleSlider: UIControl {
    
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.blueColor()

    @IBInspectable var gradient: Bool = false
    
    
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
    
    var delegate : HalfCircleSliderDelegate?
    var datasource : HalfCircleSliderDataSource?
    
    private var gradientColors = [CGFloat]()
    private var color: UIColor?
    private var currentPoint: CGPoint?
    
    private var radius:CGFloat = 0
    private var angle:Int = 0
    private var currentColor: UIColor?
    private var currentHandlePosition: CGRect?
    
    // Custom initializer
    convenience init(gradientColors: [CGFloat], frame:CGRect){
        self.init(frame: frame)
        self.gradientColors = gradientColors
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    
    private func initialize(){
        self.backgroundColor = UIColor.clearColor()
        self.addTarget(self, action: "valueChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        if (CGRectContainsPoint(self.currentHandlePosition!, touch.locationInView(self))){
            return true
        }
        return false
    }
    
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        self.currentPoint = touch.locationInView(self)
        
        self.moveSelector(self.currentPoint!)
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
    }
    
    
    //Use the draw rect to draw the Background, the half circle and the handle
    override func drawRect(rect: CGRect){
        super.drawRect(rect)
        
        self.sizeToFit()
        
        let bounds:CGRect = self.bounds
        // Rotate the angles so that the inputted angles are intuitive like the clock face: the top is 0 (or 2π), the right is π/2, the bottom is π and the left is 3π/2.
        // In essence, this appears like a unit circle rotated π/2 anti clockwise.
        let startAngle: CGFloat = -CGFloat(M_PI_2)
        let endAngle: CGFloat = CGFloat(M_PI * 2.0) - CGFloat(M_PI_2)
        
        let widthRadius = bounds.size.width - (Config.Button_Width/2.0) - 1
        let heightRadius = (bounds.size.height / 2.0) - (Config.Button_Width/2.0) - 1
        
        self.radius = widthRadius > heightRadius ? heightRadius : widthRadius
        
        var center = CGPoint()
        center.x = 0
        center.y = (bounds.origin.y + bounds.size.height) / 2.0
        
        // Get the context
        let context = UIGraphicsGetCurrentContext()
        CGContextAddArc(context, center.x, center.y, CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), 0)
        CGContextSetLineWidth(context, CGFloat(Config.Stroke_Width)) // Set the line width
        CGContextSetLineCap(context, CGLineCap.Butt)
        CGContextReplacePathWithStrokedPath(context)
        
        // Setup the gradient
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        var cgGradient: CGGradient
        
        if let gradientSrc = self.datasource?.halfCircleSlider(self) {
           cgGradient = CGGradientCreateWithColorComponents(baseSpace, gradientSrc, nil, gradientSrc.count/4)!
        } else if (gradient){
            cgGradient = CGGradientCreateWithColorComponents(baseSpace, components, nil, components.count/4)!
        } else {
            let startColorComponents = CGColorGetComponents(startColor.CGColor)
            let endColorComponents = CGColorGetComponents(endColor.CGColor)
            let colorComponents
            = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
            
            cgGradient = CGGradientCreateWithColorComponents(baseSpace, colorComponents, nil, 2)!
        }
        
        // Gradient direction
        let startPoint = CGPointMake(CGRectGetMidX(rect), 0.0)
        let endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
        
        CGContextSaveGState(context)
        CGContextClip(context)
        CGContextDrawPath(context, CGPathDrawingMode.Stroke)
        CGContextDrawLinearGradient(context, cgGradient, startPoint, endPoint, CGGradientDrawingOptions(rawValue: 1))
        CGContextRestoreGState(context)
        /* Draw the handle */
        if let ctx = context {
            drawSelector(ctx)
        }
        
    }
    
    /** Move the selector **/
    func moveSelector(lastPoint:CGPoint){
        
        //Get the center
        let centerPoint:CGPoint  = CGPointMake(0, self.frame.size.height/2);
        //Calculate the direction from a center point and a arbitrary position.
        let currentAngle:Double = AngleFromNorth(centerPoint, p2: lastPoint, flipped: false)
        let angleInt = Int(floor(currentAngle))
        
        //Store the new angle
        angle = -1 * Int(angleInt)
        
        //Redraw
        setNeedsDisplay()
    }
    
    
    /** Draw a selector over the half circle **/
    func drawSelector(ctx:CGContextRef){
        //Get the handle position
        var handleCenter = pointFromAngle(angle)
        
        if (handleCenter.x < Config.Button_Width/2.0){
            handleCenter.x = Config.Button_Width/2.0
        }
        
        let rect = CGRectMake(handleCenter.x - (Config.Button_Width/2.0), handleCenter.y, Config.Button_Width, Config.Button_Width)
        
        if let _ = self.currentPoint {
            let newRect = CGRectMake(handleCenter.x, handleCenter.y, Config.Button_Width, Config.Button_Width)
            let center = CGPointMake(newRect.midX, newRect.midY)
            currentColor = self.getColorFromPoint(center)
        }
        
        CGContextSaveGState(ctx);
        
        //Shadows
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, UIColor.blackColor().CGColor);
        
        //Draw It!
        UIColor(white:1.0, alpha:0.7).set();
        CGContextFillEllipseInRect(ctx, rect);
        
        CGContextRestoreGState(ctx);
        currentHandlePosition = rect
    }
    
    
    /** Get the point position on half circle depending of the angle **/
    func pointFromAngle(angleInt:Int)->CGPoint{
        //Circle center
        let centerPoint = CGPointMake(0, ((bounds.origin.y + bounds.size.height - Config.Button_Width) / 2.0));
        
        //The point position on the circumference
        var result:CGPoint = CGPointZero
        let y = round(Double(radius) * sin(DegToRad(Double(-angleInt)))) + Double(centerPoint.y)
        let x = round(Double(radius) * cos(DegToRad(Double(-angleInt)))) + Double(centerPoint.x)
        result.y = CGFloat(y)
        result.x = CGFloat(x)
        
        return result;
    }
    
    //Sourcecode from Apple example clockControl
    //Calculate the direction in degrees from a center point to an arbitrary position.
    func AngleFromNorth(p1:CGPoint , p2:CGPoint , flipped:Bool) -> Double {
        var v:CGPoint  = CGPointMake(p2.x - p1.x, p2.y - p1.y)
        let vmag:CGFloat = Square(Square(v.x) + Square(v.y))
        var result:Double = 0.0
        v.x /= vmag;
        v.y /= vmag;
        let radians = Double(atan2(v.y,v.x))
        result = RadToDeg(radians)
        return result
    }

    func valueChanged(slider:HalfCircleSlider){
        print(angle)
        self.delegate?.halfCircleSlider(self, didChangedValue: self.currentColor)
    }
    
    private func getColorFromPoint(point:CGPoint) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()!
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGBitmapContextCreate(&pixelData, 1, 1, 8, 4, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue)
        CGContextTranslateCTM(context, -point.x + (Config.Button_Width/2.0), -point.y)
        self.layer.renderInContext(context!)
        
        let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}

extension HalfCircleSlider {
    struct Config {
        static let Button_Width:CGFloat = 40.0
        static let Stroke_Width:CGFloat = 10.0
        
    }
    
    func DegToRad(value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    func RadToDeg(value:Double) -> Double {
        return value * 180.0 / M_PI
    }
    
    func Square(value:CGFloat) -> CGFloat {
        return value * value
    }
}
