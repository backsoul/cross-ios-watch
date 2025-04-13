import SwiftUI
import WatchConnectivity
import SwiftUI

class WatchSessionDelegate: NSObject, WCSessionDelegate, ObservableObject {
    @Published var value: Double = 0 {
        didSet {
            sendValueToPhone()
        }
    }

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("was actived watch session")
        }
    }

    // Enviar mensaje al iPhone cuando cambie el valor
    func sendValueToPhone() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["value": value], replyHandler: nil) { error in
                print("Error al enviar al iPhone: \(error.localizedDescription)")
            }
        } else {
            print("iPhone no alcanzable")
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation state watch: \(activationState.rawValue), error: \(String(describing: error))")
        print("Watch activation state: \(activationState), isReachable: \(WCSession.default.isReachable)")
    }
}

struct ContentView: View {
    @StateObject var session = WatchSessionDelegate()

    var body: some View {
        VStack {
            Text("Watch")
                .font(.headline)
                .padding()

            Text("Valor:")
                .font(.headline)
            Text("\(Int(session.value))")
                .font(.system(size: 50, weight: .bold))
                .padding()
        }
        .focusable(true)
        .digitalCrownRotation($session.value, from: 0, through: 100, by: 1, sensitivity: .medium)
    }
}

#Preview {
    ContentView()
}
