#!/bin/sh
fail=0
ok()   { echo "PASS  $1"; }
ko()   { echo "FAIL  $1"; fail=1; }

# DNS
docker exec client1 dig +short web.pme.local | grep -q "172.20.1.10" \
  && ok "DNS: web.pme.local -> 172.20.1.10" || ko "DNS: web.pme.local"

# LAN -> DMZ : HTTP autorise
docker exec client1 curl -sf -m 5 http://web.pme.local/healthz >/dev/null \
  && ok "LAN -> web-dmz :80 autorise" || ko "LAN -> web-dmz :80"

# Reverse proxy
docker exec client1 curl -sf -m 5 http://web.pme.local/app/ | grep -q "backend interne OK" \
  && ok "Reverse proxy /app/" || ko "Reverse proxy /app/"

# SSH filtre
docker exec client1 nmap -Pn -p 22 172.20.1.10 | grep -q "22/tcp filtered" \
  && ok "SSH :22 filtre par router-fw" || ko "SSH :22 filtre"

# DMZ -> LAN bloque
docker exec web-dmz nslookup -timeout=2 web.pme.local 172.20.2.10 >/dev/null 2>&1 \
  && ko "DMZ -> LAN doit etre bloque" || ok "DMZ -> LAN bloque"

# Durcissement Nginx
curl -sI http://localhost:8080 | grep -qi "x-frame-options: deny" \
  && ok "En-tete X-Frame-Options" || ko "En-tete X-Frame-Options"
curl -sI http://localhost:8080 | grep -qi "^server: nginx/" \
  && ko "Version Nginx exposee" || ok "Version Nginx masquee"

exit $fail
