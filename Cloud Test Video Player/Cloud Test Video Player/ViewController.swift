//
//  ViewController.swift
//  Cloud Test Video Player
//
//  Created by Emil on 22/06/19.
//  Copyright © 2019 Oztra. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var videoView: PlayerView!
    
    var testCandites = getServicesToTest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preparePlayer()
    }
    
    func preparePlayer() {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = true
        player.volume = 0
        videoView.playerLayer.videoGravity = .resizeAspectFill
        videoView.player = player
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async {
            self.runTest(candidates: self.testCandites, iterations: 100)
            DispatchQueue.main.async {
                self.videoView.player!.pause()
            }
        }
    }
    
    func runTest(candidates: [ServiceModel], iterations: Int) {
        var results = prepareForTests(candidates: candidates, iterations: iterations)
        for iteration in 0..<iterations {
            print("Iteration \(iteration+1)/\(iterations)")
            candidates.forEach { model in
                let result = testModel(model)
                results[model.serviceName]![iteration] = result
            }
        }
        printCSVResults(results, iterations: iterations)
    }
    
    func printCSVResults(_ results: [String:[Double]], iterations: Int) {
        let headers = Array(results.keys)
        let rows = [String](repeating: "", count: iterations).enumerated().map { index, row -> String in
            var row = row
            for key in headers {
                row += "\(results[key]![index]),"
            }
            return row
        }
        print(headers.joined(separator: ","))
        print(rows.joined(separator: "\n"))
    }
    
    func prepareForTests(candidates: [ServiceModel], iterations: Int) -> [String:[Double]] {
        var results = [String:[Double]]()
        candidates.forEach { model in
            results[model.serviceName] = [Double](repeating: 0.0, count: iterations)
        }
        return results
    }
    
    func testModel(_ model: ServiceModel) -> TimeInterval {
        let testStart = Date()
        if testPlayModel(model) {
            return -testStart.timeIntervalSinceNow
        }
        return TimeInterval.nan
    }
    
    func testPlayModel(_ model: ServiceModel) -> Bool {
        let group = DispatchGroup()
        group.enter()
        var observer: Any! = nil
        DispatchQueue.main.sync {
            videoView.player!.replaceCurrentItem(with: AVPlayerItem(url: model.fileURL))
            videoView.player!.play()
            observer = videoView.player!.addBoundaryTimeObserver(forTimes: [NSValue(time: CMTime(value: 1, timescale: 60))], queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)) {
                group.leave()
            }
        }
        
        defer {
            DispatchQueue.main.sync {
                videoView.player!.removeTimeObserver(observer!)
            }
        }
        return group.wait(timeout: .now() + 4) == .success
    }
}

