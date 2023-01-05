//: [Previous](@previous)

/*:
 - Note:
 Please disable *Enable results* for the playground to work
 */

//: [Next](@next)


import PlaygroundSupport
import SpriteKit
import ARKit
import SceneKit


class MainView:  UIViewController,ARSCNViewDelegate, ARSessionDelegate{
    //initializing variables
    var sceneView: ARSCNView!
    let session = ARSession()
    var grids = [Grid]()
    var taps = 0
    var startPoint: SCNVector3!
    var endPoint: SCNVector3!
    var honeyCombPlaced = false
    var combNode = SCNNode()
    var currentFlower = SCNNode()
    var flowerList = [SCNNode]()
    let markerBtn = SCNNode()
    let waggleBtn = SCNNode()
    let roundBtn = SCNNode()
    var chosenDist = Float.zero
    let beeSound = SCNAudioSource(fileNamed: "Bee-noise.mp3")
    var markerList = [SCNNode]()
    
    override func viewDidLoad() {
        
        sceneView = ARSCNView(frame: CGRect(x: 0.0, y: 0.0, width: 500.0, height: 600.0))
                   
        let scene = SCNScene()
        sceneView.scene = scene
                   
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]

        // set up scene view
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session = session
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                 ARSCNDebugOptions.showWorldOrigin
                               ]

        sceneView.showsStatistics = true

        // Now we'll get messages when planes were detected...
        sceneView.session.delegate = self

        // default lighting
        sceneView.autoenablesDefaultLighting = true
        // a camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 3)
        scene.rootNode.addChildNode(cameraNode)
        self.view = sceneView
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
        
        
        //enabling scene lights
        sceneView.autoenablesDefaultLighting = true
        currentFlower.name == "nil"
        let buttonGeo = SCNPlane(width: 0.001, height: 0.001)
        buttonGeo.cornerRadius = 0.0001
        waggleBtn.geometry = buttonGeo
        waggleBtn.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "waggle.png")
        waggleBtn.name = "waggle"
        waggleBtn.position=SCNVector3(0.0008, -0.0025, -0.01)
        sceneView.pointOfView?.addChildNode(waggleBtn)
        
        let button1Geo = SCNPlane(width: 0.001, height: 0.001)
        button1Geo.cornerRadius = 0.0001
        roundBtn.geometry = button1Geo
        roundBtn.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "round.png")
        roundBtn.name = "round"
        roundBtn.position=SCNVector3(0.000, -0.0025, -0.01)
        sceneView.pointOfView?.addChildNode(roundBtn)
        
        let button2Geo = SCNPlane(width: 0.001, height: 0.001)
        button2Geo.cornerRadius = 0.0001
        markerBtn.geometry = button2Geo
        markerBtn.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "marker.png")
        markerBtn.name = "marker"
        markerBtn.position=SCNVector3(-0.0008, -0.0025, -0.01)
        markerBtn.scale = SCNVector3(0.75, 0.75, 0.75)
        sceneView.pointOfView?.addChildNode(markerBtn)
        
        //giving pov a name
        self.sceneView.pointOfView?.name = "pov"
        
        combNode.name = "notComb"
        beeSound?.loops = true
        beeSound?.load()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let grid = Grid(anchor: anchor as! ARPlaneAnchor)
        self.grids.append(grid)
        node.addChildNode(grid)
        //add a flower only if honeycomb is placed
        if honeyCombPlaced{
            var planePoint=CGPoint(x: sceneView.frame.size.width / 2, y: sceneView.frame.size.height / 2)
            let hitTestResults = sceneView.hitTest(planePoint, types: .existingPlaneUsingExtent)
             guard let hitTest = hitTestResults.first else {
                return
                }
            placeFlower(hitTest: hitTest)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //update grid
        let grid = self.grids.filter { grid in
            return grid.anchor.identifier == anchor.identifier
        }.first

        guard let foundGrid = grid else {
            return
        }
        foundGrid.update(anchor: anchor as! ARPlaneAnchor)
        //place flower if honeyComb is placed
        if honeyCombPlaced{
            var planePoint=CGPoint(x: sceneView.frame.size.width / 2, y: sceneView.frame.size.height / 2)
            let hitTestResults = sceneView.hitTest(planePoint, types: .existingPlaneUsingExtent)
             guard let hitTest = hitTestResults.first else {
                return
                }
            placeFlower(hitTest: hitTest)
        }
        
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        taps+=1
        // Get 2D position of touch event on screen
        let touchPosition = gesture.location(in: sceneView)
        let results = sceneView.hitTest(touchPosition, options: nil)
        
        for result in results {
            switch result.node.name{
            case "waggle":
                let node = sceneView.pointOfView?.childNode(withName: "waggle", recursively: false)
                //check distance of marker from honeycomb
                if chosenDist.metersToInches()>50 && chosenDist != Float.zero{
                    let other = sceneView.pointOfView?.childNode(withName: "round", recursively: false)
                    other?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "round.png")
                    node?.runAction(SCNAction.rotateBy(x: 2*(.pi), y: 0, z: 0, duration: 1.0))
                    // if correct carry out waggle animation
                    animateBeeCorrect(type: "waggle", correct: true)
                }else{
                    node?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "waggle.png")
                    node?.runAction(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 0.5),SCNAction.rotateBy(x: 0, y: -(.pi), z: 0, duration: 0.5)]))
                    // if wrong carry out wrong waggle animation
                    animateBeeCorrect(type: "waggle", correct: false)
                }
                
            case "round":
                let node = sceneView.pointOfView?.childNode(withName: "round", recursively: false)
                if chosenDist.metersToInches()<=50 && chosenDist != Float.zero{
                    //check if option chosen is correct
                    let other = sceneView.pointOfView?.childNode(withName: "waggle", recursively: false)
                    other?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "waggle.png")
                    node?.runAction(SCNAction.rotateBy(x: 2*(.pi), y: 0, z: 0, duration: 1.0))
                    //if correct show correct animation
                    animateBeeCorrect(type: "round", correct: true)
                }else{
                    node?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "round.png")
                    node?.runAction(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: .pi, z: 0, duration: 0.5),SCNAction.rotateBy(x: 0, y: -(.pi), z: 0, duration: 0.5)]))
                    //show wrong animation
                    animateBeeCorrect(type: "round", correct: false)
                }
            case "mssg":
                //scale down and disappear
                let node = sceneView.scene.rootNode.childNode(withName: "mssg", recursively: true)!
                node.runAction(SCNAction.scale(to: 0, duration: 1.0)) {
                    node.removeFromParentNode()
                    for child in self.sceneView.scene.rootNode.childNodes{
                        if child.name != "waggle" && child.name != "round" && child.name != "comb" && child.name != "pov"{
                            child.removeFromParentNode()
                        }
                    }
                    self.flowerList.removeAll()
                }
            case "marker":
                let camera = sceneView.session.currentFrame?.camera
                let cameraTransform = camera?.transform
                //if a marker is already placed
                if honeyCombPlaced{
                    if markerList.count > 0{
                        for marker in markerList{
                            marker.removeFromParentNode()
                        }
                        markerList.removeAll()
                        currentFlower.name = "nil"
                    }else{
                        //place a new marker
                        taps = 0
                        let geometry = SCNSphere(radius: 0.01)
                        geometry.firstMaterial?.diffuse.contents = UIColor.red
                        let markerNode = SCNNode(geometry: geometry)
                        markerNode.simdTransform=cameraTransform!
                        sceneView.scene.rootNode.addChildNode(markerNode)
                        currentFlower = markerNode  //not a flower, just a container var for the marker node
                        //get distance
                        chosenDist = SCNVector3.distanceFrom(vector: combNode.position, toVector: currentFlower.position)
                        addLineBetween(start: combNode.position, end: currentFlower.position)
                        //add distance text
                        addDistanceText(distance: SCNVector3.distanceFrom(vector: combNode.position, toVector: currentFlower.position), at: currentFlower.position)
                        markerList.append(markerNode)
                        currentFlower.name = "not"
                    }
                }
            default:
                let camera = sceneView.session.currentFrame?.camera
                let cameraTransform = camera?.transform
                //placea honeycomb if one is not placed
                if !honeyCombPlaced {
                    let scene = SCNScene(named:"untitled.scn")!
                    let honeyComb = scene.rootNode.childNode(withName: "obj_0", recursively: true) ?? SCNNode(geometry: SCNBox(width: 0.001, height: 0.001, length: 0.001, chamferRadius: 0))
                    honeyComb.simdTransform=cameraTransform!
                    honeyComb.name = "comb"
                    combNode=honeyComb
                    combNode.name = "isComb"
                    honeyComb.scale = SCNVector3(0.01, 0.01, 0.01)
                    honeyComb.geometry?.firstMaterial?.lightingModel = .constant
                    honeyComb.eulerAngles = SCNVector3(0, -(Float.pi)/2, 0)
                    sceneView.scene.rootNode.addChildNode(honeyComb)
                    honeyComb.runAction(SCNAction.move(by: SCNVector3(0, 0, -0.1), duration: 1.0))
                    honeyCombPlaced = true
                }
                
            }
            }

        
    }

    
    func addLineBetween(start: SCNVector3, end: SCNVector3) {
        let lineGeometry = SCNGeometry.lineFrom(vector: start, toVector: end)
        let lineNode = SCNNode(geometry: lineGeometry)

        sceneView.scene.rootNode.addChildNode(lineNode)
    }
    func addDistanceText(distance: Float, at point: SCNVector3) {
        let textGeometry = SCNText(string: String(format: "%.1f\"", distance.metersToInches()), extrusionDepth: 1)
        textGeometry.font = UIFont.systemFont(ofSize: 10)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.black

        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3Make(point.x, point.y, point.z);
        textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)

        sceneView.scene.rootNode.addChildNode(textNode)
    }

    // function ro randomly choose between random and not random flower
    func weightedRandomElement<T>(items: [(T, Int)]) -> T {

        let total = UInt32(items.map { $0.1 }.reduce(0, +))
        let rand = Int(arc4random_uniform(total))

        var sum = 0
        for (element, weight) in items {
            sum += weight
            if rand < sum {
                return element
            }
        }

        fatalError("This should never be reached")
    }
    //placing a flower function
    func placeFlower(hitTest: ARHitTestResult){
        let probs = [("flower.scn",80),("necFlower.scn",20)]
        //get the flower according to  probability
        let chosen = weightedRandomElement(items: probs)
        let flowerScene = SCNScene(named:chosen)!
        let flower = flowerScene.rootNode.childNode(withName: "obj_0", recursively: true)!
        flower.position = SCNVector3(hitTest.worldTransform.columns.3.x, hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
        var any=0
        for node in flowerList{
            if SCNVector3.distanceFrom(vector: node.position, toVector: flower.position)<0.5{
                any+=1
            }
        }
        if any==0{
            sceneView.scene.rootNode.addChildNode(flower)
            flowerList.append(flower)
        }
       
    }
    
    func animateBeeCorrect(type: String,correct: Bool){
        //if a node is not placed
        guard currentFlower.name != "nil"  && combNode.name != "notComb" else{
            let geo = SCNPlane(width: 0.1, height: 0.1)
            let mssg = SCNNode()
            mssg.name = "mssg"
            mssg.geometry = geo
            mssg.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "noMarker")
            self.sceneView.pointOfView?.addChildNode(mssg)
            return
        }
        
        
        
        let beeScene=SCNScene(named: "honeyBee.scn")!
        let bee = beeScene.rootNode.childNode(withName: "obj_0", recursively: true)!
        bee.position=currentFlower.position
        let move_to_comb = SCNAction.move(to: SCNVector3(combNode.position.x+0.1, combNode.position.y-0.007, combNode.position.z-0.007), duration: 1.5)
        let simul_rotations=SCNAction.sequence([SCNAction.rotateBy(x: (.pi/2), y: -.pi/2, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/2, y: .pi/2, z: 0, duration: 1.0),SCNAction.rotateBy(x: (.pi/2), y: -(.pi/2), z: 0, duration: 1.0),SCNAction.rotateBy(x:-(.pi/2), y: (.pi/2), z: 0, duration: 1.0),SCNAction.rotateBy(x: 0.01, y: 0.01, z: 0, duration: 1.0)])
        let rotateUpright = SCNAction.rotateTo(x: .pi/2, y: 0, z: 0, duration: 0.5)
        self.sceneView.scene.rootNode.addChildNode(bee)
        
        //making other bees
        let bee2 = beeScene.rootNode.childNode(withName: "obj_1", recursively: true)!
        let bee3 = beeScene.rootNode.childNode(withName: "obj_2", recursively: true)!
        bee2.position = SCNVector3(combNode.position.x, combNode.position.y, combNode.position.z)
        bee3.position = SCNVector3(combNode.position.x+0.12, combNode.position.y, combNode.position.z+0.009)
        bee.scale = SCNVector3(0, 0, 0)
        
        if type == "waggle" && correct{
            let gameOver = displayMssg(state: true)
            gameOver.position = SCNVector3(0, 0, -0.2)
            let displayIt = SCNAction.run { (node) in
                self.sceneView.pointOfView?.addChildNode(gameOver)
            }
            //animations for bees
            let move2nd = SCNAction.run { (node) in
                self.sceneView.scene.rootNode.addChildNode(bee2)
                self.sceneView.scene.rootNode.addChildNode(bee3)
                bee2.runAction(SCNAction.sequence([SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.move(to: SCNVector3(self.currentFlower.position.x+0.05, self.currentFlower.position.y, self.currentFlower.position.z), duration: 1.2),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.move(to: self.combNode.position, duration: 1.5),simul_rotations])]))
            }
            let move3rd = SCNAction.run { (node) in
                bee3.runAction(SCNAction.sequence([SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.move(to: SCNVector3(self.currentFlower.position.x-0.05, self.currentFlower.position.y, self.currentFlower.position.z), duration: 1.4),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.move(to: self.combNode.position, duration: 1.5),simul_rotations])]))
            }
            bee.runAction(SCNAction.group([SCNAction.playAudio(beeSound!, waitForCompletion: false),SCNAction.sequence([SCNAction.scale(to: 0.007, duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([move_to_comb,simul_rotations]),waggleMove(),move_to_comb,SCNAction.group([move3rd,move2nd,SCNAction.sequence([SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.move(to: currentFlower.position, duration: 1.6),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.move(to: combNode.position, duration: 1.5),simul_rotations])])]),displayIt])])){
                bee2.removeFromParentNode()
                bee3.removeFromParentNode()
                bee.removeFromParentNode()
            }
            
        }else if type == "round" && correct{
           
            let gameOver = displayMssg(state: true)
            gameOver.position = SCNVector3(0, 0, -0.2)
            //gameOver.scale = SCNVector3(0, 0, 0)
            let displayIt = SCNAction.run { (node) in
                self.sceneView.pointOfView?.addChildNode(gameOver)
                //gameOver.runAction(SCNAction.scale(to: 1, duration: 1.0))
            }
            let move2nd = SCNAction.run { (node) in
                self.sceneView.scene.rootNode.addChildNode(bee2)
                self.sceneView.scene.rootNode.addChildNode(bee3)
                bee2.runAction(SCNAction.sequence([SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.move(to: SCNVector3(self.currentFlower.position.x+0.05, self.currentFlower.position.y, self.currentFlower.position.z), duration: 1.2),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.move(to: self.combNode.position, duration: 1.5),simul_rotations])]))
            }
            let move3rd = SCNAction.run { (node) in
                bee3.runAction(SCNAction.sequence([SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.move(to: SCNVector3(self.currentFlower.position.x-0.05, self.currentFlower.position.y, self.currentFlower.position.z), duration: 1.4),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.move(to: self.combNode.position, duration: 1.5),simul_rotations])]))
            }
            bee.runAction(SCNAction.group([SCNAction.playAudio(beeSound!, waitForCompletion: false),SCNAction.sequence([SCNAction.scale(to: 0.007, duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([move_to_comb,simul_rotations]),roundCircle(),move_to_comb,SCNAction.group([move3rd,move2nd,SCNAction.sequence([SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.move(to: currentFlower.position, duration: 1.6),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.move(to: combNode.position, duration: 1.5),simul_rotations])])]),displayIt])])){
                bee2.removeFromParentNode()
                bee3.removeFromParentNode()
                bee.removeFromParentNode()
            }
           
        }else{
            let gameOver = displayMssg(state: false)
            gameOver.position = SCNVector3(0, 0, -0.2)
            //gameOver.scale = SCNVector3(0, 0, 0)
            let displayIt = SCNAction.run { (node) in
                self.sceneView.pointOfView?.addChildNode(gameOver)
                //gameOver.runAction(SCNAction.scale(to: 1, duration: 1.0))
            }
            let pointMove = wrongMove(type: type)
            var textNode = SCNNode()
            let displayMark = SCNAction.run { (node) in
                let textGeometry = SCNText(string: "?", extrusionDepth: 1.0)
                textGeometry.font = UIFont.systemFont(ofSize: 10)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.green

                textNode = SCNNode(geometry: textGeometry)
                textNode.position = SCNVector3Make(bee.position.x, bee.position.y+0.008, bee.position.z)
                textNode.scale = SCNVector3Make(0.005, 0.005, 0.005)

                self.sceneView.scene.rootNode.addChildNode(textNode)
            }
            let removeMark = SCNAction.run { (ndoe) in
                textNode.removeFromParentNode()
            }
            var textNode2 = SCNNode()
            let display2 = SCNAction.run { (node) in
                let textGeometry = SCNText(string: "?", extrusionDepth: 1.0)
                textGeometry.font = UIFont.systemFont(ofSize: 10)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.green

                textNode2 = SCNNode(geometry: textGeometry)
                textNode2.position = SCNVector3Make(bee2.position.x, bee2.position.y+0.008, bee2.position.z)
                textNode2.scale = SCNVector3Make(0.005, 0.005, 0.005)

                self.sceneView.scene.rootNode.addChildNode(textNode2)
            }
            let display3 = SCNAction.run { (node) in
                let textGeometry = SCNText(string: "?", extrusionDepth: 1.0)
                textGeometry.font = UIFont.systemFont(ofSize: 10)
                textGeometry.firstMaterial?.diffuse.contents = UIColor.green

                textNode2 = SCNNode(geometry: textGeometry)
                textNode2.position = SCNVector3Make(bee3.position.x, bee3.position.y+0.008, bee3.position.z)
                textNode2.scale = SCNVector3Make(0.005, 0.005, 0.005)

                self.sceneView.scene.rootNode.addChildNode(textNode2)
            }
            let removeMark2 = SCNAction.run { (node) in
                textNode2.removeFromParentNode()
            }
            let bee2Moves = SCNAction.run { (node) in
                self.sceneView.scene.rootNode.addChildNode(bee2)
                self.sceneView.scene.rootNode.addChildNode(bee3)
                bee2.runAction(SCNAction.sequence([SCNAction.move(to: SCNVector3(pointMove.x + 0.07, pointMove.y, pointMove.z), duration: 1.2),display2,SCNAction.wait(duration: 1.0),removeMark2,SCNAction.move(to: SCNVector3(self.combNode.position.x, self.combNode.position.y, self.combNode.position.z), duration: 1.5)]))
            }
            let bee3Moves = SCNAction.run { (node) in
                bee3.runAction(SCNAction.sequence([SCNAction.move(to: SCNVector3(pointMove.x + 0.05, pointMove.y, pointMove.z), duration: 1.4),display3,SCNAction.wait(duration: 1.0),removeMark2,SCNAction.move(to: SCNVector3(self.combNode.position.x, self.combNode.position.y, self.combNode.position.z), duration: 1.5)]))
            }
            bee.runAction(SCNAction.group([SCNAction.playAudio(beeSound!, waitForCompletion: false),SCNAction.sequence([SCNAction.scale(to: 0.007, duration: 1.0),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: -0.3, y: 0.5, z: 0, duration: 1.0),SCNAction.rotateBy(x: -.pi/6, y: -.pi/3, z: 0, duration: 1.0)]),SCNAction.group([SCNAction.moveBy(x: 0.5, y: 0.3, z: 0.01, duration: 1.0),SCNAction.rotateBy(x: .pi/6, y: .pi/6, z: 0, duration: 1.0)]),SCNAction.group([move_to_comb,simul_rotations]),SCNAction.wait(duration: 1.0),SCNAction.group([SCNAction.sequence([SCNAction.move(to: pointMove, duration: 2.0),displayMark,SCNAction.wait(duration: 1.0),removeMark,move_to_comb]),bee2Moves,bee3Moves]),displayIt])])){
                
                bee2.removeFromParentNode()
                bee3.removeFromParentNode()
                bee.removeFromParentNode()
            }
            
            }
            
            
        
    }
    
    func roundCircle()->SCNAction{
        //making round animation
        let pointsList = [SCNVector3(0.4, 0, 0),SCNVector3(0, 0.4, 0),SCNVector3(-0.4, 0, 0),SCNVector3(0, -0.4, 0),SCNVector3(0.4, 0, 0)]
        let beeScene=SCNScene(named: "honeyBee.scn")!
        let bee = beeScene.rootNode.childNode(withName: "obj_0", recursively: true)!
        bee.position = SCNVector3(0.1,0.1,0.1)
        combNode.addChildNode(bee)
        var circles = [SCNAction]()
        for point in pointsList{
            let circlepoint = SCNAction.move(by: point, duration: 0.5)
            circles.append(circlepoint)
        }
        let moving = SCNAction.repeat(SCNAction.sequence([circles[0],circles[1],circles[2],circles[3]]), count: 10)
        return moving
        
    }
    
    func waggleMove()->SCNAction{
        //making waggle animation
        let wagglePoints = [SCNVector3( 0, 0, 0.4),SCNVector3(0,0.2,-0.2),SCNVector3(combNode.position.x+0.1, combNode.position.y-0.007, combNode.position.z-0.007),SCNVector3(0,-0.2,-0.2),SCNVector3(0,0.2,0.2),SCNVector3(combNode.position.x+0.1, combNode.position.y-0.007, combNode.position.z-0.007)]
        var actionList=[SCNAction]()
        var a=0
        for point in wagglePoints{
            var action: SCNAction
            if a != 2 && a != 5{
                action = SCNAction.move(by: point, duration: 0.5)
            }else{
                action = SCNAction.move(to: point, duration: 0.5)
            }
            a+=1
            actionList.append(action)
        }
        
        let waggleRotation = SCNAction.rotateBy(x: (.pi)/8, y: 0, z: 0, duration: 0.2)
        let Rotateaction = SCNAction.sequence([waggleRotation,waggleRotation.reversed(),waggleRotation.reversed(),waggleRotation])
        
        
        let waggleAction = SCNAction.repeat(SCNAction.sequence([SCNAction.group([actionList[0],Rotateaction]),actionList[1],actionList[2],SCNAction.group([actionList[0],Rotateaction]),actionList[3],actionList[2]]), count: 7)
        return waggleAction
    }
    
    func wrongMove(type:String)->SCNVector3{
        //wrong move animation
        if type == "round"{
            let randomVal = Float.random(in: 1...2)
            let randomPoint = SCNVector3(randomVal, 0, -0.01)
            return randomPoint
        }else{
            let randomVal = Float.random(in: 1...4)
            let randomPoint = SCNVector3(randomVal, 0, -0.01)
            return randomPoint
        }
        return SCNVector3(0,0,0)
    }
    
    func displayMssg(state: Bool)->SCNNode{
        let geo = SCNPlane(width: 0.1, height: 0.1)
        let mssg = SCNNode()
        mssg.name = "mssg"
        mssg.geometry = geo
        //checing correctness
        if state{
            mssg.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "correct")
        }else{
            mssg.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "wrong")
        }
        return mssg
    }
    

    

}


PlaygroundPage.current.liveView = MainView()
PlaygroundPage.current.wantsFullScreenLiveView = true
PlaygroundPage.current.needsIndefiniteExecution = true

