/*:
 # The Honey Bee Dance
 */

/*:
 * Callout(The Honey Bee Dance):
 We've all heard about Honeybees. Small buzzing insects that appear to be randomly flying everywhere, yet so vital to our ecosystem.
 The need to save Honeybees is key to maintaining the balance of our ecosystem. But why? Why are they so important?
 Answer? *Pollination*: Transfer of pollen from one flower to another, is supposedly key to the spread and growth of plant seeds over an area.
 */

/*:
 * Callout(How do they do this?):
 How do Honeybees transfer pollen?
 When a Honeybee lands on a flower, pollen grains stick to hairs on a Honeybee.
 This raises a key question:
 */

/*:
 * Callout(How do Honeybees choose flowers?):
 How do Honeybees choose a flower? Do they do so randomly?
 Nope! Honeybees look out for flowers with the most *nectar*!
 Well that was straightforward right?
 But how do they tell each other where the best flower is ? Is it random? Do they randomly roam around on their own, or is there a specific method of communication?
 */

/*:
 * Callout(Waggle Dance and Circle Dance):
 Bees in a colony work with each other to gather food. They try to find the most pollen and nectar in the least amount of time possible.
 Some flowers have more pollen and nectar than others. When a good flower patch is found, bees recruit other bees from their colony to the patch.
 Bees communicate flower location using special dances inside the hive. One bee dances, while other bees watch to learn the directions to a specific flower patch.
 The dancing bee smells like the flower patch, and also gives the watching bees a taste of the nectar she gathered. Smell and taste helps other bees find the correct flower patch.
 Bees use two different kinds of dances to communicate information: the waggle dance and the circle dance.
*/

/*:
* Callout(Circle Dance):
The round dance tells the watching bees only one thing about the flower patch’s location: that it is somewhere close to the hive.
This dance does not include a waggle run, or any information about the direction of the flower patch.
Watch how this Dance is carried out, by clicking on Circle Dance in the playground.
 
![Circle Image](roundIllu.png)
*/

/*:
 * Callout(Waggle Dance):
 The waggle dance tells the watching bees two things about a flower patch’s location: the distance and the direction away from the hive.
 The dancing bee waggles back and forth as she moves forward in a straight line, then circles around to repeat the dance. The length of the middle line, called the waggle run, shows roughly how far it is to the flower patch.
 Visualize this movement by clicking on the Waggle Dance in the playground.
 ![Waggle Image](waggleIllu.png)
 */

/*:
 * Callout(Conclusion):
 This is, in short, how bees communicate among themselves.
 Fascinating, is it not? Bees are smarter than we think they are.
 All this may seem very complex, but hey! Wanna see how bees do it?
 I've put together a small game, that can help you get acquainted with the world of bees and their *dances*!
 Excited? Perfect!
 Click on *How to Play* to learn how to play the game!
 For the purpose of the game, far is termed as farther than 50 inches. Distance from honey comb will be displayed on marker
 Once you feel like you've understood, press the next button (in the playground)  to proceed and Play!
 */

/*:
 - Note:
  For best experience, Play the game in full-screen mode.
  \
  Move up close to the bees to watch how they communicate.
  \
  P.S Please disable *Enable Results* for optimum performance
 
*/

//: [Next](@next)

import Foundation
import SpriteKit
import SwiftUI
import PlaygroundSupport

struct decoView: UIViewRepresentable{
    func makeUIView(context: UIViewRepresentableContext<decoView>) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        if let scene = decoScene() as? SKScene {
            // We need to set the background to clear.
            scene.backgroundColor =  .clear
            view.presentScene(scene)
        }
        return view
    }

    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<decoView>) {

    }

}

class decoScene: SKScene{
    override func didMove(to view: SKView) {
        let beeNode = SKSpriteNode(imageNamed: "honeyBee1")
        addChild(beeNode)
        beeNode.scale(to: CGSize(width: 80, height: 80))
        beeNode.run(SKAction.repeat(SKAction.sequence([SKAction.move(by: CGVector(dx: 1, dy: 0), duration: 2.0),SKAction.move(by: CGVector(dx: 1, dy: 1), duration: 2.0),SKAction.move(by: CGVector(dx: 1, dy: -1), duration: 2.0),SKAction.move(by: CGVector(dx: 0, dy: 1), duration: 2.0),SKAction.move(by: CGVector(dx: 0.5, dy: 2.0), duration: 2.0),SKAction.move(by: CGVector(dx: 0, dy: -1), duration: 2.0),SKAction.move(by: CGVector(dx: -0.5, dy: -1), duration: 2.0),SKAction.move(by: CGVector(dx: 0.5, dy: -1), duration: 2.0)]), count: 3))
    }
}


struct SpriteView: UIViewRepresentable {
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<SpriteView>) {

    }

    
    func makeUIView(context: UIViewRepresentableContext<SpriteView>) -> SKView {
        let view = SKView()
        if let scene = RoundBee(size: CGSize(width: 100, height: 100)) as? SKScene{
            view.presentScene(scene)
        }
        print("started")
        return view
    }
}

struct WaggleVIew: UIViewRepresentable {
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<WaggleVIew>) {

    }
    
    func makeUIView(context: UIViewRepresentableContext<WaggleVIew>) -> SKView {
        let view = SKView()
        if let scene = WaggleBee(size: CGSize(width: 200, height: 200)) as? SKScene{
            view.presentScene(scene)
        }
        view.autoresizingMask=[.flexibleHeight,.flexibleWidth]
        print("started")
        return view
    }
}

struct PicView: UIViewRepresentable {
    
    func updateUIView(_ uiView: SKView, context: UIViewRepresentableContext<PicView>) {

    }
    
    func makeUIView(context: UIViewRepresentableContext<PicView>) -> SKView {
        let view = SKView()
        view.allowsTransparency = true
        if let scene = picAnim(size: CGSize(width: 100, height: 150)) as? SKScene{
            view.presentScene(scene)
            view.backgroundColor = .clear
            view.frame = CGRect(x: view.frame.width/2, y: view.frame.width/2, width: 200, height: 200)
        }
        print("started")
        return view
    }
}

class picAnim: SKScene{
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        view.backgroundColor = UIColor.clear
        let pointed = SKSpriteNode(imageNamed: "pointed.png")
        let honeyComb = SKSpriteNode(imageNamed: "honeyComb.png")
        honeyComb.scale(to: CGSize(width: 80, height: 80))
        addChild(honeyComb)
        honeyComb.position = CGPoint(x: frame.width/2, y: frame.height/2)
        pointed.scale(to: CGSize(width: 80, height: 80))
        addChild(pointed)
        let action = SKAction.run {
            print("hsjdhcsj")
        }
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 100, height: 100))
        let moveRound = SKAction.follow(ovalPath.cgPath, asOffset: false, orientToPath: true, speed: 200)
        pointed.run(SKAction.repeatForever(moveRound))
    }
}

class RoundBee: SKScene{
    override init(size: CGSize) {
    super.init(size: size)
}
required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    
override func didMove(to view: SKView) {
    view.autoresizesSubviews = true
    view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    let textures = [SKTexture(imageNamed: "honeyBee1.png"),SKTexture(imageNamed: "honeyBee2.png")]
    let beeNode = SKSpriteNode(imageNamed: "honeyBee.png")
    beeNode.scale(to: CGSize(width: 80, height: 80))
    beeNode.zPosition = 100
    addChild(beeNode)
    let wait = SKAction.wait(forDuration: 1.0)
    //path to move in circles
    let ovalPath = UIBezierPath(ovalIn: CGRect(x: view.frame.width/2, y: view.frame.height/2, width: 100, height: 100))
    let moveRound = SKAction.follow(ovalPath.cgPath, asOffset: false, orientToPath: true, speed: 200)
    print("gonna do")
    beeNode.run(SKAction.sequence([wait,SKAction.repeatForever(SKAction.group([SKAction.animate(with: textures, timePerFrame: 0.2),moveRound]))]))
    
}
}

class WaggleBee: SKScene{
    override init(size: CGSize) {
    super.init(size: size)
}
required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
    
override func didMove(to view: SKView) {
    let textures = [SKTexture(imageNamed: "honeyBee1.png"),SKTexture(imageNamed: "honeyBee2.png")]
    
    print("Called")
    view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    view.autoresizesSubviews = true
    
    let beeNode = SKSpriteNode(imageNamed: "honeyBee.png")
    beeNode.scale(to: CGSize(width: 80, height: 80))
    beeNode.zPosition = 100
    addChild(beeNode)
    let wait = SKAction.wait(forDuration: 1.0)
    let bezierPath = UIBezierPath()
    bezierPath.lineWidth = 10
    
    bezierPath.addArc(withCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: 40, startAngle: 2*(.pi), endAngle: .pi, clockwise: false)
    
    let anotherPath = UIBezierPath()
    anotherPath.lineWidth = 10
    
    anotherPath.addArc(withCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: 80, startAngle: 2*(.pi), endAngle: .pi, clockwise: true)
    
    
    let straightPath = UIBezierPath()
    straightPath.move(to: CGPoint(x: (frame.width)/4, y: frame.height/2 - 20))
    straightPath.addLine(to: CGPoint(x: 3*(frame.width)/4, y: frame.height/2 - 20))
    
    let move1 = SKAction.follow(straightPath.cgPath, speed: 200)
    let move2 = SKAction.follow(bezierPath.cgPath, speed: 200)
    let move3 = SKAction.follow(anotherPath.cgPath, speed: 200)
    
    
    beeNode.run(SKAction.repeatForever(SKAction.group([SKAction.animate(with: textures, timePerFrame: 0.2),SKAction.sequence([SKAction.follow(straightPath.cgPath, asOffset: false, orientToPath: true, speed: 100),SKAction.follow(bezierPath.cgPath, asOffset: false, orientToPath: true, speed: 100),SKAction.follow(straightPath.cgPath, asOffset: false, orientToPath: true, speed: 100),SKAction.follow(anotherPath.cgPath, asOffset: false, orientToPath: true, speed: 200)])])))
    
    
    
    
}

    func createPath() -> UIBezierPath{
        let straightPath = UIBezierPath()
        straightPath.move(to: CGPoint(x: (frame.width)/4, y: frame.height/2))
        straightPath.addLine(to: CGPoint(x: 3*(frame.width)/4, y: frame.height/2))
        straightPath.addArc(withCenter: CGPoint(x: frame.width/2, y: frame.height/2), radius: 40, startAngle: 2*(.pi), endAngle: .pi, clockwise: true)
        straightPath.addArc(withCenter: CGPoint(x: frame.width/2,y: frame.height/2), radius: 40, startAngle: 2*(.pi), endAngle: .pi, clockwise: false)
        straightPath.lineWidth = 10
        
        return straightPath
    }
}
    
struct IntroView: View{
    var body: some View {
        NavigationView{
            ZStack{
                ScrollView{
                    VStack(spacing: 10){
                        Spacer()
                        NavigationLink(destination: Round()) {
                            Text("Round Move")
                                .font(.headline)
                                .frame(minWidth: 0, idealWidth: 300, maxWidth: 300, minHeight: 0, idealHeight: 100, maxHeight: 150, alignment: .center)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.title)
                        }
                        Spacer()
                        NavigationLink(destination: Waggle()) {
                            Text("Waggle Move")
                                .font(.headline)
                            .frame(minWidth: 0, idealWidth: 300, maxWidth: 300, minHeight: 0, idealHeight: 100, maxHeight: 150, alignment: .center)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.title)
                        }
                        Spacer()
                        NavigationLink(destination: MainPlay()) {
                            Text("How to Play")
                                .font(.headline)
                            .frame(minWidth: 0, idealWidth: 300, maxWidth: 300, minHeight: 0, idealHeight: 100, maxHeight: 150, alignment: .center)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(40)
                            .font(.title)
                        }
                    }
                
                }
            .background(Image(uiImage: UIImage(named: "background.png")!)
            //.resizable()
            .aspectRatio(contentMode: .fill)
            .edgesIgnoringSafeArea(.all)
                )
            }
            
        .navigationBarTitle("🐝 Intro")
        }
    .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
    }
}
struct Round: View{
    var body: some View {
        VStack{
            Spacer()
            SpriteView()
            .zIndex(2)
            
        }
        .background(Color.blue)
        .navigationBarTitle("Round")
    }
}

struct Waggle: View{
    var body: some View {
        VStack{
            Spacer()
            WaggleVIew()
                .zIndex(2)
            
        }
        .background(Color.blue)
    .navigationBarTitle("Waggle")
    }
}

struct Playing: View{
    var body: some View{
        ScrollView{
            VStack{
                Text("🍯   Place a honeyComb at your height by tapping on the Screen. This will add a honeyComb to your room")
                    .padding()
                Text("🍯   Go Hunting! Roam around your room or house, focusing on places you think could be flat surfaces. Flowers will pop-up as you go!")
                .padding()
                Text("🍯   Look out for flowers with nectar lines(purple) on them. Those are the Sweet Flowers!")
                .padding()
                Text("🍯   Remember! Your aim is not just to find sweet flowers, but also nearby ones. Try checking more places, just to ensure you found the best flower possible!")
                .padding()
                Text("🍯   Bent Down as close to the flower as you can get, take a good smell, and tap on the screen to select that flower")
                .padding()
                Text("🍯   Choose an option, round or waggle, depending on how far the flower is")
                .padding()
                Text("🍯   Thats it! Watch the magic happen! If you chose the correct option, the bees will communicate and come to fetch some nectar.")
                .padding()
                Text("🍯   But if you choose the wrong choice, poor Bees! They will not find any flowers with the wrong communication")
                .padding()
                Text("🍯   Once you get it right feel free to keep trying. If you feel like you've played long enough, go to the next Playgrounf Page!")
                .padding()
                Text("🍯   Go to the next Playground Page to Play Now!")
                .padding()
                
            }
            Spacer()
        }
    }
}

struct subPlay: View{
    var image: String
    var gesture: Bool
    var text : String

    var body: some View{
        VStack{
            PicView()
                .zIndex(2)
            Text("🍯   Place a honeyComb at your height by tapping on the Screen. This will add a honeyComb to your room")
                               .padding()
        }
        .background(Color.white)
    }
}

struct cardUIView: View {
    var image: String
    //var category: String
    var text: String
    var body: some View {
        VStack{
            
            Image(uiImage: UIImage(named: image)!).resizable().aspectRatio(contentMode: .fit)
            Button(action: {
                print("executed")
            }) {
                HStack{
                    VStack(alignment: .leading) {
                        Text(text)
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                        
                    .layoutPriority(100)
                    Spacer()
                }
            }
            
          
        .padding()
        .shadow(radius: 10)
            .background(Color.orange)
        }
        .shadow(radius: 10)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 5).shadow(radius: 10)
            
    )
        .padding([.top, .horizontal])
        .shadow(radius: 40)
            
    }
}



struct MainPlay: View{
    var body: some View{
        ScrollView{
            ZStack{
                VStack{
                    
                        //.padding()
                    cardUIView(image: "honeyComb.png", text: "🍯   Place a honeyComb at your height by tapping on the Screen. This will add a honeyComb to your room")
                        .padding()
                    cardUIView(image: "sky.png", text: "🍯   Go Hunting! Roam around your room or house, focusing on places you think could be flat surfaces. Flowers will pop-up as you go!")
                    .padding()
                    cardUIView(image: "necFlower.png", text: "🍯   Look out for flowers with nectar lines(purple) on them. Those are the Sweet Flowers!")
                    .padding()
                    cardUIView(image: "distance.png", text: "🍯   Remember! Your aim is not just to find sweet flowers, but also nearby ones. Try checking more places, just to ensure you found the best flower possible!")
                    .padding()
                    cardUIView(image: "flowerTab.png", text: "🍯   Bent Down as close to the flower as you can get, take a good smell, and tap on the screen to select that flower")
                    .padding()
                    cardUIView(image: "options.png", text: "🍯   Choose an option, round or waggle, depending on how far the flower is. Farther than 50 inches is categorized as far")
                    .padding()
                    cardUIView(image: "happy.png", text: "🍯   Thats it! Watch the magic happen! If you chose the correct option, the bees will communicate and come to fetch some nectar.")
                    .padding()
                    cardUIView(image: "sad.png", text: "🍯   But if you choose the wrong choice, poor Bees! They will not find any flowers with the wrong communication")
                        .padding()
                    cardUIView(image: "tryAgain", text: "🍯   Once you get it right feel free to keep trying. If you feel like you've played long enough, go to the next Playground Page!")
                    .padding()
                    cardUIView(image: "next.png", text: "🍯   Go to the next Playground Page to Play Now!")
                    .padding()
                    
                    
                }
            }
            
        }
            
        .edgesIgnoringSafeArea(.all)
    }
}




PlaygroundPage.current.setLiveView(IntroView())



