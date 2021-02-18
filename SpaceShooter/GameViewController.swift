//
//  GameViewController.swift
//  SpaceShooter
//
//  Created by Sai Balaji on 18/02/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var sv: UIStackView!
    @IBOutlet weak var gametitlelbl: UILabel!
    @IBOutlet weak var playbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playbtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        playbtn.layer.cornerRadius = 3.0
        playbtn.layer.borderWidth = 3
        
      
    }

    @IBAction func plybtnpressed(_ sender: UIButton) {
        
        playbtn.isHidden = true
        gametitlelbl.isHidden = true
        sv.isHidden = true
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
         //   view.showsFPS = true
        //    view.showsNodeCount = true
        }
        
    }
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
