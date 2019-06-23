# BMGallery

[![CI Status](https://img.shields.io/travis/LEE%20ZHE%20YU/BMGallery.svg?style=flat)](https://travis-ci.org/LEE%20ZHE%20YU/BMGallery)
[![Version](https://img.shields.io/cocoapods/v/BMGallery.svg?style=flat)](https://cocoapods.org/pods/BMGallery)
[![License](https://img.shields.io/cocoapods/l/BMGallery.svg?style=flat)](https://cocoapods.org/pods/BMGallery)
[![Platform](https://img.shields.io/cocoapods/p/BMGallery.svg?style=flat)](https://cocoapods.org/pods/BMGallery)

## About
BMGallery supplies a easy way to simply use, create a transition animation like TikTok, apply to a situation that a UICollectionCell push into a detail UIViewController.

## DEMO
<img src="https://github.com/tzef/BMGallery/blob/master/demo.gif">

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
#### Create a UIView extend BMGallery
#### Implement BMGalleryDataSource and BMGalleryDelegate, assign to the gallery at the same time
#### Set the layout of the gallery (there are two options: aspect and fixHeight)
```swift
bmoGallery.delegate = self
bmoGallery.dataSource = self
bmoGallery.layoutType = .aspect(ratio: 30 / 23, itemCountOfLine: 3, margin: 8.0)
```
#### return cell counts in bmGalleryDataSourceNumberOfItems
````swift
func bmGalleryDataSourceNumberOfItems(in galleryView: BMGallery) -> Int {
    return datas.count
}
````
#### building the cell view content
````swift
func bmGalleryDataSourceContentViewForItem(at: Int, contentView: UIView) {
}
````
#### finally, in bmGalleryDelegateItemSelected or at other action, tell galleryView to push next page
````swift
galleryView.transition.push(vc, to: navigationController, fromItem: at)
````

### caution: the detail page must implement BMGalleryTransitioningDestination, must use sourceBMGallery to pop out
````swift
class DetailViewController: UIViewController, BMGalleryTransitioningDestination {
    @IBAction func closeAction(_ sender: Any) {
        self.sourceBMGallery?.transition.pop(from: navigationController)
    }
}
````

## Requirements
iOS 9.0 +
Swift 5

## Installation

BMGallery is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BMGallery'
```

## Author

LEE ZHE YU, tzef8220@gmail.com

## License

BMGallery is available under the MIT license. See the LICENSE file for more info.
