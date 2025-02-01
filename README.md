# Godot iOS Plugin
Integegrates Apple's GameKit, StoreKit, and Firebase Push Notifications into your Godot Game!

## MINIMUM TARGET iOS VERSION : iOS 17
### SwiftGodot uses mimimum iOS 17 so that must be your minimum target to implement this plugin.

## Getting Started
Go into the root of the folder you downloaded/cloned and run the following command in terminal: 
(ALSO Once you compile the folder, it will be put into the /Bin/ios folder ...! 
BEFORE YOU compile the second one, rename the `ios` folder to `debug` or `release` respectively, or else it will get rewritten by the second build!)
```
./build.sh ios debug
>>> Once finished compiling rename folder ios to debug

./build.sh ios release
>>> Once finished compiling rename folder ios to release
```
You will end up with `/Bin/debug` and `/Bin/release` if done correctly.
Inside each folder they should both contain the following 2 files (`godot_ios_plugin.framework` and `SwiftGodot.framework`)

## Setting up Godot
Create a `bin` folder in the root of your godot 4.2 project.

From the repo you cloned drag the following 3 files/folders into your Godot project's `bin` folder
```
godot_ios_plugin.gdextension
/release
/debug
```
Your release/debug folders will be in the `Bin` folder of the repo folder where you ran the commands.

## Enabling the Plugin in Godot
You will want to create an `addons` folder in your projects root directory, if it doesn't already exist.

Next you will drag the iOSPlugin folder from the repo folder into here.

You should end up with : /addons/iOSPlugin

Go into your your project settings and under plugins enable iOS Plugin.
You should now be able to call any function from iOSPluginSingleton in your scripts.

example
```
iOSPluginSingleton.purchase("product_id_500_gems")
```

All functions to call on GameKit/StoreKit are in this autoload and are documented in detail which each function does and requires or callbacks.

## Testing
Does not work when running directly from Godot!! Must export to XCode!
Make sure your AppStoreConnect account is all setup, and when you export you must export to xcode with debug enabled in the export option and make sure you add the following entitlements in the App Signing and Capabilities section:
```
GameCenter
In-App Purchase
Sign-In with Apple
Wallet (optional?)
Apple Pay (optional?)
```

## Debuging
Once you do this you should see GameCenter pop up.
If it immedietly closes when it opens, make sure you are logged into your correct Sandbox account with Testing privelages (make sure you accepted the email invite from TestFlight)! 
Sometimes try RElogging into your correct account.
Make sure you have the correct Certificates for your App and your Team ID to export...
Make sure your accounts have all the correct privelages on AppStoreConnect and are developers, they must have rights to test purchase products under In App Products section on App Store Connect.

## Using the plugin
Call any of the functions from the iOSPluginSingleton script to initiate requests to GameKit/StoreKit !

## Enabling Push Notifications
Visit firebase and setup your project! 
Next goto the firebase console and visit messaging, setup your App for iOS.
Once you go through the process you will end up with a GoogleServices-Info.plist file.

Once you have this you can uncomment the line in the iOSPluginSingleton.gd that says `firebase_init()`

Once you export you project from Godot to XCode, you will have to drag this .plist file onto the root of your xcode project.

It will ask you if you want to copy the file, you can reference the file so it doesnt get leaked and then select your game as the target.

When you add the file to xcode you will have to enable the following Signings and Capabilities:
```
Push Notifications
Background Modes (Select Remote Notifications from the dropdown list after you select Background Modes)
```

Once you have enabled all that you should see your device token when you authenticate with firebase which you can store in a database or something for later communication with the device.

# Plugin Functions and Usage
Below lists all the signals that are called from iOS, and functions you can call from Godot to interact with GameKit, StoreKit, and Firebase.

# Signals Emitted from Apple to iOSPluginSingleton

<b>_on_debug_message(msg:String) -> void</b><br>
Returns general messages from Apple/Swift.

<b>_on_login_success() -> void</b><br>
Signal received when player succesfully logs into Game Center

<b>_on_login_failed() -> void</b><br>
Signal received when player fails to log into Game Center

<b>_on_firebase_login_success(deviceToken:String) -> void</b><br>
Signal received when a user is authenticated with Firebase and we receive their device token

<b>_on_achievement_unlocked(achievementID:String) -> void</b><br>
Signal received when GameCenter succesfully unlocks achievement

<b>_on_achievement_incremented(achievementID:String) -> void</b><br>
Signal received when a players achievement progress has been succesfully updated by AppStoreConnect

<b>_on_leaderboard_updated(leaderboardID:String) -> void</b><br>
Signal received when a users score in a leaderboard has been updated

<b>_on_purchase_success(sku:String) -> void</b><br>
Signal received when Google Play confirms a successful purchase (returns the product ID from AppStoreConnect)

<b>_on_purchase_failed(sku:String) -> void</b><br>
Signal received when GameCenter detected a failed purchase whether it was cancelled, or failed billing. (Returns product ID from AppStoreConnect)

# Functions you can call in Godot from the iOSPluginSingleton script to interact with GameCenter / StoreKit

<b>login() -> void</b><br>
Logs the player into GameCenter. Called at _on_ready() in the plugin by default.

<b>firebase_init() -> void</b><br>
Authenticates the player with firebase, on success emits `_on_firebase_login_success()` signal
Wont work if you didnt attach the GoogleServices-Info.plist file to your Xcode project before running.

<b>gamecenter_show() -> void</b><br>
Displays the GameCenter Dashboard to the player.

<b>gamecenter_profile() -> void</b><br>
Displays the GameCenter Player Profile to the player.

<b>gamecenter_friends() -> void</b><br>
Displays the GameCenter friendslist to the player.

<b>achievements_unlock(achievementID:String, percent:int) -> bool</b> <br>
Unlocks an achievement by AppStoreConnect Achievement ID, and if it is incremental it will progress the progress of the achievement by the indicated amount

<b>achievements_show() -> bool</b><br>
Opens the popup modal to show the GameCenter achievements

<b>leaderboard_show_all() -> bool</b><br>
Opens the popup modal and shows all leaderboards for the game.

<b>leaderboard_show(leaderboardID:String) -> bool</b><br>
Opens the popup modal to show AppStoreConnect Leaderboard by ID

<b>leaderboard_update(leaderboardID:String, score:int, classicMode:bool=false) -> bool</b><br>
Call to update a players score in the leaderboard.
If classic mode is set it will update the players score in the leaderboard only if it is their highest score.
If it is NOT classic mode, it will instead add the new score to their current score in the leaderboard.

<b>purchase(sku:String) -> bool</b><br>
Request a purchase to Apple StoreKit by Product ID found on AppStoreConnect

<b>validate_plugin() -> bool</b><br>
Returns true or false if the plugin is currently active and running on the current platform


## Thank you! I hope this plugin helps you!

