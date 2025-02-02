//
//  AppleSignInDelegate.swift
//  godot_ios_plugin
//
//  Created by Skye Waddell on 2025-02-02.
//
import AuthenticationServices

class AppleSignInDelegate : NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var onSuccess: ((String, String?) -> Void)?
    var onError : ((String) -> Void)?
    
    //Get the main window and present the Apple Sign In UI
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            print("Error getting window")
            fatalError("Error presenting UI Window!")
        }
        return window
    }
    
    //Apple Sign In Callback returned ERROR
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        onError?(error.localizedDescription)
    }
    
    //Apple Sign In Callback returned SUCCESS
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch(authorization.credential){
            
            //Valid Credentials
            case let credentials as ASAuthorizationAppleIDCredential:
                let id = credentials.user
                let email = credentials.email
            
                print("\(id) \(email)")
                
                UserDefaults.standard.set(id, forKey: "id")
                onSuccess?(id,email)
            
            //Invalid Credentials
            default:
                print("Authorization failed")
                onError?("Received unknown credential types.")
        }
    }
}
