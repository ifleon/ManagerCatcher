//
//  ManagerCatcherTests.swift
//  ManagerCatcherTests
//
//  Created by Fredy Leon on 25/07/2020.
//  Copyright © 2020 Fredy Leon. All rights reserved.
//

import XCTest
@testable import ManagerCatcher

class ManagerCatcherTests: XCTestCase {
    
    //@Cache(.user)
    //var nameUser: String?
    var timerExpectation = 5.0
    var loginStatus: MemoryCacheManager?
    

    override func setUpWithError() throws {
        continueAfterFailure = false
        self.loginStatus = MemoryCacheManager()
        self.loginStatus!.put(true, forKey: "loginStatusKey", secondsToExpire: 60.0, scope: CacheScope.user.rawValue)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        loginStatus = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    func testSessionUserLogin(){

        //nameUser = "leono"
        let exp = expectation(description: "Test after \(timerExpectation) seconds")
        let result = XCTWaiter.wait(for: [exp], timeout: timerExpectation)
        
        //cambiar de estado
        //self.loginStatus!.put(false, forKey: "loginStatusKey")
        
        if result == XCTWaiter.Result.timedOut {
            let statusLoginUser = self.loginStatus?.value(forKey: "loginStatusKey", type: Bool.self)
            XCTAssertNotNil(statusLoginUser, "Usurio no tiene sesion")
            XCTAssertTrue(statusLoginUser!, "Usuario logueado")
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
