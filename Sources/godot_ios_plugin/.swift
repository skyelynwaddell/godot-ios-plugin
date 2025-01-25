//
//  gamecenter.swift
//  godot_ios_plugin
//
//  Created by Skye Waddell on 2025-01-23.
//

import UIKit
import GameKit

class GameCenter: UIViewController, GKGameCenterControllerDelegate {
    
    var godotPlugin = godot_ios_plugin.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func gamecenter_show(){
        let gameCenterVC = GKGameCenterViewController()
        gameCenterVC.gameCenterDelegate = self
        self.present(gameCenterVC,animated: true,completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        godotPlugin._on_game_center_dismissed()
    }
}
