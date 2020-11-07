//
//  CountdownTimer.swift
//
//  Created by Rakesha Shastri on 19/01/18.
//

import Foundation

public class CountdownTimer: NSObject {
    
    lazy var timer: Timer? = {
        let timer = Timer()
        return timer
    }()
    
    public var duration: TimeInterval!
    var timeRemaining: TimeInterval!
    
    public var selector: Selector
    public var target: Any!
    
    var startTime: TimeInterval!
    var elapsedTime: TimeInterval!
    
    public override init() {
        self.duration = 2
        self.selector = #selector(dummySelector)
    }
    
    /// Standard initializer for ZTimer. Avoid using the default one unless you just want to check if the timer is working or have modified the code yourself.
    ///
    /// - Parameters:
    ///   - duration: timer duration
    ///   - selector: things to run after the timer expires
    ///   - target: location of selector
    public convenience init(duration: TimeInterval, selector: Selector, target: Any) {
        self.init()
        
        self.duration = duration
        self.timeRemaining = duration
        self.selector = selector
        self.target = target
    }
    
    /// Starts the timer.
    public func start() {
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: self.duration, target: self.target, selector: self.selector, userInfo: nil, repeats: false)
            self.startTime = Date.timeIntervalSinceReferenceDate
            debugPrint("TIMER STARTED Time Remaining -> \(String(describing: self.timeRemaining))")
        }
    }
    
    /// Pauses the timer.
    public func pause() {
        DispatchQueue.main.async {
            if self.timer == nil {
                debugPrint("TIMER MISSING! Did you forget to start it? Or is it already paused?")
                return
            }
            self.timer?.invalidate()
            self.timer = nil
            let currentTime = Date.timeIntervalSinceReferenceDate
            if self.startTime != nil {
                self.timeRemaining = self.timeRemaining - (currentTime - self.startTime)
            }
            debugPrint("TIMER PAUSED! Time Remaining -> \(String(describing: self.timeRemaining))")
        }
    }
    
    
    /// Resumes the timer. Picks up where the pause left off.
    public func resume() {
        DispatchQueue.main.async {
            self.startTime = Date.timeIntervalSinceReferenceDate
            self.timer = Timer.scheduledTimer(timeInterval: self.timeRemaining, target: self.target, selector: self.selector, userInfo: nil, repeats: false)
            debugPrint("TIMER RESUMED! Time Remaining - > \(String(describing: self.timeRemaining))")
        }
    }
    
    /// Ok this is something which actually worthy of a comment. In case you are using the timer to work with user interaction and you don't want the timer to run out in case the user pauses the timer close to it expiring. Then use this to have a pleasant delay.
    public func smartResume(duration: TimeInterval = 2) {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        if timeRemaining < 2 {
            timeRemaining = duration
        }
        resume()
    }
    
    /// Resets the timer or starts it if it doesn't exist.
    public func reset() {
        DispatchQueue.main.async {
            self.remove()
            self.start()
            debugPrint("TIMER RESTARTED! Time Remaining -> \(String(describing: self.timeRemaining))")
        }
    }
    
    /// Yea this is the method to cancel your timer. (Use in case something causes you do not want to run the action supposed to be run when the timer expires.)
    public func remove() {
        DispatchQueue.main.async {
            if self.timer == nil {
                debugPrint("TIMER MISSING. Did you forget to start it? Or is it paused?")
                return
            }
            self.timer?.invalidate()
            self.timer = nil
            debugPrint("TIMER REMOVED")
        }
    }
    
    @objc func dummySelector() {
        debugPrint("Timer countdown complete!")
    }
    
}
