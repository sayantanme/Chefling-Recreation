//
//  Helpers.swift
//  Chefling-Recreation
//
//  Created by Sayantan Chakraborty on 23/01/18.
//  Copyright © 2018 Sayantan Chakraborty. All rights reserved.
//

import UIKit

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: 3, height: 2)
        self.layer.shadowRadius = 5
        self.layer.cornerRadius = 10
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,cornerRadius:10).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{
    func loadImageFromImageUrlFromCache(url:String){
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else{
                print(error?.localizedDescription ?? "error from loadImageFromImageUrlFromCache")
                return
            }
            DispatchQueue.main.async {
                if let downloadImage = UIImage(data: data!){
                    imageCache.setObject(downloadImage, forKey: url as AnyObject)
                    self.image = downloadImage
                }
            }
        }
        task.resume()
    }
}
