//

import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    @Namespace var ns
    var body: some View {
        let toggle = tapCount.isMultiple(of: 2)
        VStack {
            ZStack {
                if toggle {
                    Color.red
                        .matchedGeometryEffect(id: "ID", in: ns)
                        .frame(width: 50, height: 50)

                } else {
                    Color.blue
                        .matchedGeometryEffect(id: "ID", in: ns)
                        .frame(width: 100, height: 100)
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity, alignment: toggle ? .leading : .trailing)
            .background {
                Text("Hello")
                    .font(.largeTitle)
            }
            .modifier(DebugAnimation(state: $tapCount, from: 0, to: 1))
            Spacer()
        }

        .padding()
    }
}

struct DebugAnimation<Value: Equatable>: ViewModifier {
    @Binding var state: Value
    var from, to: Value
    @State private var progress: Double = 0

    func body(content: Content) -> some View {
        let anim = Animation(ConstantAnimation(progress: progress))
        content
            .animation(anim, value: state)
            .onChange(of: progress) {
                state = from
                withAnimation {
                    state = to
                }
            }
            .overlay(alignment: .bottom) {
                Slider(value: $progress, in: 0...1)
                    .frame(width: 200, height: 40)
                    .alignmentGuide(.bottom, computeValue: { dimension in
                        dimension[.top]
                    })
            }
    }
}

struct ConstantAnimation: CustomAnimation {
    var progress: Double
    func animate<V>(value: V, time: TimeInterval, context: inout AnimationContext<V>) -> V? where V : VectorArithmetic {
        print(value)
        return value.scaled(by: progress)
    }

    func shouldMerge<V>(previous: Animation, value: V, time: TimeInterval, context: inout AnimationContext<V>) -> Bool where V : VectorArithmetic {
        return true
    }
}

#Preview {
    ContentView()
}
