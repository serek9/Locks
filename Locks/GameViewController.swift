//
//  GameViewController.swift
//  Locks
//
//  Created by Sergio Díaz on 5/5/17.
//  Copyright (c) 2017 Sergio Díaz. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MusicHelper.sharedHelper.playBackgroundMusic()
        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "spacev.jpg")!)
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.backgroundColor = UIColor(patternImage: UIImage(named: "spacev.jpg")!)
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
