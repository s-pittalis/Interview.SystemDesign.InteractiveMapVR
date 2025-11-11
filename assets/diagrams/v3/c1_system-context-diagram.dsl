workspace "Interactive Forest VR - V3 Shared Mode" "System Context" {

    !identifiers hierarchical

    model {
        user = person "VR User" "Meta Quest 3 user exploring shared forest scene with other peers."

        system = softwareSystem "Interactive Forest VR System" "Multi-user VR environment using Photon Fusion Shared Mode and deterministic leader election."

        photon = softwareSystem "Photon Cloud Relay" "Relays real-time state between peers (Shared Mode)."
        metaAnchors = softwareSystem "Meta Shared Spatial Anchors" "Provides spatial alignment in cloud."
        mapsService = softwareSystem "Maps3D.io Service" "Delivers static 3D GLTF/OBJ map overlays (no streaming, cost-effective)."
        backend = softwareSystem "Interactive Forest VR Backend" "FastAPI service managing authentication, sessions, and persistence."
        db = softwareSystem "PostgreSQL Database" "Stores user sessions and JSONB snapshots."
        observability = softwareSystem "Observability Stack" "Prometheus + Grafana for metrics and dashboards."
        vpn = softwareSystem "VPN Gateway" "Secures remote administrative access."

        user -> system "Uses via Meta Quest 3 headset"
        system -> photon "Syncs multiplayer state (Shared Mode relay)"
        system -> backend "Sends REST API calls (login, saves)"
        system -> metaAnchors "Resolves and shares spatial anchors"
        system -> mapsService "Loads static 3D map assets for visualization"
        backend -> db "Persists snapshots and session state"
        backend -> observability "Publishes metrics and logs"
        backend -> vpn "Accessible only for admin maintenance"
    }

    views {
        systemContext system "interactive-forest-vr-v3-context" {
            include *
            autolayout lr
        }
    }
}
