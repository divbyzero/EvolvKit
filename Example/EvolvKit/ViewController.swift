//
//  ViewController.swift
//  EvolvKit
//
//  Created by PhyllisWong on 07/03/2019.
//  Copyright (c) 2019 PhyllisWong. All rights reserved.
//

import UIKit
import SwiftyJSON
import EvolvKit


class ViewController: UIViewController {
  
  @IBOutlet weak var textLabel: UILabel!
  
  let store = DefaultAllocationStore(size: 1000)
  var allocations = [JSON]()
  var client : EvolvClientProtocol?
  let LOGGER = Log.logger
  
  @IBAction func didPressCheckOut(_ sender: Any) {
    var alloc = self.allocations
    let jsonString = "[{\"uid\":\"sandbox_user\",\"eid\":\"experiment_1\",\"cid\":\"candidate_3\",\"genome\":{\"ui\":{\"layout\":\"option_2\",\"buttons\":{\"checkout\":{\"text\":\"Begin Secure Checkout\",\"color\":\"#f3b36d\"},\"info\":{\"text\":\"Product Specifications\",\"color\":\"#f3b36d\"}}},\"search\":{\"weighting\":3.5}},\"excluded\":true}]"
    
    if let dataFromString = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
      do {
        alloc = try JSON(data: dataFromString).arrayValue
      } catch {
        LOGGER.log(.error, message: "OOPS!")
      }
    }
    self.textLabel.text = "Conversion!"
    let key = getJsonData()
    print("checked out")
  }
  
  @IBAction func didPressProductInfo(_ sender: Any) {
    self.textLabel.text = "Some really cool product info!"
  }
  
  // This is also necessary when extending the superclass.
  required init?(coder aDecoder: NSCoder) {
    let envId = "sandbox"
    let httpClient = EvolvHttpClient()
    let config = EvolvConfig.builder(environmentId: envId, httpClient: httpClient).setEvolvAllocationStore(allocationStore: store).build()
    let participant = EvolvParticipant.builder().setUserId(userId: "sandbox_user").build()
    print("\(participant)")
    client = EvolvClientFactory(config: config, participant: participant).client as! EvolvClientImpl
    client?.confirm()
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let statusBarView = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
    statusBarView.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.3, alpha: 1.0)
    let key = getJsonData()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

private extension ViewController {
  
  private func getJsonData() -> String {
    guard let client = self.client else { return "" }
    let key = "ui.buttons.checkout.color"
    // get this to execute on the main thread and change the UI
    func printStuff(value: Any) { print("DO STUFF with \(value)") }
    // Client makes the call to get the allocations
    client.subscribe(key: key, defaultValue: "#ffffff", function: printStuff)
    client.emitEvent(key: key, score: 1.0)
    // client.contaminate()
    return key
  }
}

