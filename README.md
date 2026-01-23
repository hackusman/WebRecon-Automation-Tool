🔎 WebRecon-Automation-Tool

WebRecon-Automation-Tool est un script Bash conçu pour automatiser les phases de reconnaissance offensive en pentest et bug bounty.
Il centralise plusieurs outils populaires afin de cartographier rapidement une cible (domaine ou URL) et d’identifier sa surface d’attaque.

«🎯 Objectif : gagner du temps, structurer la recon et éviter les oublis lors des phases initiales d’un audit.»

---

✨ Fonctionnalités

- 🔍 Découverte de sous-domaines
("subfinder", "assetfinder", "findomain", "httpx")

- 🧭 Crawling web
("katana")

- 🌐 Récupération d’URLs historiques
("waybackurls")

- 🚨 Scan de vulnérabilités
("nuclei")

- 📡 Scan de ports & services
("nmap")

- 🛡️ Scan applicatif
("nikto")

- 📸 Capture automatique de screenshots

- 📬 Scan des services mail
(SMTP, POP3, IMAP)

- ⚙️ Mode Full Automation
→ Lance toute la chaîne de reconnaissance en une seule commande.

---

📦 Prérequis

Avant d’exécuter le script, installe les dépendances suivantes :

sudo apt update && sudo apt install -y nmap nikto python3

- go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

- go install github.com/tomnomnom/assetfinder@latest

- go install github.com/OWASP/Amass/v3/...@latest

- go install github.com/tomnomnom/waybackurls@latest

- go install github.com/projectdiscovery/httpx/cmd/httpx@latest

- go install github.com/projectdiscovery/katana/cmd/katana@latest

- go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest


---

🚀 Installation

git clone https://github.com/hackusman/WebRecon-Automation-Tool.git
cd WebRecon-Automation-Tool
chmod +x recon.sh

---

▶️ Utilisation

./recon.sh

Puis :

- Choisir le type de cible : URL ou domaine
- Sélectionner les modules à lancer
- Ou utiliser le mode Full Automation

Le script se charge ensuite d’exécuter toute la chaîne de reconnaissance.

---

⚠️ Avertissement légal

Ce projet est fourni uniquement à des fins éducatives et professionnelles.

«❗ N’utilisez cet outil que sur des systèmes pour lesquels vous avez une autorisation explicite.
Toute utilisation illégale ou non autorisée est strictement interdite et relève de votre responsabilité.»

---

👨‍💻 Auteur

A2K (hackus_man)
Web Pentester - Bug Hunter

GitHub : https://github.com/hackusman

---

⭐ Contribution

Les contributions sont les bienvenues :

- Améliorations
- Nouveaux modules
- Optimisations
- Corrections

Fork → Commit → Pull Request 🚀