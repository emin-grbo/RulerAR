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
  
  var dotNodes = [SCNNode]()
  var textNode = SCNNode()
  var distance: Float = 0.0
  var lineNode: SCNNode?
  var dotOne = 0
  var dotTwo = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
  
  //MARK: - Adding a dot
  func addDot(at centreVector: SCNVector3) {
    
    let dot = SCNSphere(radius: 0.005)
    let dotMaterial = SCNMaterial()
    dotMaterial.diffuse.contents = UIColor.red
    dot.materials = [dotMaterial]
    
    let dotNode = SCNNode(geometry: dot)
    dotNode.position = centreVector

    sceneView.scene.rootNode.addChildNode(dotNode)
    dotNodes.append(dotNode)
    
    if dotNodes.count >= 2 {
      calculate()
      draw()
    }
  }
  
  //MARK: - Calculate distance
  func  calculate() {
    updateDots()
    let start = dotNodes[dotOne]
    let end = dotNodes[dotTwo]
    
    distance = start.position.distance(from: end.position)
    updateDistance(text: distance)
  }
  
  //MARK: - Draw the line
  func draw() {
    lineNode = getDrawnLineFrom(from: dotNodes[dotOne].position, to: dotNodes[dotTwo].position)
    sceneView.scene.rootNode.addChildNode(lineNode!)
  }
  
  //MARK: determine if closing dot
  func updateDots() {
    if dotNodes.count == 4 {
      distanceFinal()
      dotOne = 3
      dotTwo = 0
    } else {
      dotOne = dotNodes.endIndex - 2
      dotTwo = dotNodes.endIndex - 1
    }
  }
  
  //MARK final distance
  func distanceFinal() {
    let start = dotNodes[2]
    let end = dotNodes[3]
    dotOne = 3
    dotTwo = 2
    distance = start.position.distance(from: end.position)
    updateDistance(text: distance)
  }
  
  //MARK: - Adding a text overlay
  func updateDistance(text: Float) {
    
    let distanceCM = String(format: "%.2f cm", (text * 100))
    
    //MARK: 3D Text
    let textGeometry = SCNText(string: distanceCM, extrusionDepth: 0.1)
    textGeometry.firstMaterial?.diffuse.contents = UIColor.red
    textNode = SCNNode(geometry: textGeometry)
    
    //MARK: TextNode Position
    let node1 = dotNodes[dotOne].position
    let node2 = dotNodes[dotTwo].position
    
    textNode.position = SCNVector3((node2.x + node1.x)/2.0,
                                   (node2.y + node1.y)/2.0,
                                   (node2.z + node1.z)/2.0)
    
    //MARK: Text rotation to camera
    textNode.pivot = SCNMatrix4Rotate(textNode.pivot, Float.pi, 0, 1, 0)
    let lookAt = SCNLookAtConstraint(target: sceneView.pointOfView)
    lookAt.isGimbalLockEnabled = true
    textNode.constraints = [lookAt]
    
    //MARK: Text scale
    if let cameraDistance = sceneView.pointOfView?.position.z {
    let textScale = abs((node1.z - cameraDistance) / 150)
      print(textScale)
    textNode.scale = SCNVector3(textScale, textScale, textScale)
    }
    
    sceneView.scene.rootNode.addChildNode(textNode)
    
  }
  
  
  // MARK: - Showing line in real-time
  func renderer(_ renderer: SCNSceneRenderer,
                updateAtTime time: TimeInterval) {
    
    DispatchQueue.main.async {

      if self.dotNodes.isEmpty == false && self.dotNodes.count != 4 {
        guard let currentPosition = self.sceneView.realWorldVector(screenPos: self.sceneView.center),
              let placedNode = self.dotNodes.last?.position else {return}
        
        self.lineNode?.removeFromParentNode()
        
        self.lineNode = self.getDrawnLineFrom(from: placedNode,
                                               to: currentPosition)
        self.sceneView.scene.rootNode.addChildNode(self.lineNode!)
      } else {
        return
      }
    }
  }


  //MARK: - Button action
  @IBAction func addMarker(_ sender: Any) {
    
    // removing dots if more than 4
    if dotNodes.count >= 4 {
      sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
        node.removeFromParentNode() }
      dotNodes = [SCNNode]()
    }
    // converting CGpoint to SCNVector3
    if let vector = sceneView.realWorldVector(screenPos: sceneView.center){
      addDot(at: vector)
    }
}

  //MARK: - Delete ALL Nodes
  @IBAction func refreshBtn(_ sender: Any) {
    sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
      node.removeFromParentNode() }
  }
  
  
  
  
  
  
  
  
}


















