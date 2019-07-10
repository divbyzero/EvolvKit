//
//  Audience.swift
//  EvolvKit_Example
//
//  Created by phyllis.wong on 7/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Function {
  associatedtype A
  associatedtype B
  func apply(one: A, two: B) -> Bool
}

public class Audience {
  
  public init () {}
  
  // fileprivate var operators: Dictionary<String , Function> = createOperatorsMap()
  
  func createOperatorsMap() {
    var operatorsDict = Dictionary <String, AnyObject>()
    // "exists" checks that a property detailed in the audience query exists in the participant's user attributes. Then it returns true or false depending on what it finds
    
  }
  
  fileprivate func evaluateAudienceFilter(_ userAttributes: Dictionary<String, String>,
                                          _ rule: JSON) -> Bool {
    
    // Create a switch statement
    let fakeBool = false
    let flattened = rule.map {(key, value) in
      return (key.capitalized)
    }
    for (key,subJson):(String, JSON) in rule {
      // Do something you want
      print("key: \(key), subJson: \(subJson)")
    }
    
//    let op = rule["operator"] as String
//    for r in flattened {
//      if r == "operator" {
//        // operator was found
//        // apply userAttributes with rule["value"]
//      } else {
//        // operator was not found
//      }
//    // if rule
//    }
    return fakeBool
  }
  
  fileprivate func evaluateAudienceRule(userAttributes: Dictionary<String, String>,
                                        audienceQuery: JSON, rule: JSON) -> Bool {
    
    let flattened = rule.map {(key, value) in
      return (key.capitalized)
    }
    for r in flattened {
      if r == "combinator" {
        return evaluateAudienceQuery(userAttributes, rule)
      }
    }
    return evaluateAudienceFilter(userAttributes, rule)
  }
  
  // TODO: get an example of what this jsonObj can look like
  fileprivate func evaluateAudienceQuery(_ userAttributes: Dictionary<String, String>,
                                         _ audienceQuery: JSON) -> Bool {
    let bool = false
    
    let rules = audienceQuery["rules"] as AnyObject
    
    if nullToNil(value: rules) == nil {
      return true
    }
    
    let rulesArr = rules.values
//    for r in rulesArr {
//      let passed = evaluateAudienceRule(userAttributes, audienceQuery, r)
//    }
    
    return bool
  }
  
  /**
   Determines whether on not to filter the user based upon the supplied user attributes and allocation.
   - Parameters:
   - userAttributes: dictionary representing attributes that represent the participant. CANNOT be nil.
   - allocation: allocation containing the participant's treatment(s).
   - excluded: could property could be false or 0, true or 1
   - Returns: true if participant should be filtered, false if not
  */
  public func filter(userAttributes: Dictionary<String, String>, allocation: JSON) -> Bool {
    let excluded = allocation["excluded"]
    let audienceQuery = allocation["audience_query"]
    let excludedIsNull = nullToNil(value: excluded as AnyObject)
    let audienceQueryIsNull = nullToNil(value: audienceQuery as AnyObject)
    
    if  excludedIsNull != nil && (excluded == "true" || excluded == 1) {
      return true
    }
    if audienceQueryIsNull == nil || audienceQuery.isEmpty || userAttributes.values.count == 0 {
      return false
    }
    return !evaluateAudienceQuery(userAttributes, audienceQuery)
  }

}

extension Audience {
  func nullToNil(value : AnyObject?) -> AnyObject? {
    if value is NSNull {
      return nil
    } else {
      return value
    }
  }
}

