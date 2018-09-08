//
//  ViewController.swift
//  RulerAR
//
//  Created by Emin Roblack on 8/15/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

  @IBOutlet var sceneView: ARSCNView!
  @IBOutlet weak var surfaceLabel: UILabel!
  
  var ssViews: [SSLabelView] = []
  var dotNodes = [SCNNode]()
  //var textNode = SCNNode()
  var lineNode: SCNNode?
  var dotOne = 0
  var dotTwo = 1
  var unitSwitcher: CustomSwitch = CustomSwitch()
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    unitSwitcher = CustomSwitch(frame: CGRect(x: view.frame.width/2 + 75,
                                                  y: view.frame.height - 86,
                                                  width: 50,
                                                  height: 25))
    self.view.addSubview(unitSwitcher)
    unitSwitcher.addTarget(self, action: #selector(self.unitSwitchPressed(_:)) , for: .touchUpInside)

    // Set the view's delegate
    sceneView.delegate = self
    sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    
    // Run the view's session
    sceneView.session.run(configuration)
    
    // Session Delegate
    sceneView.session.delegate = self
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
  }
  

  //MARK: - Button action
  @IBAction func addMarker(_ sender: Any) {
    
    // removing dots if more than 4
    if dotNodes.count >= 4 {
      purge()
    }
    // converting CGpoint to SCNVector3
    if let vector = sceneView.realWorldVector(screenPos: sceneView.center){
      addDot(at: vector)
    }
  }
  
  
  //MARK: - Delete ALL Nodes
  @IBAction func refreshBtn(_ sender: Any) {
    purge()
  }
  
  @objc func unitSwitchPressed(_ sender: Any) {
    
    for view in ssViews {
      guard let labelnumber = view.label.text?.dropLast(2),
        let number = Float(labelnumber) else {return}
      
      if unitSwitcher.isOn == true {
        let centimeters = String(format: "%.1fcm", (number * 2.54))
        view.label.text = String(centimeters)
      } else if unitSwitcher.isOn == false {
        let inches = String(format: "%.1f''", (number * 0.393700787402))
        view.label.text = String(inches)
      }
    }
    
  }
  
  
}


















