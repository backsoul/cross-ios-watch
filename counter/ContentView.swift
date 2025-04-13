import SwiftUI
import WatchConnectivity

class PhoneSessionDelegate: NSObject, WCSessionDelegate, ObservableObject {
    @Published var value: Double = 0
    
    private var webSocketTask: URLSessionWebSocketTask?

    override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("was actived ios session")
        }
        
        connectWebSocket()
    }
    
       private func connectWebSocket() {
           guard let url = URL(string: "wss://url") else { return }
           let session = URLSession(configuration: .default)
           webSocketTask = session.webSocketTask(with: url)
           webSocketTask?.resume()
       }

       private func sendToWebSocket(value: Double) {
           let json: [String: Any] = ["value": Int(value)]
           if let data = try? JSONSerialization.data(withJSONObject: json),
              let jsonString = String(data: data, encoding: .utf8) {
               let message = URLSessionWebSocketTask.Message.string(jsonString)
               webSocketTask?.send(message) { error in
                   if let error = error {
                       print("WebSocket send error: \(error.localizedDescription)")
                       self.connectWebSocket()
                   } else {
                       print("Valor enviado al WebSocket: \(jsonString)")
                   }
               }
           }
       }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Activation state ios: \(activationState.rawValue), error: \(String(describing: error))")
        DispatchQueue.main.async {
            print("iPhone activation state: \(activationState), isReachable: \(WCSession.default.isReachable)")
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Recevied message from Apple Watch: \(message)")
        if let newValue = message["value"] as? Double {
            DispatchQueue.main.async {
                self.value = newValue
                self.sendToWebSocket(value: newValue)
            }
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Session became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("Session deactivated")
    }

    func session(_ session: WCSession, didFailWithError error: Error) {
        print("WCSession error: \(error.localizedDescription)")
    }
}

struct ContentView: View {
    @StateObject var session = PhoneSessionDelegate()

    var body: some View {
        VStack {
            Text("iPhone")
                .font(.headline)
                .padding()

            Text("Valor:")
                .font(.headline)
            Text("\(Int(session.value))")
                .font(.system(size: 60, weight: .bold))
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
}
