workspace "Interactive Forest VR - V3 Shared Mode" "Container View" {

    !identifiers hierarchical

    model {
        system = softwareSystem "Interactive Forest VR System" "Multi-user VR using Photon Fusion Shared Mode." {
            backend = container "Backend (FastAPI)" "Python 3.x FastAPI app" "Handles auth, session registry, webhooks, and persistence via REST."
            database = container "Database (PostgreSQL)" "Stores users, sessions, and JSONB snapshots." "PostgreSQL 13+"
            observability = container "Observability Stack" "Prometheus + Grafana" "Metrics, structured logs, dashboards."
            vpn = container "VPN Gateway" "WireGuard or OpenVPN" "Secures remote maintenance."
            unityClient = container "Unity Client" "Meta Quest 3 app using Photon Fusion Shared Mode" "Synchronizes state, performs autosave if leader."
        }

        user = person "VR User" "Participant using Meta Quest 3 headset."

        photon = softwareSystem "Photon Cloud Relay" "Shared Mode relay between clients."
        metaAnchors = softwareSystem "Meta Shared Spatial Anchors" "Cloud-based anchor alignment service."
        mapsService = softwareSystem "MapTiler or Maps3D.io" "Provides 3D map tiles or GLTF/OBJ static exports."

        user -> system.unityClient "Uses"
        system.unityClient -> photon "Connects via Photon Cloud Relay (real-time sync)"
        system.unityClient -> system.backend "Calls REST APIs (login, save, refresh token)"
        system.backend -> system.database "Persists session and snapshot data (JSONB)"
        system.backend -> system.observability "Exposes metrics / structured logs"
        system.backend -> system.vpn "Admin access (VPN only)"
        system.unityClient -> metaAnchors "Creates / resolves spatial anchors"
        system.unityClient -> mapsService "Loads 3D maps and overlays"

    }

    views {
        container system "interactive-forest-vr-v3-containers" {
            include *
            autolayout lr
        }
    }
}
