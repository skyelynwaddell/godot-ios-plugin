# Godot iOS Plugin
Integegrates Apple's GameKit, and StoreKit into your Godot Game!

## MINIMUM TARGET iOS VERSION : iOS 17
### SwiftGodot uses mimimum iOS 17 so that must be your minimum target to implement this plugin.

## Getting Started
First download the Release, or clone the repo.

If you clone the repo, go into the root of the folder and run the following command in terminal: 
```
./build.sh debug debug
./build.sh release release
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

Inside of your bin folder is `iOSPluginSingleton.gd`
add this to your project's autoload singletons named `iOSPluginSingleton`

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

