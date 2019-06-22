//
//  PlayerView.swift
//  Cloud Test Video Player
//
//  Created by Emil on 22/06/19.
//  Copyright © 2019 Oztra. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
}


