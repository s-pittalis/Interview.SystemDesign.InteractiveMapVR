workspace "Interactive Map VR - V2 Server Mode" "System Context" {

    !identifiers hierarchical

    model {
        user = person "VR User" "Operatore con visore Meta Quest 3 che partecipa alle sessioni VR in LAN."

        vrSystem = softwareSystem "Interactive Map VR System" "Ambiente multiutente basato su Photon Server locale, backend integrato e persistenza su PostgreSQL." {
            photonServer = container "Photon Fusion Server" "Photon Fusion" "Gestisce le room, sincronizza lo stato runtime e ospita il backend FastAPI integrato." 
            backend = container "Backend (FastAPI)" "Python 3.x" "Legge lo stato delle room direttamente dal server Photon e gestisce autenticazione, snapshot e persistenza."
            database = container "PostgreSQL" "PostgreSQL 13+" "Archivia utenti, sessioni e snapshot (JSONB)."
            maps = container "Maps Service" "MapTiler / Maps3D.io" "Fornisce tile e asset 3D da SSD locale o rete interna."
            observability = container "Observability Stack" "Prometheus + Grafana" "Raccoglie metriche e log di backend e Photon Server."
            vpn = container "VPN Gateway" "WireGuard / OpenVPN" "Permette manutenzione remota dell’infrastruttura on-prem."
            unityClient = container "Unity Client (Quest)" "Unity + Meta XR + Fusion" "Connette i visori al Photon Server e invia richieste al backend via LAN."
        }

        metaAnchors = softwareSystem "Meta Shared Spatial Anchors" "Servizio cloud per la sincronizzazione delle ancore spaziali."
        mapsUpdater = softwareSystem "External Map Updates" "Sorgente opzionale per aggiornamenti mappe o asset 3D esterni."

        user -> vrSystem.unityClient "Utilizza il visore e interagisce nella scena condivisa"
        vrSystem.unityClient -> vrSystem.photonServer "Connessione runtime (UDP/TCP LAN)"
        vrSystem.unityClient -> vrSystem.backend "REST API (login, sessioni) via HTTPS locale"
        vrSystem.unityClient -> vrSystem.maps "Richiesta tile e asset 3D"
        vrSystem.unityClient -> metaAnchors "Crea/ripristina ancore (Internet)"

        vrSystem.backend -> vrSystem.photonServer "Legge lo stato runtime della room per snapshot e autosave"
        vrSystem.photonServer -> vrSystem.backend "Invoca salvataggi e webhook locali"
        vrSystem.backend -> vrSystem.database "Persistenza sessioni e snapshot"
        vrSystem.backend -> vrSystem.observability "Esporta metriche e log"
        vrSystem.backend -> vrSystem.vpn "Manutenzione amministrativa"
        vrSystem.backend -> mapsUpdater "Riceve aggiornamenti mappe opzionali"

        vrSystem.vpn -> vrSystem.database "Backup e restore"
        vrSystem.vpn -> vrSystem.maps "Aggiornamenti asset"
        vrSystem.vpn -> vrSystem.observability "Accesso diagnostico"
    }

    views {
        systemContext vrSystem "ifvr-v2-context" {
            include *
            autoLayout lr
        }
    }
}
