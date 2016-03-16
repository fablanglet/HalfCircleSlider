# Half Circle Slider

Half Circle Slider to select a color.

->![halfcircleslider_demo](https://cloud.githubusercontent.com/assets/5372802/13814947/da3805d2-eb88-11e5-8e56-85aaa300251a.gif)<-

### Retrieve selected color

```swift
extension ViewController: HalfCircleSliderDelegate {
    func halfCircleSlider(halfCircleSlider: HalfCircleSlider, didChangedValue color: UIColor?) {
        print("Got a color")
        colorView.backgroundColor = color
    }
}
```

### Set Gradient Color Point
```swift
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
        ]
    }
}
```