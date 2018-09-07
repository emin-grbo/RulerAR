//
//  LabelView.swift
//  RulerAR
//
//  Created by Emin Roblack on 9/3/18.
//  Copyright © 2018 emiN Roblack. All rights reserved.
//

import UIKit
import SceneKit

class SSLabelView: UIView {
  
  weak var labelNode: SSLabelNode!
  var blurView = UIVisualEffectView()
  var label = UILabel()
  
  // Initializing view with a node
  init(labelNode: SSLabelNode) {
    
    self.labelNode = labelNode
    // creating a frame/size for the view
    super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 65, height: 24)))
    
    
    // Adding a blur effect view
    blurView.effect = UIBlurEffect(style: .extraLight)
    self.addSubview(blurView)
    
    blurView.translatesAutoresizingMaskIntoConstraints = false
    blurView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    blurView.layer.cornerRadius = 12
    blurView.layer.masksToBounds = true
    
    
    // Adding a label to the view
    label.translatesAutoresizingMaskIntoConstraints = false
    blurView.contentView.addSubview(label)
  
    label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    label.textColor = UIColor.darkGray
    label.textAlignment = .center
    label.font.withSize(15)
    
    
    // Hardcodded text value
//    label.text = ""
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Init Coder has not been initialized")
  }
}

class SSLabelNode: SCNNode {
}
