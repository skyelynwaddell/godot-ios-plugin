// The Swift Programming Language

/// IMPORTANT LINKS REGARDING THIS PLUGIN
// https://docs.swift.org/swift-book
// https://migueldeicaza.github.io/SwiftGodotDocs/tutorials/swiftgodot/your-first-extension/
// https://github.com/rktprof/godot-ios-extensions
//https://www.youtube.com/watch?v=2dgP8eSlgAY&t=108s

import SwiftGodot
import GameKit
import StoreKit
import UIKit

#initSwiftExtension(
    cdecl: "swift_entry_point",
    types: [
        godot_ios_plugin.self
    ]
)

@Godot
class godot_ios_plugin : RefCounted {
    
    // Debug Message Signal
    #signal("_on_debug_message", arguments:["output": String.self])
    func _on_debug_message(message:String){
        let signal = SignalWith1Argument<String>("_on_debug_message")
        emit(signal:signal, message)
    }
    
    // On Purchase Success Signal
    #signal("_on_purchase_success", arguments:["output": String.self])
    func _on_purchase_success(sku:String){
        let signal = SignalWith1Argument<String>("_on_purchase_success")
        emit(signal:signal, sku)
    }
    
    // On Purchase Failed Signal
    #signal("_on_purchase_failed", arguments:["output": String.self])
    func _on_purchase_failed(sku:String){
        let signal = SignalWith1Argument<String>("_on_purchase_failed")
        emit(signal:signal, sku)
    }
    
    // On Login Success Signal
    #signal("_on_login_success", arguments:["output": String.self])
    func _on_login_success(){
        let signal = SignalWith1Argument<String>("_on_login_success")
        emit(signal:signal, "OK")
    }
        
    // On Login Failed Signal
    #signal("_on_login_failed", arguments:["output": String.self])
    func _on_login_failed(){
        let signal = SignalWith1Argument<String>("_on_login_failed")
        emit(signal:signal, "BAD")
    }
    
    // On Achievement Unlocked Signal
    #signal("_on_achievement_unlocked", arguments:["output": String.self])
    func _on_achievement_unlocked(achievementID:String){
        let signal = SignalWith1Argument<String>("_on_achievement_unlocked")
        emit(signal:signal, achievementID)
    }
        
    // On Achievement Unlocked Signal
    #signal("_on_achievement_incremented", arguments:["output": String.self])
    func _on_achievement_incremented(achievementID:String){
        let signal = SignalWith1Argument<String>("_on_achievement_incremented")
        emit(signal:signal, achievementID)
    }
    
    // On Leaderboard Updated Signal
    #signal("_on_leaderboard_updated", arguments:["output": String.self])
    func _on_leaderboard_updated(leaderboardID:String, score:Int){
        let signal = SignalWith1Argument<String>("_on_leaderboard_updated")
        emit(signal:signal, leaderboardID)
    }
    
    #if canImport(UIKit)
    var viewController : GameCenterViewController = GameCenterViewController()
    #endif
    
    
    /// Login Player to GameCenter (call this _on_ready() in godot
    @Callable
    func login() {
        print("iOS Plugin Logging Player into GameCenter...")
        
        let player = GKLocalPlayer.local
        
        if player.isAuthenticated {
            print("Already authenticated with GameCenter!")
            return
        }
        
        player.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                print("Error! Player couldn't login to GameCenter!")
                self._on_login_failed()
                return
            }
            
            if let viewController = vc {
                DispatchQueue.main.async {
                    viewController.present(vc!,animated:true,completion:nil)
                    print("Displaying login UI")
                }
                return
            }
            
            print("Player Logged in to Apple GameCenter!")
            self._on_login_success()
        }
    }
    
    /// Call this func _on_ready() after logging the player in so StoreKit can monitor transactions
    @Callable
    func monitor_transactions(){
        Task {
            do {
                for await verificationResult in Transaction.updates {
                    switch(verificationResult) {
                    case .verified(let transaction):
                        self._on_purchase_success(sku: transaction.productID)
                        print("Transaction verified!")
                        await transaction.finish()
                    case .unverified(let transaction, let error):
                        print("Transaction unverified")
                        self._on_purchase_failed(sku: transaction.productID)
                    }
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    
    /// Purchase a product by ProductID
    /// productID [String] : AppStoreConnect ProductID
    @Callable
    func purchase(sku:String) {
        FetchProduct(byProductID: sku) { product, error in
            if let error = error {
                print("Error fetching product \(error.localizedDescription)")
                return
            }
            
            if let product = product {
                print("Found product! \(product.displayName) price: \(product.displayPrice)")
                
                self.purchase_process(product: product, sku: sku) { result in
                    switch result {
                        case .success(let transaction):
                            print("Purchase success!")
                        case .failure(let error):
                            print("Purchase Failed!")
                    }
                }
            }
        }
    }
    
    /// Shows the GameCenter Dashboard
    @Callable
    func gamecenter_show(){
        #if canImport(UIKit)
        print("GameCenter Dashboard")
        let vc = GKGameCenterViewController(state: .dashboard)
        viewController.showUIController(vc)
        #endif
    }
    
    /// Shows the GameCenter Profile
    @Callable
    func gamecenter_profile(){
        #if canImport(UIKit)
        print("GameCenter Profile")
        let vc = GKGameCenterViewController(state: .localPlayerProfile)
        viewController.showUIController(vc)
        #endif
    }
    
    /// Shows GameCenter Friends
    @Callable
    func gamecenter_friends(){
        #if canImport(UIKit)
        print("GameCenter Friends")
        let vc = GKGameCenterViewController(state: .localPlayerFriendsList)
        viewController.showUIController(vc)
        #endif
    }
    
    /// Shows GameCenter Achievements
    @Callable
    func achievements_show(){
        #if canImport(UIKit)
        print("GameCenter Achievements")
        let vc = GKGameCenterViewController(state: .achievements)
        viewController.showUIController(vc)
        #endif
    }
    
    /// Unlocks an achievement by AchievementID and percent to complete the achievement
    /// achievementID [String] : AppStoreConnect Achievement ID
    /// percentComplette [Double / Float] : How much percent we should add to the total completion of the achievement
    @Callable
    func achievements_unlock(achievementID : String, percentComplete: Double, showCompletionBanner:Bool) {
        
        // Load the player's active achievements.
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            var achievement: GKAchievement? = nil
            
            // Find an existing achievement.
            achievement = achievements?.first(where: { $0.identifier == achievementID})
            
            // Otherwise, create a new achievement.
            if achievement == nil {
                achievement = GKAchievement(identifier: achievementID)
            }
            
            // Insert code to report the percentage.
            achievement?.percentComplete = (achievement?.percentComplete ?? 0) + percentComplete
            
            // Report achievement progress to Game Center
            let achievementsToReport : [GKAchievement] = [achievement!]
            
            GKAchievement.report(achievementsToReport, withCompletionHandler: {(error: Error?) in
                if error != nil {
                    print("Error: \(String(describing: error))")
                    return
                    
                }
            })
            
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
                return
            }
        })
        
        if percentComplete == 100.0 {
            self._on_achievement_unlocked(achievementID: achievementID)
        } else {
            self._on_achievement_incremented(achievementID: achievementID)
        }

        print("GameCenter achievement was successfully unlocked/progressed!")
    }
    
    /// Shows All GameCenter Leaderboards
    @Callable
    func leaderboard_show_all(){
        #if canImport(UIKit)
        print("GameCenter Displaying All Leaderboards")
        let vc = GKGameCenterViewController(state: .leaderboards)
        viewController.showUIController(vc)
        #endif
    }
    
    /// Shows the GameCenter UI for a specific Leaderboard
    /// leaderboardID [String] : AppStoreConnect Leaderboard ID
    @Callable
    func leaderboard_show(leaderboardID:String){
        #if canImport(UIKit)
        print("GameCenter Displaying Leaderboard #" + leaderboardID)
        let vc = GKGameCenterViewController(
            leaderboardID: leaderboardID,
            playerScope: .global,
            timeScope: .allTime
        )
        viewController.showUIController(vc)
        #endif
    }
    
    /// leaderboardID [String] : AppStoreConnect Product ID
    /// score [int] : How much score the player got
    /// classicMode [bool]  : If classic mode is set TRUE the player submits a Highscore, and only their highest score will be recorded in GameCenter. Like an old arcade game.
    /// If classicMode is set FALSE it will combine their new score submitted with their current score in the leaderboards. (ie if their current score was 30pts in the leaderboard, and you got 10pts, your leaderboard score would now be 40pts)
    /// (DEFAULT : FALSE)
    @Callable
    func leaderboard_update(leaderboardID:String, score: Int, classicMode:Bool=false) {
        
        print("Updating leaderboard score for #\(leaderboardID) with score: \(score)")
        var currentScore = 0
        
        //Validate player is currently logged into GameCenter
        if (PlayerIsAuthenticated() == false){
                print("User not logged into GameCenter, attempting to log them in...")
                self.login()
        }
        
        //Fetch our current score from the leaderboard
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardID]) { leaderboards, _ in
            leaderboards?[0].loadEntries(for: [GKLocalPlayer.local], timeScope: .allTime) {
                player, _, _ in
                currentScore = player?.score ?? 0
                
                var newScore = score + currentScore
                print("Updating our score to a total of: \(newScore)")
                
                GKLeaderboard.submitScore(newScore, context: 0, player: GKLocalPlayer.local,
                                          leaderboardIDs: [leaderboardID], completionHandler: { error in
                    if error != nil {
                        print("Error: \(error!.localizedDescription)")
                        return
                    }
                    print("Successfully updated leaderboard score")
                    self._on_leaderboard_updated(leaderboardID: leaderboardID, score: newScore)
                })
            }
        }
    }
    
    /// Return TRUE if the player is logged into GameCenter
    func PlayerIsAuthenticated() -> Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    /// Fetches product by AppStoreConnect ProductID
    /// productID [String] : AppStoreConnect ProductID
    func FetchProduct(byProductID productID:String, completion: @escaping (Product?, Error?) -> Void) {
        let productIDs: Set<String> = [productID]
        Task {
            do {
                let products = try await Product.products(for: productIDs)
                if let product = products.first(where: { $0.id == productID } ) {
                    completion(product,nil)
                    return
                }
                self._on_purchase_failed(sku: productID)
                completion(nil, NSError(domain: "StoreKit", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found !"]))
            } catch {
                self._on_purchase_failed(sku: productID)
                print(error.localizedDescription)
                completion(nil,error)
            }
        }
    }
    
    ///Purchase Processor
    ///Passes a product fetched from FetchProduct() and passes the SKU for completion
    ///product [Product] : Get it by called FetchProduct
    func purchase_process(product:Product, sku:String, completion: @escaping (Result<Transaction, Error>) -> Void) {
        Task {
            do {
                let result = try await product.purchase()
                
                switch result{
                    
                //PURCHASE SUCCESS
                case .success(let verificationResult):
                    switch verificationResult {
                        
                    //VERIFIED PURCHASE
                    case .verified(let transaction):
                        self._on_purchase_success(sku: sku)
                        completion(.success(transaction))
                        await transaction.finish()
                    
                    //UNVERIFIED PURCHASE
                    case .unverified(let transaction, let error):
                        self._on_purchase_failed(sku: sku)
                        completion(.failure(error ?? NSError(domain: "Purchase", code: -1, userInfo: nil)))
                    }
                
                //PURCHASE CANCELLED
                case .userCancelled:
                    self._on_purchase_failed(sku: sku)
                    completion(.failure(NSError(domain: "Purchase", code: 1, userInfo: [NSLocalizedDescriptionKey: "User cancelled purchase"])))
                
                //PURCHASE PENDING
                case .pending:
                    self._on_purchase_failed(sku: sku)
                    completion(.failure(NSError(domain: "Purchase", code: 2, userInfo: [NSLocalizedDescriptionKey: "Purchase is pending..."])))
                }
                
            } catch {
                self._on_purchase_failed(sku: sku)
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
        
}
