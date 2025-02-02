//
//  ToastMessage.swift
//  godot_ios_plugin
//
//  Created by Skye Waddell on 2025-02-02.
//

import UIKit

class ToastMessage {
    func showToast(message: String, duration: TimeInterval = 2.0) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first else { return }
        
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let textSize = toastLabel.intrinsicContentSize
        let padding: CGFloat = 20
        toastLabel.frame = CGRect(
            x: window.frame.width/2 - (textSize.width + padding)/2,
            y: window.frame.height - 100,
            width: textSize.width + padding,
            height: textSize.height + padding
        )
        
        window.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.5, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
}
