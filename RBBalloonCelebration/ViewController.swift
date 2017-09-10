//
//  ViewController.swift
//  RBBalloonCelebration
//
//  Created by Rohan on 09/09/17.
//  Copyright © 2017 RB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let balloonCelebrationView = RBCelebrationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(balloonCelebrationView)
        
        let dispatchTime = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: dispatchTime + 0.1) { [weak self] in
            self?.addRandomBalloons()
        }
    }
    
    override func viewWillLayoutSubviews() {
        balloonCelebrationView.frame = self.view.bounds
    }
    
    
    func addRandomBalloons() {
        balloonCelebrationView.startAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

