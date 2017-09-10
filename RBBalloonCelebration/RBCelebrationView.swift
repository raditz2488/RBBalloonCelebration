//
//  RBCelebrationView.swift
//  RBBalloonCelebration
//
//  Created by Rohan on 09/09/17.
//  Copyright © 2017 RB. All rights reserved.
//

import UIKit

class RBCelebrationView: UIView {
    let blueBalloon = UIImage(named: "blueballonclip")!
    let greenBalloon = UIImage(named: "greenballonclip")!
    let pinkBalloon = UIImage(named: "pinkballonclip")!
    let yellowBalloon = UIImage(named: "yellowballonclip")!
    let confettiImage = UIImage(named: "Confettibg")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(patternImage: confettiImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating() {
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(animateRandomBalloon), userInfo: nil, repeats: true)
    }
    
    func animateRandomBalloon() {
        let balloon = addRandomBalloon()
        let balloonPath = path(forBalloon: balloon)
        addAnimationPath(balloonPath, toBalloon: balloon)
    }
    
    func addRandomBalloon() -> UIImageView {
        let balloon = balloonImageView()
        let randomBalloonWidth: CGFloat = randomWidthForBalloon()
        let balloonImageRatio = balloon.image!.size.height / balloon.image!.size.width
        let randomBalloonHeight = balloonImageRatio * randomBalloonWidth
        
        let balloonSize = CGSize(width: randomBalloonWidth, height: randomBalloonHeight)
        let balloonOriginX = randomXForBalloon(ofWidth: randomBalloonWidth)
        let balloonOriginY = self.bounds.size.height
        let balloonOrigin = CGPoint(x: balloonOriginX, y: balloonOriginY)
        
        
        balloon.frame = CGRect(origin: balloonOrigin, size: balloonSize)
        self.addSubview(balloon)
        balloon.alpha = 0.7
        return balloon
    }
    
    func balloonImageView() -> UIImageView {
        let imageView = UIImageView(frame: .zero)
        
        imageView.image = randomBallonImage()
        return imageView
    }
    
    func randomBallonImage() -> UIImage {
        switch arc4random() % 4 + 1 {
        case 1:
            return blueBalloon
        case 2:
            return pinkBalloon
        case 3:
            return greenBalloon
        case 4:
            return yellowBalloon
            
        default:
            fatalError("No balloon for this case")
        }
    }
    
    func randomWidthForBalloon() -> CGFloat {
        let minWidthRatio: CGFloat = 0.25
        let maxWidthRatio: CGFloat = 0.50
        var randomRatio: CGFloat = 0.0
        while randomRatio < minWidthRatio || randomRatio > maxWidthRatio {
            randomRatio = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        }
        return self.bounds.width * randomRatio
    }
    
    func randomXForBalloon(ofWidth width:CGFloat) -> CGFloat {
        let allowedWidth = Int(self.bounds.size.width)
        let randomOrigin = (Int(arc4random()) % allowedWidth) + 1
        return CGFloat(randomOrigin)
    }
    
    func path(forBalloon balloon: UIImageView) -> UIBezierPath {
        let path = UIBezierPath()
        UIColor.black.setStroke()
        UIColor.red.setFill()
        
        let ox: CGFloat = balloon.frame.minX
        let oy: CGFloat = balloon.frame.minY
        let ex: CGFloat = balloon.frame.minX
        let ey: CGFloat = -balloon.frame.height
        
        let op = CGPoint(x: ox, y: oy)
        let ep = CGPoint(x: ex, y: ey)
        
        let temp: CGFloat = CGFloat(arc4random() % UInt32(150) + 150)
        var c1x: CGFloat = ox - temp
        var c2x: CGFloat = ox + temp
        
        let randomValue = arc4random() % 2
        if randomValue == 1 {
            let temp = c1x
            c1x = c2x
            c2x = temp
        }
        
        let c1y: CGFloat = oy / 2
        let c2y: CGFloat = oy / 2
        
        let c1: CGPoint = CGPoint(x: c1x, y: c1y)
        let c2: CGPoint = CGPoint(x: c2x, y: c2y)
        
        path.move(to: op)
        path.addCurve(to: ep, controlPoint1: c1, controlPoint2: c2)
        return path
    }
    
    func addAnimationPath(_ path: UIBezierPath, toBalloon balloon:UIImageView) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            balloon.removeFromSuperview()
        }
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 8
        pathAnimation.path = path.cgPath
        pathAnimation.fillMode = kCAFillModeForwards
        pathAnimation.isRemovedOnCompletion = false
        balloon.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
    }
}
