import SwiftUI
import PlayerUILogger
import PlayerUISwiftUI
import PlayerUIReferenceAssets
import PlayerUIBeaconPlugin

let flow = """
{
  "id": "generated-flow",
  "views": [
    {
      "id": "action",
      "type": "action",
      "exp": "{{count}} = {{count}} + 1",
      "label": {
        "asset": {
          "id": "action-label",
          "type": "text",
          "value": "Clicked {{count}} times"
        }
      }
    }
  ],
  "data": {
    "count": 0
  },
  "navigation": {
    "BEGIN": "FLOW_1",
    "FLOW_1": {
      "startState": "VIEW_1",
      "VIEW_1": {
        "state_type": "VIEW",
        "ref": "action",
        "transitions": {
          "*": "END_Done"
        }
      },
      "END_Done": {
        "state_type": "END",
        "outcome": "done"
      }
    }
  }
}
"""

@main
struct BazelApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                PlayerView()
            }
        }
    }
}

struct PlayerView: View {
    var body: some View {
        VStack {
            SwiftUIPlayer(flow: flow, plugins: [ReferenceAssetsPlugin()], result: .constant(nil))
        }
    }
}
