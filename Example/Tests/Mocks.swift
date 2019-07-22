//
//  Mocks.swift
//  EvolvKit_Tests
//
//  Created by phyllis.wong on 7/16/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest
import Alamofire
import SwiftyJSON
import PromiseKit
@testable import EvolvKit

class Mocks: XCTestCase { }

class AllocationStoreMock: AllocationStoreProtocol {
  
  let testCase: XCTestCase
  
  init (testCase: XCTestCase) {
    self.testCase = testCase
  }
  
  var expectGetExpectation: XCTestExpectation?
  var expectPutExpectation : XCTestExpectation?
  
  private var mockedGet: (String) -> [JSON] = { _ in
    // XCTFail("unexpected call to set")
    return []
  }
  
  private var mockedPut: (String, [JSON]) -> Void = { _,_  in
    XCTFail("unexpected call to set")
  }
  
  
  @discardableResult
  func expectGet(_ mocked: @escaping (_ uid: String) -> [JSON]) -> XCTestExpectation {
    self.expectGetExpectation = self.testCase.expectation(description: "expect get")
    self.mockedGet = mocked
    return expectGetExpectation!
  }

  func expectPut(_ mocked: @escaping (_ uid: String, _ allocations: [JSON]) -> Void) -> XCTestExpectation {
    self.expectPutExpectation = self.testCase.expectation(description: "expect put")
    self.mockedPut = mocked
    return expectPutExpectation!
  }
  
  // conform to protocol
   @discardableResult
  func get(uid: String) -> [JSON] {
    self.expectGetExpectation?.fulfill()
    return mockedGet(uid)
  }

  func put(uid: String, allocations: [JSON]) {
    self.expectGetExpectation?.fulfill()
    return mockedPut(uid, allocations)
  }
}

class ClientFactoryMock : EvolvClientFactory {
  
}

class HttpClientMock: HttpProtocol {
  public static var httpClientSendEventsWasCalled = false
  
  @discardableResult
  func get(url: URL) -> Promise<String> {
    HttpClientMock.httpClientSendEventsWasCalled = true
    return Promise<String> { resolver -> Void in
      
      Alamofire.request(url)
        .validate()
        .responseString { response in
          switch response.result {
          case .success( _):
            
            if let responseString = response.result.value {
              
              resolver.fulfill(responseString)
            }
          case .failure(let error):
            
            resolver.reject(error)
          }
      }
    }
  }
  
  func sendEvents(url: URL) {
    HttpClientMock.httpClientSendEventsWasCalled = true
    let headers = [
      "Content-Type": "application/json",
      "Host" : "participants.evolv.ai"
    ]
    
    Alamofire.request(url,
                      method      : .get,
                      parameters  : nil,
                      encoding    : JSONEncoding.default ,
                      headers     : headers).responseData { dataResponse in
                        
                        
                        if dataResponse.response?.statusCode == 202 {
                          print("All good over here!")
                        } else {
                          print("Something really bad happened")
                        }
    }
  }
}

class EmitterMock : EventEmitter {
  
  let httpClientMock = HttpClientMock()
  
  override func sendAllocationEvents(_ key: String, _ allocations: [JSON]) {
    let eid = allocations[0]["eid"].rawString()!
    let cid = allocations[0]["cid"].rawString()!
    let url = createEventUrl(type: key, experimentId: eid, candidateId: cid)
    makeEventRequest(url)
  }
  
  private func makeEventRequest(_ url: URL) -> Void {
    let _ = httpClientMock.sendEvents(url: url)
  }
  
  override public func contaminate(allocations: [JSON]) -> Void {
    self.sendAllocationEvents(CONTAMINATE_KEY, allocations)
  }
  
  override public func confirm(allocations: [JSON]) -> Void {
    self.sendAllocationEvents(CONFIRM_KEY, allocations)
  }
  
  override public func emit(_ key: String) -> Void {
    let url: URL = createEventUrl(type: key, score: 1.0)
    self.makeEventRequest(url)
  }
  
  override public func emit(_ key: String, _ score: Double) -> Void {
    let url: URL = createEventUrl(type: key, score: score)
    self.makeEventRequest(url)
  }
  
}

class ExecutionQueueMock : ExecutionQueue {
  
  var executeAllWithValuesFromAllocationsWasCalled = false
  var executeAllWithValuesFromDefaultsWasCalled = false
  
  override func executeAllWithValuesFromAllocations(allocations: [JSON]) {
    self.count -= 1
    executeAllWithValuesFromAllocationsWasCalled = true
  }
  
  override func executeAllWithValuesFromDefaults() {
    self.count -= 1
    executeAllWithValuesFromDefaultsWasCalled = true
  }
}

class ExecutionMock<T>: Execution<T> {
  
  override func executeWithDefault() {}
  
  override func executeWithAllocation(rawAllocations: [JSON]) throws {}
}



class ConfigMock: EvolvConfig { }

class ClientHttpMock: HttpProtocol {
  func get(url: URL) -> Promise<String> {
    fatalError()
  }
  
  func sendEvents(url: URL) {
    fatalError()
  }
}