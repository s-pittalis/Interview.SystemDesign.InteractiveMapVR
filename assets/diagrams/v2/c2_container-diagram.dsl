workspace "Interactive Forest VR - V2 Server Mode" "Container View" {

    !identifiers hierarchical

    model {
        system = softwareSystem "Interactive Map VR System" "Photon Server autorevole con backend e servizi locali." {
            photonServer = container "Photon Fusion Server" "Photon Fusion" "Gestisce le room e mantiene lo stato runtime autorevole (UDP/TCP 5055)."
            backend = container "Backend (FastAPI)" "Python 3.x" "Legge lo stato delle room direttamente da Photon Server e gestisce autenticazione, persistenza e snapshot."
            database = container "PostgreSQL" "PostgreSQL 13+" "Utenti, sessioni, snapshot JSONB, vista save_index."
            observability = container "Observability Stack" "Prometheus + Grafana" "Esporta metriche e dashboard locali."
            vpn = container "VPN Gateway" "WireGuard / OpenVPN" "Consente accesso amministrativo remoto controllato all’edge node."
            unityClient = container "Unity Client (Quest)" "Unity + Meta XR + Fusion" "Esegue la scena VR e si connette al Photon Server via LAN."
        }

        user = person "VR User" "Operatore che utilizza Meta Quest 3."
        metaAnchors = softwareSystem "Meta Shared Spatial Anchors" "Servizio cloud per ancore spaziali condivise."
        maps = softwareSystem "Maps Service" "MapTiler / Maps3D.io" "Servizio esterno o on-prem dedicato alla fornitura di tile e asset 3D."

        user -> system.unityClient "Usa l’applicazione VR"
        system.unityClient -> system.photonServer "Sincronizzazione runtime (UDP/TCP)"
        system.unityClient -> system.backend "REST: login, sessioni (LAN)"
        system.unityClient -> maps "HTTP(S): tile e asset 3D"
        system.unityClient -> metaAnchors "Crea/ripristina ancore"

        system.backend -> system.photonServer "Legge stato delle room per snapshot e autosave"
        system.photonServer -> system.backend "Eventi webhook e accesso condiviso allo stato runtime"
        system.backend -> system.database "Scrive snapshot e metadati"
        system.backend -> system.observability "/metrics, log strutturati"
        system.vpn -> system.backend "Accesso remoto e manutenzione"
    }

    views {
        container system "ifvr-v2-containers" {
            include *
            autoLayout lr
        }
    }
}
