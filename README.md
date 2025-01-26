# Godot iOS Plugin
Integegrates Apple's GameKit, and StoreKit into your Godot Game!

## MINIMUM TARGET iOS VERSION : iOS 17
### SwiftGodot uses mimimum iOS 17 so that must be your minimum target to implement this plugin.

## Getting Started
First download the Release, or clone the repo.

If you clone the repo, go into the root of the folder and run the following command in terminal: 
```
./build.sh ios debug
./build.sh ios release
```

Once you have compiled or download the release you should end up with a folder called godot_ios_plugin.
Next is to setup Godot!

## Setting up Godot
Create a `bin` folder in the root of your project
from the release folder, or repo you cloned drag the following 2 files into your godots bin folder
```
godot_ios_plugin.gdextension
iOSPluginSingleton.gd
```

Go into your repo/release folder and into the Bin folder.

Next you will want to select either debug or release folder for your target.

From the folder you choose, there will be 2 more folders inside called
```
godot_ios_plugin.framework
SwiftGodot.framework
```
drag these 2 files into your Godot's bin folder.

Finally inside of your bin folder is iOSPluginSingleton.gd
add this to your project's autoload singletons named iOSPluginSingleton

All functions to call on GameKit/StoreKit are in this autoload and are documented in detail which each function does and requires.

## Testing
Does not work when running directly from Godot!!!!!
Make sure your AppStoreConnect account is all setup, and when you export you must export to xcode with debug enabled in the export option and make sure you add the following entitlements in the App Signing and Capabilities section:
```
GameCenter
In-App Purchase
Sign-In with Apple
```

Once you do this you should see GameCenter pop up

## Using the plugin
