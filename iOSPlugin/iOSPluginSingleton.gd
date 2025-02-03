extends Node

var _ios_plugin : Variant = null

## This plugin utilizes SwiftGodot to incorporate GameKit and StoreKit API's.
### YOUR TARGET MINIMUM MUST BE iOS 17 MINIMUM ###

### SwiftGodot uses Godot 4.2 + only

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if str(OS.get_name().to_lower()) == "ios":
		if _ios_plugin == null && ClassDB.class_exists("godot_ios_plugin"):
			
			## Connect plugin to our variable
			_ios_plugin = ClassDB.instantiate("godot_ios_plugin")
			print("iOS Plugin connection established")
		
			if (validate_plugin()):
				## Signal connections that can be called from the iOS Plugin
				_ios_plugin.connect("_on_debug_message", _on_debug_message)
				
                		## GameCenter
				_ios_plugin.connect("_on_login_success", _on_login_success)
				_ios_plugin.connect("_on_login_failed", _on_login_success)
				_ios_plugin.connect("_on_achievement_unlocked", _on_achievement_unlocked)
				_ios_plugin.connect("_on_achievement_incremented", _on_achievement_incremented)
				_ios_plugin.connect("_on_leaderboard_updated", _on_leaderboard_updated)

                		## OAuth
				_ios_plugin.connect("_on_apple_sign_in_success", _on_apple_sign_in_success)
			
                		## StoreKit
				_ios_plugin.connect("_on_purchase_success", _on_purchase_success)
				_ios_plugin.connect("_on_purchase_failed", _on_purchase_failed)

                		## Firebase
				_ios_plugin.connect("_on_firebase_login_success", _on_firebase_login_success)
				
                		## Called _on_ready() to start GameKit & StoreKit
				_ios_plugin.login()
				_ios_plugin.monitor_transactions()

				## FIREBASE PUSH NOTIFICATIONS
				## To get the firebase device token to send push notifications to
				## Setup your Projcet on firebase and enable Messaging for iOS
				## Get your GoogleServices-Info.plist file.
				## Once you build your game for iOS in Godot
				## You can drag that .plist file onto the root of your xcode projet it will ask the target, select your game.

				## Once you doo all the above you can safely uncomment the below line to test Firebase

				#_ios_plugin.firebase_init() 
	
	## No plugin was found
	else: printerr("Couldn't find iOS plugin!")

## SIGNALS EMITTED FROM iOS

## Emitted when user logs into GameCenter
func _on_login_success(msg:String):
	print("User logged into GameCenter!")
	pass
	

# Emitted when a user successfully logs in with Sign In With Apple
func _on_apple_sign_in_success(id:String, email:String):
	print("Apple Sign In Success")
	print("ID: " + str(id))
	print("Email: " + str(email))
	pass


## Emitted when a user authenticates with firebase and returns a device token
func _on_firebase_login_success(deviceToken:String):
	print("Authenticated with Firebase. Device Token: " + str(deviceToken))
	pass


## Emitted when user unlocked achievement
func _on_achievement_unlocked(achievementID:String):
	print("Achievement Unlocked! " + str(achievementID))
	pass
	

## Emitted when user increments achievement progress by +1
func _on_achievement_incremented(achievementID:String):
	print("Achievement Incremented! " + str(achievementID))
	pass
	

## Emitted when a players event score is updated successfully
func _on_event_updated(eventID:String):
	print("Event was updated! " + str(eventID))
	pass
	

## Emitted when a players leaderboard score is updated successfullt
func _on_leaderboard_updated(leaderboardID:String, score:int):
	print("Leaderboard was updated! " + str(leaderboardID) + " " + str(score) + "pts")
	pass
	

## Emitted when player successfully purchases an item through Google
func _on_purchase_success(sku:String):
	print("Purchase on Product ID #" + str(sku) + " SUCCESS!")
	pass


## Emitted when player fails a purchase request to Google
func _on_purchase_failed(purchaseJSON:String):
	print("Purchase on Product ID #" + str(purchaseJSON) + " FAILED!")
	pass


## Emitted when Swift calls a debug message
func _on_debug_message(msg:String):
	print(msg)
	pass

## FUNCTIONS TO CALL TO INTERACT WITH iOS

## Validates the plugin is running in the game
func validate_plugin() -> bool:
	if _ios_plugin: 
		print("validated plugin")
		return true
	print("plugin was not found")
	return false


## Shows a native iOS Toast/Popup Message
func toast_maketxt(message:String):
	if _ios_plugin:
		_ios_plugin.toast_maketxt(message)
		return true
	return false


## Shows the GameCenter Dashboard
func gamecenter_show() -> bool: 
	if validate_plugin():
		_ios_plugin.gamecenter_show()
		return true
	return false


## Shows player's GameCenter Profile
func gamecenter_profile() -> bool: 
	if validate_plugin():
		_ios_plugin.gamecenter_profile()
		return true
	return false


## Shows GameCenter Friends
func gamecenter_friends() -> bool: 
	if validate_plugin():
		_ios_plugin.gamecenter_friends()
		return true
	return false


## Shows all Achievements
func achievements_show() -> bool: 
	if validate_plugin():
		_ios_plugin.achievements_show()
		return true
	return false


## Unlocks Achievement by ID
## achievementID [String] : AppStoreConnect Achievement ID
func achievements_unlock(achievementID:String, percentage:float) -> bool:
	if validate_plugin():
		_ios_plugin.achievements_unlock(achievementID,percentage,false)
		return true
	return false


## Shows all leaderboards
func leaderboard_show_all() -> bool: 
	if validate_plugin():
		_ios_plugin.leaderboard_show_all()
		return true
	return false


## Shows a specific leaderboard by ID
## leaderboardID [String] : AppStoreConnect Leaderboard ID
func leaderboard_show(leaderboardID:String) -> bool: 
	if validate_plugin():
		_ios_plugin.leaderboard_show(leaderboardID)
		return true
	return false


## Updates a leaderboard by Leaderboard and Score
## leaderboardID [String] : AppStoreConnect leaderboard ID
## score [int] : the score to be submitted to the leaderboard
## classicMode [bool] : If classic mode is set TRUE the player submits a Highscore, and only their highest score will be recorded in GameCenter. Like an old arcade game.
## If classicMode is set FALSE it will combine their new score submitted with their current score in the leaderboards. (ie if their current score was 30pts in the leaderboard, and you got 10pts, your leaderboard score would now be 40pts)
## (DEFAULT : FALSE)
func leaderboard_update(leaderboardID:String, score:int, classicMode:bool=false) -> bool:
	if validate_plugin():
		_ios_plugin.leaderboard_update(leaderboardID,score)
		return true
	return false


## Sends a purchase request to Apple (On fail/success it will emit the signals _on_purchase_success or _on_purchase_failed respectively)
## productID [String] : AppStoreConnect Product ID
func purchase(productID:String) -> bool:
	if validate_plugin():
		_ios_plugin.purchase(productID)
		return true
	return false
