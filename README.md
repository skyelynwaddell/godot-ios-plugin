# Godot iOS Plugin
Integegrates Apple's GameKit, and StoreKit into your Godot Game!

## MINIMUM TARGET iOS VERSION : iOS 17
### SwiftGodot uses mimimum iOS 17 so that must be your minimum target to implement this plugin.

## Getting Started
First download the Release, or clone the repo.

If you clone the repo, go into the root of the folder and run the following command in terminal: 
(Once you compile the folder, it will be put into the /Bin/ios folder ...)
(IMPORTANT! BEFORE YOU compile the second one, rename the ios folder to debug or release respectively, or else it will get rewritten by the second build!)
```
./build.sh ios debug
>>> Then rename /ios to debug

./build.sh ios release
>>> Then rename /ios to release
```

Once you have compiled or download the release you should end up with a folder called godot_ios_plugin.
Next is to setup Godot!

## Setting up Godot
Create a `bin` folder in the root of your project.

From the release folder, or repo you cloned drag the following 4 files/folders into your Godot project's `bin` folder
```
godot_ios_plugin.gdextension
iOSPluginSingleton.gd
/release
/debug
```
(if you cloned the repo and built yourself, your release/debug folders will be in the Bin folder of the repo folder where you ran the commands)

## Adding Plugin
You will want to create an `addons` folder in your projects root directory, if it doesn't already exist.

Next you will drag the iOSPlugin folder from the repo folder into here.

You should end up with : /addons/iOSPlugin

## Enabling the Plugin
Go into your your project settings and under plugins enable iOS Plugin.
You should now be able to call any function from iOSPluginSingleton in your scripts.

example
```
iOSPluginSingleton.purchase("product_id_500_gems)
```

All functions to call on GameKit/StoreKit are in this autoload and are documented in detail which each function does and requires or callbacks.

## Testing
Does not work when running directly from Godot!! Must export to XCode!
Make sure your AppStoreConnect account is all setup, and when you export you must export to xcode with debug enabled in the export option and make sure you add the following entitlements in the App Signing and Capabilities section:
```
GameCenter
In-App Purchase
Sign-In with Apple
```

## Debuging
Once you do this you should see GameCenter pop up.
If it immedietly closes when it opens, make sure you are logged into your correct Sandbox account with Testing privelages (make sure you accepted the email invite from TestFlight)! 
Sometimes try RElogging into your correct account.
Make sure you have the correct Certificates for your App and your Team ID to export...
Make sure your accounts have all the correct privelages on AppStoreConnect and are developers, they must have rights to test purchase products under In App Products section on App Store Connect.

## Using the plugin
Call any of the functions from the iOSPluginSingleton script to initiate requests to GameKit/StoreKit !

## Thank you! I hope this plugin helps you!

