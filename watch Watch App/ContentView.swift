import SwiftUI
import WatchConnectivity

class WatchSessionDelegate: NSObject, WCSessionDelegate, ObservableObject {
    @Published var rawValue: Double = 0 {
        didSet {
            let rounded = Double(Int(rawValue.rounded()))
            if rounded != lastSentValue {
                lastSentValue = rounded
                sendValueToPhone(rounded)
            }
        }
    }

    private var lastSentValue: Double = -1

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("was actived watch session")
        }
    }

    func sendValueToPhone(_ value: Double) {
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
            Text("\(Int(session.rawValue.rounded()))")
                .font(.system(size: 50, weight: .bold))
                .padding()
        }
        .focusable(true)
        .digitalCrownRotation(
            $session.rawValue,
            from: 0,
            through: 100,
            by: 1,
            sensitivity: .low,
            isContinuous: false,
            isHapticFeedbackEnabled: true
        )
    }
}

#Preview {
    ContentView()
}
