#if canImport(UIKit)
import SwiftGodot
import GameKit
import UIKit

class GameCenterViewController: UIViewController, GKGameCenterControllerDelegate {

    func showUIController(_ viewController: GKGameCenterViewController) {
        do {
            
            // TODO: Make sure we don't try to open more than one view
            viewController.gameCenterDelegate = self
            
            // Delay the dispatch time of the UI incase it is busy
            let delayTime = DispatchTime.now() + .milliseconds(500)
            
            // Make sure to run this with a dispatchqueue on main thread with async!
            DispatchQueue.main.asyncAfter(deadline: delayTime) {
                do{
                    if self.getRootController()?.presentedViewController == nil {
                        try self.getRootController()?.present(viewController, animated: true, completion: {
                            print("Presenting UI")
                            return
                        })
                    } else {
                        print("Already presenting ui")
                        return
                    }
                }catch {
                    print("ERROR")
                    return
                }
            }
        } catch {
            print("error")
            return
        }
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: {
            print("Dissmissed the dang vc")
        })
    }

    func getRootController() -> UIViewController? {
        print(getMainWindow()?.rootViewController)
        return getMainWindow()?.rootViewController
    }

    func getMainWindow() -> UIWindow? {
        // As seen on: https://sarunw.com/posts/how-to-get-root-view-controller/
        // NOTE: Does not neccessarily show in the correct window if there are multiple windows
        var window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
            //.first?.windows
            //.first(where: \.isKeyWindow)
        
        print(window)
        return window
    }
}
#endif

// TODO: Implement NSViewController variant for macOS
