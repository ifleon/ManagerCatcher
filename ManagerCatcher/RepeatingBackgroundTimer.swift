//
//  Created by administrador on 01/05/2020.
//  Copyright © 2020 administrador. All rights reserved.
//

import Foundation


public class RepeatingBackgroundTimer {
    
    let seconds: TimeInterval
    let repeatingSeconds: TimeInterval
    
    convenience init(seconds: TimeInterval, eventHandler: (() -> Void)? = nil) {
        self.init(seconds: seconds, repeatingSeconds: seconds, eventHandler: eventHandler)
    }
    
    init(seconds: TimeInterval, repeatingSeconds:TimeInterval, eventHandler: (() -> Void)? = nil) {
        self.seconds = seconds
        self.repeatingSeconds = repeatingSeconds
        self.eventHandler = eventHandler
        self.resume()
    }
    
    private lazy var timer: DispatchSourceTimer = {
        let t = DispatchSource.makeTimerSource()
        t.schedule(deadline: .now() + self.seconds, repeating: self.repeatingSeconds)
        t.setEventHandler(handler: { [weak self] in
            self?.eventHandler?()
        })
        return t
    }()
    
    public var eventHandler: (() -> Void)?
    
    private enum State {
        case suspended
        case resumed
    }
    
    private var state: State = .suspended
    
    deinit {
        timer.setEventHandler {}
        timer.cancel()
        /*
         If the timer is suspended, calling cancel without resuming
         triggers a crash. This is documented here https://forums.developer.apple.com/thread/15902
         */
        resume()
        eventHandler = nil
    }
    
    public func resume() {
        if state == .resumed {
            return
        }
        state = .resumed
        timer.resume()
    }
    
    public func suspend() {
        if state == .suspended {
            return
        }
        state = .suspended
        timer.suspend()
    }
}
