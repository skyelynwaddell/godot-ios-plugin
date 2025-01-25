#if canImport(UIKit)
import SwiftGodot
import GameKit
import UIKit

//Thank you to this because I could not figure out how to present the view properly.
//Thank you so much lol i tried for hours.
//https://github.com/rktprof/godot-ios-extensions/blob/main/Sources/GameCenter/GameCenterViewController.swift

class GameCenterViewController: UIViewController, GKGameCenterControllerDelegate {
    
    private var isViewControllerOpen = false
    
    func showUIController(_ viewController: GKGameCenterViewController) {
            
            // Make sure we don't try to open more than one view
            guard !isViewControllerOpen, let rootController = getRootController() else {
                print("Gamecenter UI already open")
                return
            }
            isViewControllerOpen = true
            viewController.gameCenterDelegate = self
            
            if let rootController = getRootController() {
                rootController.present(viewController, animated: true) { [weak self] in
                    self?.isViewControllerOpen = false
                }

            } else {
                print("showUIContoller() There was an error while trying to display the UIController")
            }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: { self.game_center_dismissed() })
    }

    func getRootController() -> UIViewController? {
        return getMainWindow()?.rootViewController
    }

    func getMainWindow() -> UIWindow? {
        // As seen on: https://sarunw.com/posts/how-to-get-root-view-controller/
        // NOTE: Does not neccessarily show in the correct window if there are multiple windows
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.windows
            .first(where: \.isKeyWindow)
    }
    
    func game_center_dismissed(){
        print("GameCenter UI Dismissed")
    }
}
#endif

// TODO: Implement NSViewController variant for macOS
