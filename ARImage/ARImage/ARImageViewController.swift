//
//  ARImageViewController.swift
//  ARImage
//
//  Created by ios dev on 2019/2/28.
//  Copyright © 2019 iosdevlog. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARImageViewController: UIViewController, ARSCNViewDelegate {

    var iPhoneXNode = SCNNode()

    @IBOutlet var sceneView: ARSCNView!

    @IBAction func placeScreenButtonTapped(_ sender: UIButton) {
        iPhoneXNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Device.scnassets/AR-Screen")
    }

    @IBAction func plusButtonTapped(_ sender: UIButton) {
        let scalePlus = SCNAction.scale(by: 2, duration: 2)
        iPhoneXNode.runAction(scalePlus)
    }

    @IBAction func minusButtonTapped(_ sender: UIButton) {
        let scaleMinus = SCNAction.scale(by: 0.5, duration: 2)
        iPhoneXNode.runAction(scaleMinus)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()

        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) else { return }

        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()

        if anchor is ARImageAnchor {
            let plane = SCNPlane(width: 0.7, height: 0.35)
            let deviceScene = SKScene(fileNamed: "DeviceScene")

            plane.firstMaterial?.diffuse.contents = deviceScene
            plane.firstMaterial?.isDoubleSided = true
            plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)

            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2

            let iPhoneScene = SCNScene(named: "Device.scnassets/iPhoneX.scn")!
            let iPhoneNode = iPhoneScene.rootNode.childNodes.first!
            iPhoneNode.position = SCNVector3(0, 0, 0.15)

            let min = iPhoneNode.boundingBox.min
            let max = iPhoneNode.boundingBox.max
            iPhoneNode.pivot = SCNMatrix4MakeTranslation(
                min.x + (max.x - min.x) / 2,
                min.y + (max.y - min.y) / 2,
                min.z + (max.z - min.z) / 2)

            node.addChildNode(planeNode)
            planeNode.addChildNode(iPhoneNode)

            iPhoneNode.runAction(rotateObject())
            let animator = SCNAction.scale(by: 10, duration: 3)
            iPhoneNode.runAction(animator)

            let iPhoneLight = iPhoneScene.rootNode.childNodes.filter({ $0.name == "spot" }).first!
            planeNode.addChildNode(iPhoneLight)

            iPhoneXNode = iPhoneNode
        }

        return node
    }

    // MARK: - Helper
    func rotateObject() -> SCNAction {
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(GLKMathDegreesToRadians(360)), z: 0, duration: 3)
        let repeatAction = SCNAction.repeatForever(action)
        return repeatAction
    }
}
