//: [Previous](@previous)

/*:
 - Important:
 As a tribute to Karl Von Frisch, Nobel laureate in 1973, for decoding the dance language and social behavior patterns of honey bees.
 */

/*:
 * Callout(Epilogue):
 
 All around the world, the bee population Is drastically decreasing.
 Murder Hornets are the newest threat in certain areas, to a growing bee population.
 You might think, why does all this matter?  "*Because, Bee’s Matter.*"
 
 Source of info:  https://bee-health.extension.org/dance-language-of-the-honey-bee/

 */
import Foundation
import SwiftUI
import PlaygroundSupport

extension View {
    func animat1e(using animation: Animation = Animation.easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        return onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
}


struct FinalView: View{
    @State var controlVar = false
    var body: some View{
        LinearGradient(gradient: Gradient(colors: [Color.orange,Color.red]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all).overlay( VStack{
                Text("In Memory Of")
                    .foregroundColor(.white)
                    .font(.system(size: 40))
                    .fontWeight(.heavy)
                    .padding()
                    .opacity(controlVar ? 1 : 0)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 2.0)){
                            self.controlVar.toggle()
                        }
                }
                    
                Text("Karl von Frisch")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                .opacity(controlVar ? 1 : 0)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 3.0)){
                            self.controlVar.toggle()
                            self.controlVar.toggle()
                        }
                }
                
                Image(uiImage: UIImage(named: "VonFrisch.png")!)
                .resizable()
                    .frame(width: 250, height: 250, alignment: .center)
               
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                .animat1e {
                    self.scaleEffect(0.2, anchor: .trailing)
                }
                
                /*Text("You might think, why does all this matter?")
                    .padding()
                    .foregroundColor(.white)
                    .font(.system(size: 15))*/
                Text("“The bee's life is like a magic well: the more you draw from it, the  more it fills with water”")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                .padding()
                    .opacity(controlVar ? 1: 0)
                    .onAppear{
                        withAnimation(.easeInOut(duration: 3.0)){
                            self.controlVar.toggle()
                            self.controlVar.toggle()
                        }
                }
            })
        
    }
}

PlaygroundPage.current.setLiveView(FinalView())



//: [Next](@next)
